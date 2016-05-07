'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

exports.compileComponent = compileComponent;
exports.compileHtmlAndScope = compileHtmlAndScope;

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

var _bundle = require('../bundle');

var _bundle2 = _interopRequireDefault(_bundle);

var _providers = require('./providers');

var _writers = require('../writers');

var _decoratorsComponent = require('../decorators/component');

var TestComponentBuilder = (function () {
    function TestComponentBuilder() {
        _classCallCheck(this, TestComponentBuilder);
    }

    _createClass(TestComponentBuilder, [{
        key: 'create',
        value: function create(rootComponent) {
            var decoratedModule = (0, _bundle2['default'])('test.module', rootComponent);
            angular.mock.module(decoratedModule.name);
            angular.mock.module(function ($provide) {
                return (0, _providers.allProviders)().forEach(function (_ref) {
                    var token = _ref.token;
                    var useValue = _ref.useValue;
                    return $provide.value(token, useValue);
                });
            });
            var fixture = compileComponent(rootComponent);
            (0, _providers.clearProviders)();
            return fixture;
        }
    }, {
        key: 'createAsync',
        value: function createAsync(rootComponent) {
            var fixture = this.create(rootComponent);
            return Promise.resolve(fixture);
        }
    }, {
        key: 'overrideTemplate',
        value: function overrideTemplate(component, template) {
            _writers.componentStore.set('template', template, component);
            return this;
        }
    }, {
        key: 'overrideProviders',
        value: function overrideProviders(component, providers) {
            _writers.bundleStore.set('providers', providers, component);
            return this;
        }
    }, {
        key: 'overrideView',
        value: function overrideView(component, config) {
            (0, _decoratorsComponent.View)(config)(component);
            return this;
        }
    }, {
        key: 'overrideDirective',
        value: function overrideDirective() {
            throw new Error('Method not supported in ng-forward.');
        }
    }, {
        key: 'overrideViewBindings',
        value: function overrideViewBindings() {
            throw new Error('Method not supported in ng-forward.');
        }
    }]);

    return TestComponentBuilder;
})();

exports.TestComponentBuilder = TestComponentBuilder;

var ComponentFixture = (function () {
    function ComponentFixture(_ref2) {
        var debugElement = _ref2.debugElement;
        var rootTestScope = _ref2.rootTestScope;
        var $injector = _ref2.$injector;

        _classCallCheck(this, ComponentFixture);

        this.debugElement = debugElement;
        this.debugElement.data('$injector', $injector);
        this.componentInstance = debugElement.componentInstance;
        this.nativeElement = debugElement.nativeElement;
        this.rootTestScope = rootTestScope;
    }

    _createClass(ComponentFixture, [{
        key: 'detectChanges',
        value: function detectChanges() {
            this.rootTestScope.$digest();
        }
    }]);

    return ComponentFixture;
})();

exports.ComponentFixture = ComponentFixture;

function compileComponent(ComponentClass) {
    var selector = _writers.bundleStore.get('selector', ComponentClass),
        rootTestScope = undefined,
        debugElement = undefined,
        componentInstance = undefined,
        $injector = undefined;
    inject(function ($compile, $rootScope, _$injector_) {
        var controllerAs = _writers.componentStore.get('controllerAs', ComponentClass);
        componentInstance = new ComponentClass();
        rootTestScope = $rootScope.$new();
        debugElement = angular.element('<' + selector + '></' + selector + '>');
        debugElement = $compile(debugElement)(rootTestScope);
        rootTestScope.$digest();
        $injector = _$injector_;
    });
    return new ComponentFixture({ debugElement: debugElement, rootTestScope: rootTestScope, $injector: $injector });
}

function compileHtmlAndScope(_ref3) {
    var html = _ref3.html;
    var initialScope = _ref3.initialScope;
    var selector = _ref3.selector;

    var parentScope = undefined,
        element = undefined,
        controller = undefined,
        isolateScope = undefined;
    inject(function ($compile, $rootScope) {
        parentScope = $rootScope.$new();
        Object.assign(parentScope, initialScope);
        element = angular.element(html);
        element = $compile(element)(parentScope);
        parentScope.$digest();
        isolateScope = element.isolateScope();
        controller = element.controller('' + selector);
    });
    return { parentScope: parentScope, element: element, controller: controller, isolateScope: isolateScope };
}
//# sourceMappingURL=test-component-builder.js.map
