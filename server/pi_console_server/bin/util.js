'use strict';

const fs = require('fs');
const stream = require('stream');

/**
 * 数据包对象
 */
class DataPack {
    /**
     * @param {Number} tag 数据包标签
     * @param {Number} len 数据包长度
     * @param {Buffer} data 数据包内容
     */
    constructor(tag, len, data) {
        this._tag = tag;
        this._len = len;
        this._data = data;
    }

    get tag() {
        return this._tag;
    }

    set tag(tag) {
        this._tag = tag;
    }

    get len() {
        return this._len;
    }

    set len(len) {
        this._len = len;
    }

    get data() {
        return this._data;
    }

    set data(data) {
        this._data = data;
    }

    /**
     * 数据包打包，按照tag-len-data顺序
     * @returns {Buffer}
     */
    getBuffer() {
        let buf = Buffer.allocUnsafe(this._data.length + 3);
        this._data.copy(buf, 3);
        buf[0] = this._tag;
        buf[1] = Math.floor(this._len / 256);
        buf[2] = Math.floor(this._len % 256);
        return buf;
    }

    /**
     *  序列化为字符串
     */
    static writeToString(instance) {
        return instance.getBuffer().toString('hex');
    }

    /**
     * 从字符串反序列化
     */
    static readFromString(str) {
        let buf = Buffer.from(str, 'hex');
        return new DataPack(buf[0], buf[1] * 256 + buf[2], buf.slice(3));
    }
}


/**
 * 数据队列
 */
class DataQueue {
    constructor() {
        this._queue = Buffer.allocUnsafe(0);
    }

    /**
     * 将数据追加到队列
     * @param {Buffer} buf Buffer对象
     */
    append(buf) {
        this._queue = Buffer.concat([this._queue, buf]);
    }

    /**
     * 从前向后在队列中取出DataPack，如果队列中已经存在一包完整的数据则返回DataPack对象，否则返回undefined
     * @returns {Buffer|undefined}
     */
    getDataPack() {
        let q = this._queue;
        if (q.length < 3) {
            return undefined;
        }
        let tag = q[0];
        let len = q[1] * 256 + q[2];
        if (q.length < len + 3) {
            return undefined;
        }
        let data = Buffer.allocUnsafe(len);
        q.copy(data, 0, 3, 3 + len);
        this._queue = q.slice(len + 3);
        return new DataPack(tag, len, data);
    }
}

/**
 *  串口数据队列，跟DataQueue区别是会包含AT格式的数据包
 */
class SerialDataQueue extends DataQueue {
    constructor() {
        super();
    }

    /**
     * 从前向后在队列中取出SerialDataPack，如果队列中已经存在一包完整的数据则返回SerialDataPack对象，否则返回undefined
     * @returns {object}
     */
    getDataPack() {
        // console.log(this._queue.toString());
        let q = this._queue;
        if (q.length < 3) {
            return undefined;
        }
        // console.log('SerialDataQueue.getDataPack() q: ' + q.toString('hex'));
        if (q[0] == 43) { //+号开头
            let i = 0;
            while (true) {
                if (q.length <= 2 + i) {
                    return undefined;
                }
                if (q[1 + i] == 13 && q[2 + i] == 10) {
                    let str = q.toString('utf8', 0, 1 + i);
                    this._queue = q.slice(3 + i);
                    return {
                        type: 2,
                        data: str
                    };
                }
                i++;
            }
        }
        else if (q[0] == 79 && q[1] == 75) { //OK开头
            if (q.length < 4) {
                return undefined;
            }
            let i = 0;
            while (true) {
                if (q.length <= 3 + i) {
                    return undefined;
                }
                if (q[2 + i] == 13 && q[3 + i] == 10) {
                    let str = q.toString('utf8', 0, 2 + i);
                    this._queue = q.slice(4 + i);
                    return {
                        type: 2,
                        data: str
                    };
                }
                i++;
            }
        }
        let tag = q[0];
        let len = q[1] * 256 + q[2];
        if (q.length < len + 3) {
            return undefined;
        }
        let data = Buffer.allocUnsafe(len);
        q.copy(data, 0, 3, 3 + len);
        this._queue = q.slice(len + 3);
        // console.log('recv: ' + data.toString());
        return {
            type: 1,
            data: new DataPack(tag, len, data)
        };
    }
}

/**
 * 带文件缓存的队列，数据量大时会把内存中的队列数据缓存到文件
 */
class CachePackQueue {
    constructor() {
        this._inQueue = Buffer.allocUnsafe(0);
        this._outQueue = Buffer.allocUnsafe(0);
        this._fileList = [];
        this._maxLengthOneTime = 100;
        this._threshold = 1024 * 1024;
    }

    _checkStashData() {
        if (this._inQueue.length > this._threshold) {
            let contentBuf = this._inQueue.slice(0, this._threshold);
            this._inQueue = this._inQueue.slice(this._threshold);
            let file = '/tmp/pi_console_server_' + new Date().getTime() + '.tmp';
            try {
                fs.writeFileSync(file, contentBuf);
                this._fileList.push(file);
            }
            catch (e) {
            }
        }
    }

