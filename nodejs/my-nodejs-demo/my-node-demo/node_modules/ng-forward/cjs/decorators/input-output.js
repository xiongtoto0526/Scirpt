'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});
exports.Input = Input;
exports.Output = Output;

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _writers = require('../writers');

var _propertiesParsePropertyMap = require('../properties/parse-property-map');

var _propertiesParsePropertyMap2 = _interopRequireDefault(_propertiesParsePropertyMap);

var _eventsEvents = require('../events/events');

var _eventsEvents2 = _interopRequireDefault(_eventsEvents);

var writeMapSingle = function writeMapSingle(t, localName, publicName, storeKey) {
    var put = localName + (publicName ? ':' + publicName : '');
    var putMap = (0, _propertiesParsePropertyMap2['default'])([put]);
    var previousPutMap = _writers.componentStore.get(storeKey, t) || {};
    _writers.componentStore.set(storeKey, Object.assign({}, previousPutMap, putMap), t);
    return putMap;
};
exports.writeMapSingle = writeMapSingle;
var writeMapMulti = function writeMapMulti(t, names, storeKey) {
    var putMap = (0, _propertiesParsePropertyMap2['default'])(names);
    var previousPutMap = _writers.componentStore.get(storeKey, t) || {};
    _writers.componentStore.set(storeKey, Object.assign({}, previousPutMap, putMap), t);
    return putMap;
};
exports.writeMapMulti = writeMapMulti;

function Input(publicName) {
    return function (proto, localName) {
        writeMapSingle(proto.constructor, localName, publicName, 'inputMap');
    };
}

function Output(publicName) {
    return function (proto, localName) {
        var outputMap = writeMapSingle(proto.constructor, localName, publicName, 'outputMap');
        Object.keys(outputMap).forEach(function (key) {
            return _eventsEvents2['default'].add(key);
        });
    };
}
//# sourceMappingURL=input-output.js.map
