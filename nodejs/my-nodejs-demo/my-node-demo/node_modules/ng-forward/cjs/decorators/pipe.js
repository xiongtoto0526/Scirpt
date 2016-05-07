'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});
var _bind = Function.prototype.bind;

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

var _classesModule = require('../classes/module');

var _classesModule2 = _interopRequireDefault(_classesModule);

var _utilDecoratorFactory = require('../util/decorator-factory');

var _utilDecoratorFactory2 = _interopRequireDefault(_utilDecoratorFactory);

var TYPE = 'pipe';
var Pipe = (0, _utilDecoratorFactory2['default'])(TYPE);
exports.Pipe = Pipe;
_classesModule2['default'].addProvider(TYPE, function (provider, name, injects, ngModule) {
    ngModule.filter(name, [].concat(_toConsumableArray(injects), [function () {
        for (var _len = arguments.length, dependencies = Array(_len), _key = 0; _key < _len; _key++) {
            dependencies[_key] = arguments[_key];
        }

        var pipe = new (_bind.apply(provider, [null].concat(dependencies)))();
        if (!pipe.transform) {
            throw new Error('Filters must implement a transform method');
        }
        return function (input) {
            for (var _len2 = arguments.length, params = Array(_len2 > 1 ? _len2 - 1 : 0), _key2 = 1; _key2 < _len2; _key2++) {
                params[_key2 - 1] = arguments[_key2];
            }

            if (pipe.supports && !pipe.supports(input)) {
                throw new Error('Filter ' + name + ' does not support ' + input);
            }
            return pipe.transform.apply(pipe, [input].concat(params));
        };
    }]));
});
//# sourceMappingURL=pipe.js.map
