'use strict';

const os = require('os');
const fs = require('fs');
const child_process = require('child_process');

const INFO = require('./info.json');
const pty = require('pty.js');
const SerialPort = require('serialport');

const DataPack = require('./util.js').DataPack;
const DataQueue = require('./util.js').DataQueue;
const SerialDataQueue = require('./util.js').SerialDataQueue;
const CachePackQueue = require('./util.js').CachePackQueue;
const BufferQueue = require('./util.js').BufferQueue;

const addone = {};
try {
    addone.gpio = require('./addone/gpio.js');
    console.log(`*** ADDONE gpio loaded...`);
} catch (e) {
    console.log(`### ADDONE gpio not found...`);
}

class BasicHandler {
    constructor(queue) {
        this._dataPackRecvHandler;
    }

    _sendDataPackToReceiver(data) {
        if (!this._dataPackRecvHandler) {
            return false;
        }
        return this._dataPackRecvHandler(data);
    }

    setDataPackReceiver(handlerFunc) {
        this._dataPackRecvHandler = handlerFunc;
    }

    putDataPack(dataPack) {
        //need implement
    }

    acceptDataPackTags() {
        //need implement
    }

    exit() {
        //need implement
    }
}

class BasicSubHandler extends BasicHandler {
    constructor() {
        super();
    }

    deviceConnected() {
        //need implement
    }

    deviceDisconnected() {
        //need implement
    }
}

class PtyHandler extends BasicSubHandler {
    constructor(num) {
        super();
        this._dataTag = 0xF0 | num;
        this._ctrlTag = 0xE0 | num;
        this._term;
        this._termCols = 80;
        this._termRows = 24;
        this._lastLineBuf = Buffer.allocUnsafe(0);
        this._openTerm();
        console.log(`*** PtyHandler ${num} loaded...`);
    }

    _openTerm() {
        let self = this;
        if (this._term) {
            this._term.destroy();
        }
        let env_var = process.env;
        delete env_var.env;
        this._term = pty.spawn('bash', [], {
            name: 'xterm-256color',
            cols: this._termCols,
            rows: this._termRows,
            cwd: process.env.HOME,
            env: env_var
        });
        this._term.on('data', data => {
            self._termDataRecv(data);
        });
    }

    _termDataRecv(data) {
        let b = data;
        if (!Buffer.isBuffer(b)) {
            b = Buffer.from(b, 'utf8');
        }
        let i = 0, s = 0;
        while (true) {
            if (i >= b.length - 1) {
                if (s == 0) {
                    this._lastLineBuf = Buffer.concat([this._lastLineBuf, b]);
                }
                else if (s == b.length) {
                    this._lastLineBuf = Buffer.allocUnsafe(0);
                }
                else if (s < b.length) {
                    this._lastLineBuf = b.slice(s, b.length);
                }
                break;
            }
            if (b[i] == 0x0D && b[i + 1] == 0x0A) {
                // \r\n
                s = i + 2;
            }
            i++;
        }
        let pack = new DataPack(this._dataTag, b.length, b);
        this._sendDataPackToReceiver(pack);
    }

    _sendPrompt() {
        if (this._lastLineBuf.length > 0) {
            let pack = new DataPack(this._dataTag, this._lastLineBuf.length, this._lastLineBuf);
            this._sendDataPackToReceiver(pack);
        }
    }

    putDataPack(dataPack) {
        if (dataPack.len == 0 || dataPack.data.length !== dataPack.len) {
            return;
        }
        let dataLen = dataPack.len;
        if (dataPack.tag == this._dataTag) {
            if (dataLen < 1) {
                return;
            }
            let str = dataPack.data.toString('utf8');
            this._term.write(str);
        }
        else if (dataPack.tag == this._ctrlTag) {
            if (dataLen < 1) {
                return;
            }
            let type = dataPack.data[0];
            if (type == 1 && dataLen >= 5) {
                this._termCols = dataPack.data[1] * 256 + dataPack.data[2];
                this._termRows = dataPack.data[3] * 256 + dataPack.data[4];
                this._term.resize(this._termCols, this._termRows);
            }
            else if (type == 2) {
                this._openTerm();
            }
            else if (type == 3) {
                this._sendPrompt();
            }
        }
    }

