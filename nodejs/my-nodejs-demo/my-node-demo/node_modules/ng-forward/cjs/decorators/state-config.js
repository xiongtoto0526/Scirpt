'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});
exports.StateConfig = StateConfig;
exports.Resolve = Resolve;

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

var _writers = require('../writers');

var _providers = require('./providers');

var _component = require("./component");

var _utilHelpers = require('../util/helpers');

var _utilGetInjectableName = require('../util/get-injectable-name');

var configsKey = 'ui-router.stateConfigs';
var childConfigsKey = 'ui-router.stateChildConfigs';
var annotatedResolvesKey = 'ui-router.annotatedResolves';
var resolvedMapKey = 'ui-router.resolvedMap';

function StateConfig(stateConfigs) {
    return function (t) {
        _providers.Providers.apply(undefined, _toConsumableArray(stateConfigs.map(function (sc) {
            return sc.component;
        })))(t, 'while analyzing StateConfig \'' + t.name + '\' state components');
        _writers.componentStore.set(childConfigsKey, stateConfigs, t);
        stateConfigs.forEach(function (config) {
            if (!config.component) return;
            var existingConfigs = _writers.componentStore.get(configsKey, config.component) || [];
            _writers.componentStore.set(configsKey, [].concat(_toConsumableArray(existingConfigs), [config]), config.component);
        });
    };
}

function targetIsStaticFn(t) {
    return t.name !== undefined && t.constructor.name === 'Function';
}

function Resolve() {
    var resolveName = arguments.length <= 0 || arguments[0] === undefined ? null : arguments[0];

    return function (target, resolveFnName, _ref) {
        var resolveFn = _ref.value;

        if (!targetIsStaticFn(target)) {
            throw new Error('@Resolve target must be a static method.');
        }
        _writers.componentStore.merge(annotatedResolvesKey, _defineProperty({}, resolveName || resolveFnName, resolveFn), target);
    };
}

_component.componentHooks.extendDDO(function (ddo) {
    if (ddo.template && ddo.template.replace) {
        ddo.template = ddo.template.replace(/ng-outlet/g, 'ui-view');
    }
});
_component.componentHooks.after(function (target, name, injects, ngModule) {
    var childStateConfigs = _writers.componentStore.get(childConfigsKey, target);
    if (childStateConfigs) {
        if (!Array.isArray(childStateConfigs)) {
            throw new TypeError((0, _utilHelpers.createConfigErrorMessage)(target, ngModule, '@StateConfig param must be an array of state objects.'));
        }
        ngModule.config(['$stateProvider', function ($stateProvider) {
            if (!$stateProvider) return;
            childStateConfigs.forEach(function (config) {
                var tagName = _writers.bundleStore.get('selector', config.component);
                config.template = config.template || '<' + tagName + '></' + tagName + '>';
                var annotatedResolves = _writers.componentStore.get(annotatedResolvesKey, config.component) || {};
                Object.keys(annotatedResolves).forEach(function (resolveName) {
                    var resolveFn = annotatedResolves[resolveName];
                    var fnInjects = _writers.bundleStore.get('$inject', resolveFn);
                    resolveFn.$inject = fnInjects;
                });
                config.resolve = Object.assign({}, config.resolve, annotatedResolves);
                var childInjects = _writers.bundleStore.get('$inject', config.component);
                var injects = childInjects ? childInjects.map(_utilGetInjectableName.getInjectableName) : [];
                function stateController() {
                    for (var _len = arguments.length, resolves = Array(_len), _key = 0; _key < _len; _key++) {
                        resolves[_key] = arguments[_key];
                    }

                    var resolvedMap = resolves.reduce(function (obj, val, i) {
                        obj[injects[i]] = val;
                        return obj;
                    }, {});
                    _writers.componentStore.set(resolvedMapKey, resolvedMap, config.component);
                }
                config.controller = config.controller || [].concat(_toConsumableArray(injects), [stateController]);
                $stateProvider.state(config.name, config);
            });
        }]);
    }
});
_component.componentHooks.beforeCtrlInvoke(function (caller, injects, controller, ddo, $injector, locals) {
    var resolvesMap = _writers.componentStore.get(resolvedMapKey, controller);
    Object.assign(locals, resolvesMap);
});
//# sourceMappingURL=state-config.js.map
