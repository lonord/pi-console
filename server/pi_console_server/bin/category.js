Date.prototype.format = function(fmt){
    var o = {
        "M+" : this.getMonth()+1,                 //月份
        "d+" : this.getDate(),                    //日
        "h+" : this.getHours(),                   //小时
        "m+" : this.getMinutes(),                 //分
        "s+" : this.getSeconds(),                 //秒
        "q+" : Math.floor((this.getMonth()+3)/3), //季度
        "S"  : this.getMilliseconds()             //毫秒
    };

    if(/(y+)/.test(fmt))
        fmt=fmt.replace(RegExp.$1, (this.getFullYear().toString()).substr(4 - RegExp.$1.length));
    for(var k in o)
        if(new RegExp("("+ k +")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
    return fmt;
};

Array.prototype.contains = function (obj) {
    var i = this.length;
    while (i--) {
        if (this[i] === obj) {
            return true;
        }
    }
    return false;
};

/**
 * 格式化时间
 * @param timestamp 秒为单位
 */
Date.parseTime = function (timestamp) {
    var tsNow = Math.floor(new Date().getTime() / 1000);
    var timeSpan = tsNow - timestamp;
    if (timeSpan < 3600) {
        return Math.floor(timeSpan / 60) + ' 分钟前';
    }
    if (timeSpan < 3600 * 24) {
        return Math.floor(timeSpan / 3600) + ' 小时前';
    }
    if (timeSpan < 3600 * 24 * 30) {
        return Math.floor(timeSpan / 3600 / 24) + ' 天前';
    }
    if (timeSpan < 3600 * 24 * 30 * 12) {
        return Math.floor(timeSpan / 3600 / 24 / 30) + ' 个月前';
    }
    return new Date(timestamp * 1000).format('yyyy-MM-dd');
};

/*******base64*********/
global.Base64 = {
    encode: function (str) {
        return new Buffer(str).toString('base64');
    },
    decode: function (base64) {
        return new Buffer(base64, 'base64').toString();
    },
    encodeJSON: function (obj) {
        var json = JSON.stringify(obj);
        return new Buffer(json).toString('base64');
    },
    decodeJSON: function (base64) {
        var json = new Buffer(base64, 'base64').toString();
        return JSON.parse(json);
    }
};