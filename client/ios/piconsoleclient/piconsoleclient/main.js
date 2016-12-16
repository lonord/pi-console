var term;
var terminalContainer = document.getElementById('terminal-container');

var keyMap = {
    key_esc: {
        keyCode: 27
    },
    key_backspace: {
        keyCode: 8
    },
    key_del: {
        keyCode: 46
    },
    key_tab: {
        keyCode: 9
    },
    key_enter: {
        keyCode: 13
    },
    key_up: {
        keyCode: 38
    },
    key_down: {
        keyCode: 40
    },
    key_left: {
        keyCode: 37
    },
    key_right: {
        keyCode: 39
    },
    key_home: {
        keyCode: 36
    },
    key_end: {
        keyCode: 35
    },
    key_pgup: {
        keyCode: 33
    },
    key_pgdown: {
        keyCode: 34
    },

    /* key_f1 ~ key_f12 */

    key_grave: {
        keyCode: 192,
        charCode: 96
    },
    key_1: {
        charCode: 49
    },
    key_2: {
        charCode: 50
    },
    key_3: {
        charCode: 51
    },
    key_4: {
        charCode: 52
    },
    key_5: {
        charCode: 53
    },
    key_6: {
        charCode: 54
    },
    key_7: {
        charCode: 55
    },
    key_8: {
        charCode: 56
    },
    key_9: {
        charCode: 57
    },
    key_0: {
        charCode: 48
    },
    key_minus: {
        keyCode: 189,
        charCode: 45
    },
    key_equal: {
        keyCode: 187,
        charCode: 61
    },
    key_left_brace: {
        keyCode: 219,
        charCode: 91
    },
    key_right_brace: {
        keyCode: 221,
        charCode: 93
    },
    key_back_slash: {
        keyCode: 220,
        charCode: 92
    },
    key_semicolon: {
        keyCode: 186,
        charCode: 59
    },
    key_apostrophe: {
        keyCode: 222,
        charCode: 39
    },
    key_comma: {
        keyCode: 188,
        charCode: 44
    },
    key_dot: {
        keyCode: 190,
        charCode: 46
    },
    key_slash: {
        keyCode: 191,
        charCode: 47
    },

    key_grave_2: {
        keyCode: 192,
        charCode: 126
    },
    key_1_2: {
        keyCode: 49,
        charCode: 33
    },
    key_2_2: {
        keyCode: 50,
        charCode: 64
    },
    key_3_2: {
        keyCode: 51,
        charCode: 35
    },
    key_4_2: {
        keyCode: 52,
        charCode: 36
    },
    key_5_2: {
        keyCode: 53,
        charCode: 37
    },
    key_6_2: {
        keyCode: 54,
        charCode: 94
    },
    key_7_2: {
        keyCode: 55,
        charCode: 38
    },
    key_8_2: {
        keyCode: 56,
        charCode: 42
    },
    key_9_2: {
        keyCode: 57,
        charCode: 40
    },
    key_0_2: {
        keyCode: 48,
        charCode: 41
    },
    key_minus_2: {
        keyCode: 189,
        charCode: 95
    },
    key_equal_2: {
        keyCode: 187,
        charCode: 43
    },
    key_left_brace_2: {
        keyCode: 219,
        charCode: 123
    },
    key_right_brace_2: {
        keyCode: 221,
        charCode: 125
    },
    key_back_slash_2: {
        keyCode: 220,
        charCode: 124
    },
    key_semicolon_2: {
        keyCode: 186,
        charCode: 58
    },
    key_apostrophe_2: {
        keyCode: 222,
        charCode: 34
    },
    key_comma_2: {
        keyCode: 188,
        charCode: 60
    },
    key_dot_2: {
        keyCode: 190,
        charCode: 62
    },
    key_slash_2: {
        keyCode: 191,
        charCode: 63
    },

    key_space: {
        charCode: 32
    }

    /* key_A ~ key_Z  key_a ~ key_z */
};

for (var i = 0; i < 26; i++) {
    var upper = String.fromCharCode(65 + i);
    keyMap['key_' + upper] = {
        charCode: 65 + i
    };
    var lower = String.fromCharCode(97 + i);
    keyMap['key_' + lower] = {
        keyCode: 65 + i,
        charCode: 97 + i
    };
}

for (var i = 1; i <= 12; i++) {
    var fn = 'key_f' + i;
    keyMap[fn] = 111 + i;
}

createTerminal();

function createTerminal() {
    var resizeTimerId;
    // Clean terminal
    while (terminalContainer.children.length) {
        terminalContainer.removeChild(terminalContainer.children[0]);
    }
    term = new Terminal({
        cursorBlink: true
    });
    term.on('resize', function (size) {
        var cols = size.cols,
            rows = size.rows;
        console.log('term resize to ' + cols + ' x ' + rows);
        try {
            objcResize(cols, rows);
        } catch (e) {
            console.error(e);
        }
    });

    term.open(terminalContainer);
    term.fit();

    window.onresize = function () {
        if (resizeTimerId) {
            clearTimeout(resizeTimerId);
        }
        resizeTimerId = setTimeout(doResize, 200);
    };

    term.on('data', function (data) {
        // try {
            objcSendData(data);
        // } catch (e) {
        //     console.error(e);
        // }
    });

    function doResize() {
        term.fit();
        resizeTimerId = undefined;
    }
}

// var sendTimerId;
// var sendQueue = [];

function sendData(str) {
    // sendQueue.push(str);
    // if (sendTimerId) {
    //     return;
    // }
    // sendTimerId = setInterval(function() {
    //     if (sendQueue.length == 0) {
    //         clearInterval(sendTimerId);
    //         sendTimerId = undefined;
    //         return;
    //     }
    //     term.write(sendQueue.shift());
    // }, 30);
    setTimeout(function() {
        term.write(str);
    }, 1);
}

function requestTermFit() {
    setTimeout(function() {
        var initialGeometry = term.proposeGeometry(),
            cols = initialGeometry.cols,
            rows = initialGeometry.rows;
        try {
            objcResize(cols, rows);
        } catch (e) {
            console.error(e);
        }
    }, 1);
}

function sendKey(key, flag) {
    var m = keyMap[key];
    if (!m) {
        return;
    }
    if (!m.keyCode) {
        m.keyCode = m.charCode;
    }
    m.preventDefault = function(){};
    m.stopPropagation = function(){};
    m.shiftKey = (flag & 0x01) == 0x01;
    m.ctrlKey = (flag & 0x02) == 0x02;
    m.altKey = (flag & 0x04) == 0x04;
    m.metaKey = false;
    m.type = 'keydown';
    term.keyDown(m);
    if (!m.charCode) {
        return;
    }
    var m2 = {};
    for (var k in m) {
        m2[k] = m[k];
    }
    m2.type = 'keypress';
    term.keyPress(m2);
}
