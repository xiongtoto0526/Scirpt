'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});
var NativeCustomEvent = CustomEvent;
function useNative() {
    try {
        var p = new NativeCustomEvent('cat', { detail: { foo: 'bar' } });
        return 'cat' === p.type && 'bar' === p.detail.foo;
    } catch (e) {
        return false;
    }
}
function fromCreateEvent(type) {
    var params = arguments.length <= 1 || arguments[1] === undefined ? { bubbles: false, cancelable: false, detail: {} } : arguments[1];

    var e = document.createEvent('CustomEvent');
    e.initCustomEvent(type, params.bubbles, params.cancelable, params.detail);
    return e;
}
function fromCreateEventObject(type) {
    var params = arguments.length <= 1 || arguments[1] === undefined ? { bubbles: false, cancelable: false, detail: {} } : arguments[1];

    var e = document.createEventObject();
    e.type = type;
    e.bubbles = params.bubbles;
    e.cancelable = params.cancelable;
    e.detail = params.detail;
    return e;
}
var eventExport = undefined;
if (useNative()) {
    eventExport = NativeCustomEvent;
} else if (typeof document.createEvent === 'function') {
    eventExport = fromCreateEvent;
} else {
    eventExport = fromCreateEventObject;
}
exports['default'] = eventExport;
module.exports = exports['default'];
//# sourceMappingURL=custom-event.js.map
