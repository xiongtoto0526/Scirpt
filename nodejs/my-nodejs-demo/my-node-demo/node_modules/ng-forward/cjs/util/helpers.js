'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});
exports.ucFirst = ucFirst;
exports.dashToCamel = dashToCamel;
exports.dasherize = dasherize;
exports.snakeCase = snakeCase;
exports.flatten = flatten;
exports.createConfigErrorMessage = createConfigErrorMessage;

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

var SNAKE_CASE_REGEXP = /[A-Z]/g;

function ucFirst(word) {
    return '' + word.charAt(0).toUpperCase() + word.substring(1);
}

function dashToCamel(dash) {
    var words = dash.split('-');
    return '' + words.shift() + words.map(ucFirst).join('');
}

function dasherize(name) {
    var separator = arguments.length <= 1 || arguments[1] === undefined ? '-' : arguments[1];

    return name.replace(SNAKE_CASE_REGEXP, function (letter, pos) {
        return '' + (pos ? separator : '') + letter.toLowerCase();
    });
}

function snakeCase(name) {
    var separator = arguments.length <= 1 || arguments[1] === undefined ? '-' : arguments[1];

    return name.replace(SNAKE_CASE_REGEXP, function (letter, pos) {
        return '' + (pos ? separator : '') + letter.toLowerCase();
    });
}

function flatten(items) {
    var resolved = [];
    var _iteratorNormalCompletion = true;
    var _didIteratorError = false;
    var _iteratorError = undefined;

    try {
        for (var _iterator = items[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
            var item = _step.value;

            if (Array.isArray(item)) {
                resolved.push.apply(resolved, _toConsumableArray(flatten(item)));
            } else {
                resolved.push(item);
            }
        }
    } catch (err) {
        _didIteratorError = true;
        _iteratorError = err;
    } finally {
        try {
            if (!_iteratorNormalCompletion && _iterator['return']) {
                _iterator['return']();
            }
        } finally {
            if (_didIteratorError) {
                throw _iteratorError;
            }
        }
    }

    return resolved;
}

function createConfigErrorMessage(target, ngModule, message) {
    return 'Processing "' + target.name + '" in "' + ngModule.name + '": ' + message;
}
//# sourceMappingURL=helpers.js.map
