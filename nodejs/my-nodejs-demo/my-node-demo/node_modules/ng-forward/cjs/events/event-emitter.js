'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x2, _x3, _x4) { var _again = true; _function: while (_again) { var object = _x2, property = _x3, receiver = _x4; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x2 = parent; _x3 = property; _x4 = receiver; _again = true; desc = parent = undefined; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var _reactivexRxjsDistCjsSubject = require('@reactivex/rxjs/dist/cjs/Subject');

var _reactivexRxjsDistCjsSubject2 = _interopRequireDefault(_reactivexRxjsDistCjsSubject);

var EventEmitter = (function (_Subject) {
    _inherits(EventEmitter, _Subject);

    function EventEmitter() {
        var isAsync = arguments.length <= 0 || arguments[0] === undefined ? true : arguments[0];

        _classCallCheck(this, EventEmitter);

        _get(Object.getPrototypeOf(EventEmitter.prototype), 'constructor', this).call(this);
        this._isAsync = isAsync;
    }

    _createClass(EventEmitter, [{
        key: 'subscribe',
        value: function subscribe(generatorOrNext, error, complete) {
            if (generatorOrNext && typeof generatorOrNext === 'object') {
                var schedulerFn = this._isAsync ? function (value) {
                    setTimeout(function () {
                        return generatorOrNext.next(value);
                    });
                } : function (value) {
                    generatorOrNext.next(value);
                };
                return _get(Object.getPrototypeOf(EventEmitter.prototype), 'subscribe', this).call(this, schedulerFn, function (err) {
                    return generatorOrNext.error ? generatorOrNext.error(err) : null;
                }, function () {
                    return generatorOrNext.complete ? generatorOrNext.complete() : null;
                });
            } else {
                var schedulerFn = this._isAsync ? function (value) {
                    setTimeout(function () {
                        return generatorOrNext(value);
                    });
                } : function (value) {
                    generatorOrNext(value);
                };
                return _get(Object.getPrototypeOf(EventEmitter.prototype), 'subscribe', this).call(this, schedulerFn, function (err) {
                    return error ? error(err) : null;
                }, function () {
                    return complete ? complete() : null;
                });
            }
        }
    }]);

    return EventEmitter;
})(_reactivexRxjsDistCjsSubject2['default']);

exports['default'] = EventEmitter;
module.exports = exports['default'];
//# sourceMappingURL=event-emitter.js.map
