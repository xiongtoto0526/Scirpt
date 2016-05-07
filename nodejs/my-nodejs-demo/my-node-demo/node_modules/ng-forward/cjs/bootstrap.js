'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});
exports['default'] = bootstrap;

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _bundle = require('./bundle');

var _bundle2 = _interopRequireDefault(_bundle);

var _writers = require('./writers');

function bootstrap(component) {
    var otherProviders = arguments.length <= 1 || arguments[1] === undefined ? [] : arguments[1];

    var selector = _writers.bundleStore.get('selector', component);
    var rootElement = document.querySelector(selector);
    (0, _bundle2['default'])(selector, component, otherProviders);
    return angular.bootstrap(rootElement, [selector]);
}

module.exports = exports['default'];
//# sourceMappingURL=bootstrap.js.map
