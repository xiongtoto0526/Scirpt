'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});
exports.Inject = Inject;

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

var _writers = require('../writers');

var _utilGetInjectableName = require('../util/get-injectable-name');

var _decoratorsProviders = require('../decorators/providers');

var _classesOpaqueToken = require('../classes/opaque-token');

var _component = require('./component');

function Inject() {
    for (var _len = arguments.length, injects = Array(_len), _key = 0; _key < _len; _key++) {
        injects[_key] = arguments[_key];
    }

    return function (t1, name) {
        var _ref = arguments.length <= 2 || arguments[2] === undefined ? { value: undefined } : arguments[2];

        var t2 = _ref.value;

        var targetIsClass = arguments.length === 1;
        var t = targetIsClass ? t1 : t2;
        var notStringBased = function notStringBased(inj) {
            return typeof inj !== 'string' && !(inj instanceof _classesOpaqueToken.OpaqueToken);
        };
        var ensureInjectable = function ensureInjectable(inj) {
            if (!_writers.providerStore.get('name', inj) || !_writers.providerStore.get('type', inj)) {
                throw new Error('Processing "' + t.name + '" @Inject parameter: "' + (inj.name || inj.toString()) + '" is not a valid injectable.\n\t\t\t\tPlease ensure ' + (inj.name || inj.toString()) + ' is injectable. Valid examples can be:\n\t\t\t\t- a string representing an ng1 provider, e.g. \'$q\'\n\t\t\t\t- an @Injectable ng-forward class\n\t\t\t\t- a Provider, e.g. provide(SOME_CONFIG, {asValue: 100})');
            }
            return inj;
        };
        var providers = injects.filter(notStringBased).map(ensureInjectable);
        _decoratorsProviders.Providers.apply(undefined, _toConsumableArray(providers))(t, 'while analyzing \'' + t.name + '\' injected providers');
        var dependencies = injects.map(_utilGetInjectableName.getInjectableName).filter(function (n) {
            return n !== undefined;
        });
        if (_writers.bundleStore.has('$inject', t)) {
            var parentInjects = _writers.bundleStore.get('$inject', t);
            _writers.bundleStore.set('$inject', [].concat(_toConsumableArray(dependencies), _toConsumableArray(parentInjects)), t);
        } else {
            _writers.bundleStore.set('$inject', dependencies, t);
        }
    };
}

_component.componentHooks.beforeCtrlInvoke(injectParentComponents);
function injectParentComponents(caller, injects, controller, ddo, $injector, locals) {
    injects.forEach(function (inject) {
        if (!$injector.has(inject)) {
            var _parent = locals.$element;
            do {
                if (!_parent.controller) continue;
                var parentCtrl = _parent.controller(inject);
                if (parentCtrl) {
                    locals[inject] = parentCtrl;
                    return;
                }
            } while ((_parent = _parent.parent()) && _parent.length > 0);
        }
    });
}
//# sourceMappingURL=inject.js.map