    _checkApplyData() {
        let self = this;
        if (this._outQueue.length == 0) {
            if (this._fileList.length > 0) {
                let file = this._fileList.shift();
                try {
                    let contentBuf = fs.readFileSync(file);
                    this._outQueue = Buffer.concat([this._outQueue, contentBuf]);
                }
                catch (e) {
                }
                try {
                    fs.unlinkSync(file);
                }
                catch (e) {
                }
            }
            else if (this._inQueue.length > 0) {
                this._outQueue = Buffer.concat([this._outQueue, this._inQueue]);
                this._inQueue = Buffer.allocUnsafe(0);
            }
        }
    }

    get length() {
        this._checkApplyData();
        return this._outQueue.length;
    }

    append(pack) {
        if (this._outQueue.length < this._threshold && this._inQueue.length == 0 && this._fileList.length == 0) {
            this._outQueue = Buffer.concat([this._outQueue, pack.getBuffer()]);
        }
        else {
            this._inQueue = Buffer.concat([this._inQueue, pack.getBuffer()]);
        }
        this._checkStashData();
    }

    getBuffer() {
        this._checkApplyData();
        if (this._outQueue.length > 0) {
            let buf;
            if (this._outQueue.length > this._maxLengthOneTime) {
                buf = this._outQueue.slice(0, this._maxLengthOneTime);
                this._outQueue = this._outQueue.slice(this._maxLengthOneTime);
            }
            else {
                buf = this._outQueue;
                this._outQueue = Buffer.allocUnsafe(0);
            }
            return buf;
        }
        else {
            return undefined;
        }
    }

    clearTmpFiles() {
        this._fileList.forEach(file => {
            try {
                fs.unlinkSync(file);
            }
            catch (e) {
            }
        });
    }
}

// class BufferQueue {
//     constructor() {
//         this._queue = [];
//         this._length = 0;
//     }

//     get length() {
//         return this._length;
//     }

//     append(pack) {
//         let buf = pack.getBuffer();
//         this._queue.push(buf);
//         this._length += buf.length;
//     }

//     getBuffer(bytes) {
//         if (this._length == 0 || bytes == 0) {
//             return undefined;
//         }
//         var data = Buffer.concat(this._queue, this._length);
//         if (bytes == this._length) {
//             this.clear();
//             return data;
//         }
//         bytes = bytes > this._length ? this._length : bytes;
//         var front = data.slice(0, bytes);
//         this.clear();
//         let after = data.slice(bytes);
//         this._queue.push(after);
//         this._length = after.length;
//         return front;
//     }

//     clear() {
//         this._queue = [];
//         this._length = 0;
//     }
// }

class BufferQueue {
    constructor() {
        this._queue = [];
        this._index = 0;
        this._length = 0;
        this._bufferSize = 8192;

        this._queue.push(Buffer.allocUnsafe(this._bufferSize));
    }

    _writeByteToIndex(num, idx) {
        let bIdx = Math.floor(idx / this._bufferSize);
        let iIdx = idx % this._bufferSize;
        while (bIdx > this._queue.length - 1) {
            this._queue.push(Buffer.allocUnsafe(this._bufferSize));
        }
        this._queue[bIdx][iIdx] = num;
    }

    _getByteFromIndex(idx) {
        let bIdx = Math.floor(idx / this._bufferSize);
        let iIdx = idx % this._bufferSize;
        return this._queue[bIdx][iIdx];
    }

    _checkRelease() {
        let bIdx = Math.floor(this._index / this._bufferSize);
        while (Math.floor(this._index / this._bufferSize) > 0) {
            this._queue.shift();
            this._index -= this._bufferSize;
        }
    }

    get length() {
        return this._length;
    }

    append(pack) {
        let buf = pack.getBuffer();
        let idx = this._index + this._length;
        for (let i = 0; i < buf.length; i++) {
            this._writeByteToIndex(buf[i], idx);
            idx++;
        }
        this._length += buf.length;
    }

    getBuffer(bytes) {
        if (this._length == 0 || bytes == 0) {
            return undefined;
        }
        bytes = bytes > this._length ? this._length : bytes;
        let buf = Buffer.allocUnsafe(bytes);
        for (let i = 0; i < buf.length; i++) {
            buf[i] = this._getByteFromIndex(this._index);
            this._index++;
        }
        this._length -= bytes;
        this._checkRelease();
        return buf;
    }

    clear() {
        this._queue = [];
        this._index = 0;
        this._length = 0;
        this._queue.push(Buffer.allocUnsafe(this._bufferSize));
    }
}

module.exports = {
    DataPack: DataPack,
    DataQueue: DataQueue,
    SerialDataQueue: SerialDataQueue,
    CachePackQueue: CachePackQueue,
    BufferQueue: BufferQueue
}