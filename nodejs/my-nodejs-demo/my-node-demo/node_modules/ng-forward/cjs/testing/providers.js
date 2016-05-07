'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

var _classesProvider = require('../classes/provider');

var _providers = [];
var providers = function providers(provideFn) {
    return isSpecRunning() ? workFn() : workFn;
    function workFn() {
        var _providers2;

        (_providers2 = _providers).push.apply(_providers2, _toConsumableArray(provideFn(_classesProvider.provide)));
    }
};
exports.providers = providers;
var allProviders = function allProviders() {
    return _providers;
};
exports.allProviders = allProviders;
var clearProviders = function clearProviders() {
    _providers = [];
};
exports.clearProviders = clearProviders;
var currentSpec = null;
function isSpecRunning() {
    return !!currentSpec;
}
if (window.jasmine || window.mocha) {
    (window.beforeEach || window.setup)(function () {
        currentSpec = this;
    });
    (window.afterEach || window.teardown)(function () {
        currentSpec = null;
    });
}
//# sourceMappingURL=providers.js.map
