/**
 * Created by ajiang on 2017/6/6.
 */

Date.prototype.format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1, //月份
        "d+": this.getDate(), //日
        "h+": this.getHours(), //小时
        "m+": this.getMinutes(), //分
        "s+": this.getSeconds(), //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds() //毫秒
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
};

var cache = {};

var utils = {};

utils.download = function (data, obj, loading) {

    obj[loading] = true;

    var xhr = new XMLHttpRequest();

    xhr.open(data.method, data.action);
    xhr.responseType = "blob";
    xhr.onreadystatechange = function (e) {
        if (this.readyState == 4 && this.status == 200) {
            var header = this.getResponseHeader("Content-Disposition");
            var fileName = header.split("=")[1];

            fileName = decodeURI(fileName);

            if (typeof window.chrome !== 'undefined') {
                // Chrome version
                var link = document.createElement('a');
                link.href = window.URL.createObjectURL(this.response);
                link.download = fileName;
                link.click();
            } else if (typeof window.navigator.msSaveBlob !== 'undefined') {
                // IE version
                var blob = new Blob([this.response], {type: 'application/force-download'});
                window.navigator.msSaveBlob(blob, fileName);
            } else {
                // Firefox version
                var file = new File([this.response], fileName, {type: 'application/force-download'});
                window.open(URL.createObjectURL(file));
            }

            obj[loading] = false;
        }
    }

    if (data.enctype) {
        var fd = new FormData(data);
        xhr.send(fd);
    }
    else {
        xhr.send();
    }
}

utils.copyModel = function (source, target) {

    for (var key in target) {
        if (source[key] != null) {
            target[key] = source[key];
        }
    }

};

utils.copyBean = function (source, target) {

    for (var key in source) {
        target[key] = source[key];
    }

};

utils.getTreeItem = function (data, key, value) {

    for (var i = 0; i < data.length; i++) {
        var item = data[i];

        if (item.isLeaf) {
            if (item[key] == value) {
                return item;
            }
        }
        else {
            var result = utils.getTreeItem(item.children, key, value);

            if (result) {
                return result;
            }

        }
    }
};

utils.setTreeCheck = function (tree, checks) {
    for (var i = 0; i < checks.length; i++) {
        var check = checks[i];

        var item = utils.getTreeItem(tree, 'id', parseInt(check));

        item.checked = true;
    }
};

utils.getItem = function (list, key, value) {
    if (list) {
        var result = null;
        list.forEach(function (item) {
            if (item[key] == value) {
                result = item;
                return;
            }
        });

        return result;
    }
};

utils.dateFormat = function (time, fmt) {

    if (time == null) {
        return '';
    }

    if (fmt == null) {
        fmt = "yyyy-MM-dd hh:mm:ss";
    }

    return new Date(time).format(fmt);
};

utils.isEmpty = function (str) {
    return !$.trim(str);
};

utils.isNotEmpty = function (str) {
    return $.trim(str);
};

utils.get = function (url, data, success, obj, loading) {
    if (obj) {
        obj[loading] = true;
    }

    $.ajax({
        url: url,
        type: 'get',
        data: data,
        success: function (result) {
            if (obj) {
                obj[loading] = false;
            }

            success(result);
        },
        error: function () {
            if (obj) {
                obj[loading] = false;
            }
        }
    });
};

utils.post = function (url, data, success, obj, loading) {
    if (obj) {
        obj[loading] = true;
    }
    $.ajax({
        url: url,
        type: 'post',
        data: data,
        success: function (result) {
            if (obj) {
                obj[loading] = false;
            }
            success(result);
        },
        error: function () {
            if (obj) {
                obj[loading] = false;
            }
        }
    });
};

utils.postJson = function (url, data, success, obj, loading) {
    if (obj) {
        obj[loading] = true;
    }
    $.ajax({
        url: url,
        type: 'post',
        contentType: 'application/json',
        data: JSON.stringify(data),
        success: function (result) {
            if (obj) {
                obj[loading] = false;
            }
            success(result);
        },
        error: function () {
            if (obj) {
                obj[loading] = false;
            }
        }
    });
};

utils.listToMap = function (map, list, key) {
    for (var i = 0; i < list.length; i++) {
        var obj = list[i];

        if (obj.children) {
            utils.listToMap(map, obj.children, key);
        }
        else {
            map[obj[key]] = obj;
        }
    }
};

utils.guid = function () {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
};

utils.isDate = function (str) {
    var reg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/;
    var r = str.match(reg);
    if (r == null) return false;
    var d = new Date(r[1], r[3] - 1, r[4], r[5], r[6], r[7]);
    return (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[4] && d.getHours() == r[5] && d.getMinutes() == r[6] && d.getSeconds() == r[7]);
};