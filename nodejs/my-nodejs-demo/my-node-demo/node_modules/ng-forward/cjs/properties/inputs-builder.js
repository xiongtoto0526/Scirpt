'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});
exports.inputsMap = inputsMap;
exports['default'] = inputsBuilder;

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

var BIND_STRING = '_bind_string_';
var BIND_ONEWAY = '_bind_oneway_';
var BIND_TWOWAY = '_bind_twoway_';
function isDefined(value) {
    return typeof value !== 'undefined';
}

function inputsMap(inputs) {
    var definition = {};
    for (var key in inputs) {
        var lowercaseInput = inputs[key];
        definition['@' + key] = '@' + lowercaseInput;
        definition['[' + inputs[key] + ']'] = '=?';
        definition['[(' + inputs[key] + ')]'] = '=?';
    }
    return definition;
}

function inputsBuilder(controller, localKey, publicKey) {
    var _Object$defineProperties;

    // We are going to be installing a lot of properties on the controller to handle the magic
    // of our input bindings. Here we are marking them as hidden but writeable, that way
    // we don't leak our abstraction
    var stringKey = '@' + localKey;
    var oneWayKey = '[' + publicKey + ']';
    var twoWayKey = '[(' + publicKey + ')]';
    var __stringKey = Symbol();
    var __oneWayKey = Symbol();
    var __twoWayKey = Symbol();
    var __using_binding = Symbol();
    Object.defineProperties(controller, (_Object$defineProperties = {}, _defineProperty(_Object$defineProperties, stringKey, {
        enumerable: false, configurable: false,
        set: createHiddenPropSetter(BIND_STRING, __stringKey),
        get: function get() {
            return this[__stringKey];
        }
    }), _defineProperty(_Object$defineProperties, oneWayKey, {
        enumerable: false, configurable: false,
        set: createHiddenPropSetter(BIND_ONEWAY, __oneWayKey),
        get: function get() {
            return this[__oneWayKey];
        }
    }), _defineProperty(_Object$defineProperties, twoWayKey, {
        enumerable: false, configurable: false,
        set: createHiddenPropSetter(BIND_TWOWAY, __twoWayKey),
        get: function get() {
            return this[localKey];
        }
    }), _defineProperty(_Object$defineProperties, __using_binding, {
        enumerable: false, configurable: false, writable: true,
        value: controller.__using_binding || {}
    }), _Object$defineProperties));
    function createHiddenPropSetter(BIND_TYPE, __privateKey) {
        return function (val) {
            this[__privateKey] = val;
            if (isDefined(val)) {
                setBindingUsed(BIND_TYPE, localKey);
            }
            if (controller[__using_binding][localKey] === BIND_TYPE) {
                this[localKey] = val;
            }
        };
    }
    function setBindingUsed(using, key) {
        if (controller[__using_binding][key] && controller[__using_binding][key] !== using) {
            throw new Error('Can not use more than one type of attribute binding simultaneously: ' + key + ', [' + key + '], [(' + key + ')]. Choose one.');
        }
        controller[__using_binding][key] = using;
    }
}
//# sourceMappingURL=inputs-builder.js.map
