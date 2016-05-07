'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});
exports.Providers = Providers;

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

var _writers = require('../writers');

var _utilGroupModulesProviders = require('../util/group-modules-providers');

var _utilGroupModulesProviders2 = _interopRequireDefault(_utilGroupModulesProviders);

function Providers() {
    for (var _len = arguments.length, modulesAndProviders = Array(_len), _key = 0; _key < _len; _key++) {
        modulesAndProviders[_key] = arguments[_key];
    }

    return function (t) {
        var errorContext = arguments.length <= 1 || arguments[1] === undefined ? 'while parsing ' + t.name + '\'s providers' : arguments[1];
        return (function () {
            var _groupIntoModulesAndProviders = (0, _utilGroupModulesProviders2['default'])(modulesAndProviders, errorContext);

            var modules = _groupIntoModulesAndProviders.modules;
            var providers = _groupIntoModulesAndProviders.providers;

            var parentModules = _writers.bundleStore.get('modules', t) || [];
            _writers.bundleStore.set('modules', [].concat(_toConsumableArray(modules), _toConsumableArray(parentModules)), t);
            var parentProviders = _writers.bundleStore.get('providers', t) || [];
            _writers.bundleStore.set('providers', [].concat(_toConsumableArray(providers), _toConsumableArray(parentProviders)), t);
        })();
    };
}
//# sourceMappingURL=providers.js.map