    acceptDataPackTags() {
        return [
            this._dataTag, //数据tag
            this._ctrlTag  //控制tag
        ];
    }

    exit() {
        if (this._term) {
            this._term.destroy();
        }
    }
}

class SysInfoHandler extends BasicSubHandler {
    constructor() {
        super();
        this._tag = 0xA1;
        this._lastCpus;
        this._timerId;
        console.log('*** SysInfoHandler loaded...');
    }

    _rolling() {
        if (this._lastCpus) {
            let memTotal = os.totalmem();
            let memNow = memTotal - os.freemem();
            let memPercent = Math.floor(memNow / memTotal * 100);
            if (memPercent >= 100) {
                memPercent = 99;
            }
            
            let thisCpus = os.cpus();
            let cpu = 0;
            for (let i = 0; i < thisCpus.length; i++) {
                let d = thisCpus[i].times.user - this._lastCpus[i].times.user;
                d += thisCpus[i].times.nice - this._lastCpus[i].times.nice;
                d += thisCpus[i].times.sys - this._lastCpus[i].times.sys;
                d += thisCpus[i].times.irq - this._lastCpus[i].times.irq;
                let t = thisCpus[i].times.idle - this._lastCpus[i].times.idle;
                cpu += d / (d + t);
            }
            let cpuPercent = Math.floor(cpu * 100);

            let batt;
            try {
                let battFileStr = fs.readFileSync('/var/local/battery');
                batt = parseInt(battFileStr);
            }
            catch (e) {
                batt = 0xFF;
            }

            let buf = Buffer.allocUnsafe(4);
            buf[0] = Math.floor(cpuPercent / 256);
            buf[1] = Math.floor(cpuPercent % 256);
            buf[2] = memPercent;
            buf[3] = batt;
            let pack = new DataPack(this._tag, buf.length, buf);
            this._sendDataPackToReceiver(pack);
            this._lastCpus = thisCpus;
        }
        else {
            this._lastCpus = os.cpus();
        }
    }

    deviceConnected() {
        this._lastTime = undefined;
        this._lastCpus = undefined;
        this._rolling();
        let self = this;
        this._timerId = setInterval(() => {
            self._rolling();
        }, 5000);
    }

    deviceDisconnected() {
        clearInterval(this._timerId);
    }

    acceptDataPackTags() {
        return this._tag;
    }

    exit() {
        clearInterval(this._timerId);
    }
}

class TimeHandler extends BasicSubHandler {
    constructor() {
        super();
        this._tag = 0xA2;
        console.log('*** TimeHandler loaded...');
    }

    putDataPack(dataPack) {
        if (dataPack.len == 0 || dataPack.data.length !== dataPack.len || dataPack.len < 4) {
            return;
        }
        let timestamp = dataPack.data[0] << 24;
        timestamp += dataPack.data[1] << 16;
        timestamp += dataPack.data[2] << 8;
        timestamp += dataPack.data[3];
        let now = new Date();
        let nowStamp = now.getTime();
        if (Math.abs(nowStamp - timestamp * 1000) > 60 * 1000) {
            let d = new Date(timestamp * 1000);
            let dateStr = d.format('yyyy-MM-dd hh:mm:ss');
            let sysDateStr = now.format('yyyy-MM-dd hh:mm:ss');
            let logStr = '*** TimeHandler set new date to ' + dateStr + ' (original ' + sysDateStr + ')...';
            try {
                child_process.execSync(`date -s "${dateStr}"`);
                // child_process.execSync('clock –w');
                console.log(logStr + ' success');
            }
            catch (e) {
                console.log(logStr + ' failed: ' + e);
            }
        }
    }

    acceptDataPackTags() {
        return this._tag;
    }
}

class PowerHandler extends BasicSubHandler {
    constructor() {
        super();
        this._tag = 0xA3;
        console.log('*** PowerHandler loaded...');
    }

    putDataPack(dataPack) {
        if (dataPack.len == 0 || dataPack.data.length !== dataPack.len) {
            return;
        }
        let type = dataPack.data[0];
        if (type == 1) {
            //shutdown
            addone.gpio && addone.gpio.resetBT();
            child_process.exec('shutdown -h now', () => {});
        }
        else if (type == 2) {
            //restart
            addone.gpio && addone.gpio.resetBT();
            child_process.exec('shutdown -r now', () => {});
        }
    }

