"use strict";

Object.defineProperty(exports, "__esModule", {
    value: true
});

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var _decoratorsDirective = require('../decorators/directive');

var _decoratorsInject = require('../decorators/inject');

var _utilParseSelector = require('../util/parse-selector');

var _utilParseSelector2 = _interopRequireDefault(_utilParseSelector);

var _utilHelpers = require('../util/helpers');

var __decorate = undefined && undefined.__decorate || function (decorators, target, key, desc) {
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") return Reflect.decorate(decorators, target, key, desc);
    switch (arguments.length) {
        case 2:
            return decorators.reduceRight(function (o, d) {
                return d && d(o) || o;
            }, target);
        case 3:
            return decorators.reduceRight(function (o, d) {
                return d && d(target, key), void 0;
            }, void 0);
        case 4:
            return decorators.reduceRight(function (o, d) {
                return d && d(target, key, o) || o;
            }, desc);
    }
};
var __metadata = undefined && undefined.__metadata || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var events = new Set(['click', 'dblclick', 'mousedown', 'mouseup', 'mouseover', 'mouseout', 'mousemove', 'mouseenter', 'mouseleave', 'keydown', 'keyup', 'keypress', 'submit', 'focus', 'blur', 'copy', 'cut', 'paste', 'change', 'dragstart', 'drag', 'dragenter', 'dragleave', 'dragover', 'drop', 'dragend', 'error', 'input', 'load', 'wheel', 'scroll']);
function resolve() {
    var directives = [];
    events.forEach(function (event) {
        var selector = "[(" + (0, _utilHelpers.dasherize)(event) + ")]";
        var EventHandler = (function () {
            function EventHandler($parse, $element, $attrs, $scope) {
                var _this = this;

                _classCallCheck(this, EventHandler);

                this.$element = $element;
                this.$scope = $scope;

                var _parseSelector = (0, _utilParseSelector2["default"])(selector);

                var attrName = _parseSelector.name;

                this.expression = $parse($attrs[attrName]);
                $element.on(event, function (e) {
                    return _this.eventHandler(e);
                });
                $scope.$on('$destroy', function () {
                    return _this.onDestroy();
                });
            }

            _createClass(EventHandler, [{
                key: "eventHandler",
                value: function eventHandler() {
                    var $event = arguments.length <= 0 || arguments[0] === undefined ? {} : arguments[0];

                    var detail = $event.detail;
                    if (!detail && $event.originalEvent && $event.originalEvent.detail) {
                        detail = $event.originalEvent.detail;
                    } else if (!detail) {
                        detail = {};
                    }
                    this.expression(this.$scope, Object.assign(detail, { $event: $event }));
                    this.$scope.$applyAsync();
                }
            }, {
                key: "onDestroy",
                value: function onDestroy() {
                    this.$element.off(event);
                }
            }]);

            return EventHandler;
        })();
        EventHandler = __decorate([(0, _decoratorsDirective.Directive)({ selector: selector }), (0, _decoratorsInject.Inject)('$parse', '$element', '$attrs', '$scope'), __metadata('design:paramtypes', [Function, Object, Object, Object])], EventHandler);
        directives.push(EventHandler);
    });
    return directives;
}
function add() {
    for (var _len = arguments.length, customEvents = Array(_len), _key = 0; _key < _len; _key++) {
        customEvents[_key] = arguments[_key];
    }

    customEvents.forEach(function (event) {
        return events.add(event);
    });
}
exports["default"] = { resolve: resolve, add: add };
module.exports = exports["default"];
//# sourceMappingURL=events.js.map
