"use strict";

Object.defineProperty(exports, "__esModule", {
    value: true
});
exports.quickFixture = quickFixture;

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj["default"] = obj; return newObj; } }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var _angular = require('./angular');

require('../util/jqlite-extensions');

var _testingTestComponentBuilder = require('../testing/test-component-builder');

var tcb = _interopRequireWildcard(_testingTestComponentBuilder);

var _decoratorsComponent = require('../decorators/component');

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

function quickFixture(_ref) {
    var _ref$providers = _ref.providers;
    var providers = _ref$providers === undefined ? [] : _ref$providers;
    var _ref$directives = _ref.directives;
    var directives = _ref$directives === undefined ? [] : _ref$directives;
    var _ref$template = _ref.template;
    var template = _ref$template === undefined ? '<div></div>' : _ref$template;

    _angular.ng.useReal();
    var Test = function Test() {
        _classCallCheck(this, Test);
    };
    Test = __decorate([(0, _decoratorsComponent.Component)({ selector: 'test', template: template, directives: directives, providers: providers }), __metadata('design:paramtypes', [])], Test);
    var builder = new tcb.TestComponentBuilder();
    return builder.create(Test);
}

;
//# sourceMappingURL=utils.js.map
