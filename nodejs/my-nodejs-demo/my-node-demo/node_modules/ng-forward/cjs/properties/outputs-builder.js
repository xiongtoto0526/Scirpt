'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

var _eventsEventEmitter = require('../events/event-emitter');

var _eventsEventEmitter2 = _interopRequireDefault(_eventsEventEmitter);

var _utilCustomEvent = require('../util/custom-event');

var _utilCustomEvent2 = _interopRequireDefault(_utilCustomEvent);

exports['default'] = function (instance, element, $scope, outputs) {
    var subscriptions = [];
    var create = function create(eventKey, emitter) {
        return emitter.subscribe(function (data) {
            var event = new _utilCustomEvent2['default'](eventKey, { detail: data, bubbles: false });
            element[0].dispatchEvent(event);
        });
    };
    for (var key in outputs) {
        if (instance[key] && instance[key] instanceof _eventsEventEmitter2['default']) {
            subscriptions.push(create(outputs[key], instance[key]));
        }
    }
    $scope.$on('$destroy', function (event) {
        subscriptions.forEach(function (subscription) {
            return subscription.unsubscribe();
        });
    });
};

module.exports = exports['default'];
//# sourceMappingURL=outputs-builder.js.map
