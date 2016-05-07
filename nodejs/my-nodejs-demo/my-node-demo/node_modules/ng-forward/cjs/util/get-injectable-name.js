'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});

var _writers = require('../writers');

var _decoratorsInjectable = require('../decorators/injectable');

var _classesOpaqueToken = require('../classes/opaque-token');

var getInjectableName = function getInjectableName(injectable) {
    if (typeof injectable === 'string' || injectable instanceof _classesOpaqueToken.OpaqueToken) {
        return injectable.toString();
    } else if (_writers.providerStore.has('type', injectable)) {
        return _writers.providerStore.get('name', injectable);
    }
};
exports.getInjectableName = getInjectableName;
var getInjectableNameWithJitCreation = function getInjectableNameWithJitCreation(injectable) {
    var name = getInjectableName(injectable);
    if (name) {
        return name;
    }
    if (typeof injectable === 'function') {
        (0, _decoratorsInjectable.Injectable)(injectable);
        return _writers.providerStore.get('name', injectable);
    }
};
exports.getInjectableNameWithJitCreation = getInjectableNameWithJitCreation;
//# sourceMappingURL=get-injectable-name.js.map