    acceptDataPackTags() {
        return this._tag;
    }
}

class UartHandler extends BasicHandler {
    constructor() {
        super();
        let self = this;
        this._dataQueue = new SerialDataQueue();
        // this._sendQueue = new CachePackQueue();
        this._sendQueue = new BufferQueue();
        this._intervalId;
        this._isSending = false;
        this._btConnected = false;
        this._deviceConnectListener;
        this._deviceDisconnectListener;
        this._sendBatchSize = 20;
        this._sendBatchInterval = 10;
        this._port = new SerialPort(INFO.serial, {
            baudRate: 115200
        }, err => {
            self._connectCB(err);
        });
        console.log('*** UartHandler loaded...');
    }

    _connectCB(err) {
        let self = this;
        if (err) {
            throw new Error('Serialport open error: ' + err.message);
        }
        this._port.on('data', data => {
            self._portDataRecv(data);
            // console.log('port recv: ' + data.toString('hex'));
            // console.log('port recv: ' + data.toString());
        });
        setTimeout(function() {
            self._sendBTStartCmd();
        }, 1000);
    }

    _sendBTStartCmd() {
        this._port.write('AT+START\r\n');
    }

    _portDataRecv(data) {
        this._dataQueue.append(data);
        this._startRoll();
    }

    _startRoll() {
        let self = this;
        if (this._intervalId) {
            return;
        }
        if (this._dataPackRecvHandler) {
            this._intervalId = setInterval(() => {
                self._dataGettingRoll();
            }, 0);
        }
    }

    _stopRoll() {
        if (this._intervalId) {
            clearInterval(this._intervalId);
            this._intervalId = undefined;
        }
    }

    _dataGettingRoll() {
        let dataPackObj = this._dataQueue.getDataPack();
        if (dataPackObj) {
            if (dataPackObj.type == 1) {
                this._sendDataPackToReceiver(dataPackObj.data);
            }
            else if (dataPackObj.type == 2) {
                this._dealATCommand(dataPackObj.data);
            }
        }
        else {
            this._stopRoll();
        }
    }

    _dealATCommand(cmdStr) {
        if (cmdStr == 'OK+CONN') {
            this._onBtConnected();
        }
        else if (cmdStr == 'OK+LOST') {
            this._onBtDisConnected();
        }
    }

    _onBtConnected() {
        console.log('*** BTConnected...');
        let self = this;
        this._btConnected = true;
        this._deviceConnectListener && this._deviceConnectListener();
    }

    _onBtDisConnected() {
        console.log('*** BTDisconnected...');
        this._btConnected = false;
        this._deviceDisconnectListener && this._deviceDisconnectListener();
        this._sendQueue.clear && this._sendQueue.clear();
    }

    _sendRoll() {
        if (!this._btConnected) {
            this._isSending = false;
            return;
        }
        let sendBuf = this._sendQueue.getBuffer(this._sendBatchSize);
        if (sendBuf) {
            let self = this;
            // console.log('Uart << [' + sendBuf.length + '] ' + sendBuf.toString('hex'));
            this._port.write(sendBuf, err => {
                self._sendRollCallback(err);
            });
        }
        else {
            this._isSending = false;
        }
    }

    _sendRollCallback(err) {
        let self = this;
        setTimeout(() => {
            self._sendRoll();
        }, this._sendBatchInterval);
    }

    set deviceConnectListener(listener) {
        this._deviceConnectListener = listener;
    }

    set deviceDisconnectListener(listener) {
        this._deviceDisconnectListener = listener;
    }

    putDataPack(dataPack) {
        if (!this._btConnected) {
            return false;
        }
        this._sendQueue.append(dataPack);
        if (!this._isSending) {
            this._isSending = true;
            this._sendRoll();
        }
        return true;
    }

    exit() {
        this._sendQueue.clearTmpFiles && this._sendQueue.clearTmpFiles();
        this._port.close();
        addone.gpio && addone.gpio.resetBT();
    }
}

module.exports = {
    BasicHandler: BasicHandler,
    BasicSubHandler: BasicSubHandler,
    PtyHandler: PtyHandler,
    SysInfoHandler: SysInfoHandler,
    TimeHandler: TimeHandler,
    PowerHandler: PowerHandler,
    UartHandler: UartHandler
}