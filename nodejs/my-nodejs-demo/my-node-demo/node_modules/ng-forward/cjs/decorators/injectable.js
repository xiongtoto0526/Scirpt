'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) arr2[i] = arr[i]; return arr2; } else { return Array.from(arr); } }

var _classesModule = require('../classes/module');

var _classesModule2 = _interopRequireDefault(_classesModule);

var _utilDecoratorFactory = require('../util/decorator-factory');

var _utilDecoratorFactory2 = _interopRequireDefault(_utilDecoratorFactory);

var INJECTABLE = 'injectable';
exports.INJECTABLE = INJECTABLE;
var Injectable = (0, _utilDecoratorFactory2['default'])(INJECTABLE);
exports.Injectable = Injectable;
_classesModule2['default'].addProvider(INJECTABLE, function (provider, name, injects, ngModule) {
    ngModule.service(name, [].concat(_toConsumableArray(injects), [provider]));
});
//# sourceMappingURL=injectable.js.map
