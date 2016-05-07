'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});
exports['default'] = groupModulesAndProviders;

var _writers = require('../writers');

var _helpers = require('./helpers');

var _classesProvider = require('./../classes/provider');

var STRING_TEST = function STRING_TEST(a) {
    return typeof a === 'string';
};
var PROVIDER_TEST = function PROVIDER_TEST(a) {
    return (typeof a === 'function' || a instanceof _classesProvider.Provider) && _writers.providerStore.has('name', a);
};

function groupModulesAndProviders(modulesAndProviders) {
    var errorContext = arguments.length <= 1 || arguments[1] === undefined ? 'while analyzing providers' : arguments[1];

    modulesAndProviders = (0, _helpers.flatten)(modulesAndProviders);
    var modules = modulesAndProviders.filter(STRING_TEST);
    var providers = modulesAndProviders.filter(PROVIDER_TEST);
    var invalid = modulesAndProviders.filter(function (a) {
        return !STRING_TEST(a);
    }).filter(function (a) {
        return !PROVIDER_TEST(a);
    });
    if (invalid.length > 0) {
        throw new TypeError('TypeError ' + errorContext + '.\n    Invalid Providers: please make sure all providers are an Injectable(), Component(), Directive(), a Provider, or a module string.\n    Here\'s the invalid values: ' + invalid.join(', '));
    }
    return { modules: modules, providers: providers };
}

module.exports = exports['default'];
//# sourceMappingURL=group-modules-providers.js.map
