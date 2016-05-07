// # Bundle function
// Takes a root decorated class and generates a Module from it
'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});
exports['default'] = bundle;

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

var _writers = require('./writers');

var _classesModule = require('./classes/module');

var _classesModule2 = _interopRequireDefault(_classesModule);

var _eventsEvents = require('./events/events');

var _eventsEvents2 = _interopRequireDefault(_eventsEvents);

var _utilGroupModulesProviders = require('./util/group-modules-providers');

var _utilGroupModulesProviders2 = _interopRequireDefault(_utilGroupModulesProviders);

function bundle(moduleName, provider) {
    var _Module;

    var otherProviders = arguments.length <= 2 || arguments[2] === undefined ? [] : arguments[2];

    var getProvidersFrom = function getProvidersFrom(t) {
        return _writers.bundleStore.get('providers', t) || [];
    };
    var getModulesFrom = function getModulesFrom(t) {
        return _writers.bundleStore.get('modules', t) || [];
    };
    var setHasProviderWithToken = function setHasProviderWithToken(_set, token) {
        return [].concat(_toConsumableArray(_set)).filter(function (p) {
            return token && p.token === token;
        }).length > 0;
    };

    var _groupModulesAndProviders = (0, _utilGroupModulesProviders2['default'])([provider].concat(_toConsumableArray(otherProviders)), 'during bundle entry point for \'' + moduleName + '\' module');

    var startingModules = _groupModulesAndProviders.modules;
    var startingProviders = _groupModulesAndProviders.providers;

    var providers = new Set();
    var modules = new Set(startingModules);
    function parseProvider(provider) {
        if (provider) {
            if (providers.has(provider) || setHasProviderWithToken(providers, provider.token)) {
                return;
            }
            providers.add(provider);
            var annotated = provider.useClass || provider.useFactory || provider;
            getModulesFrom(annotated).forEach(function (mod) {
                return modules.add(mod);
            });
            getProvidersFrom(annotated).forEach(parseProvider);
        }
    }
    startingProviders.forEach(parseProvider);
    return (_Module = (0, _classesModule2['default'])(moduleName, [].concat(_toConsumableArray(modules)))).add.apply(_Module, _toConsumableArray(_eventsEvents2['default'].resolve()).concat(_toConsumableArray(providers)));
}

module.exports = exports['default'];
//# sourceMappingURL=bundle.js.map
