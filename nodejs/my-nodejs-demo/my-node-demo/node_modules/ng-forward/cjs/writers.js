'use strict';

Object.defineProperty(exports, '__esModule', {
  value: true
});

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _classesMetastore = require('./classes/metastore');

var _classesMetastore2 = _interopRequireDefault(_classesMetastore);

var componentStore = new _classesMetastore2['default']('$component');
exports.componentStore = componentStore;
var providerStore = new _classesMetastore2['default']('$provider');
exports.providerStore = providerStore;
var bundleStore = new _classesMetastore2['default']('$bundle');
exports.bundleStore = bundleStore;
//# sourceMappingURL=writers.js.map
