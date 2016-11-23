'use strict';

const SerialPort = require('serialport');
const INFO = require('./bin/info.json');

const INTEVAL = 200;

let baudrate = 9600;
if (process.argv.length > 2) {
    baudrate = parseInt(process.argv[2]);
}

const port = new SerialPort(INFO.serial, {
    baudrate: baudrate,
    parser: SerialPort.parsers.byteDelimiter([13,10])
});

port.on('open', function() {
    let portReceiver;
    port.on('data', function(data) {
        let buf = Buffer.from(data);
        let str = buf.slice(0, buf.length - 2).toString();
        console.log('<< ' + str);
        portReceiver && portReceiver(str);
    });

    function writeSerial(str) {
        console.log('>> ' + str);
        port.write(str + '\r\n');
    }

    setName();

    function setName() {
        portReceiver = str => {
            let addr = str.substring(str.length - 5, str.length - 3) + str.substring(str.length - 2, str.length);
            let name = 'PI-CONSOLE-' + addr.toUpperCase();
            portReceiver = undefined;
            writeSerial('AT+NAME' + name);
            setTimeout(function() {
                setPairCode();
            }, INTEVAL);
        };
        writeSerial('AT+LADDR');
    }
    
    function setPairCode() {
        writeSerial('AT+PIN000000');
        setTimeout(function() {
            setWorkType();
        }, INTEVAL);
    }

    function setWorkType() {
        writeSerial('AT+TYPE0');
        setTimeout(function() {
            setNofity();
        }, INTEVAL);
    }

    function setNofity() {
        writeSerial('AT+NOTI1');
        setTimeout(function() {
            setWorkStartType();
        }, INTEVAL);
    }

    function setWorkStartType() {
        writeSerial('AT+IMME1');
        setTimeout(function() {
            setServiceUUID();
        }, INTEVAL);
    }

    function setServiceUUID() {
        writeSerial('AT+UUID0xFFE0');
        setTimeout(function() {
            setCharUUID();
        }, INTEVAL);
    }

    function setCharUUID() {
        writeSerial('AT+CHAR0xFFE1');
        setTimeout(function() {
            setiBeaconSwitch();
        }, INTEVAL);
    }

    function setiBeaconSwitch() {
        writeSerial('AT+IBEA0');
        setTimeout(function() {
            setRole();
        }, INTEVAL);
    }

    function setRole() {
        writeSerial('AT+ROLE0');
        setTimeout(function() {
            setStop();
        }, INTEVAL);
    }

    function setStop() {
        writeSerial('AT+STOP0');
        setTimeout(function() {
            setVerify();
        }, INTEVAL);
    }

    function setVerify() {
        writeSerial('AT+PARI0');
        setTimeout(function() {
            setBaudrate();
        }, INTEVAL);
    }

    function setBaudrate() {
        writeSerial('AT+BAUD8');
        setTimeout(function() {
            console.log('***** set complete *****');
            port.close();
        }, INTEVAL);
    }

});

// open errors will be emitted as an error event
port.on('error', function(err) {
    console.log('Error: ', err.message);
});
