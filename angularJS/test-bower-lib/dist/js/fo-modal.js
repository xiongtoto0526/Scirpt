(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';

module.exports = angular.module('foModalClose.directive', []).directive('foModalClose', foModalClose);

foModalClose.$inject = ['$document'];

function foModalClose($document) {
  return {
    restrict: 'A',
    scope: true,
    link: function link(scope, element, attr) {
      element.bind('click', function () {
        angular.element(document.querySelector('.fo-modal')).remove();
        angular.element(document.querySelector('.fo-layer')).remove();
        angular.element($document).find('body').removeClass('fo-fixed');
      });
    }
  };
}

},{}],2:[function(require,module,exports){
'use strict';

module.exports = angular.module('foModal.services', []).factory('foModal', foModal);

foModal.$inject = ['$rootScope', '$http', '$templateCache', '$document', '$compile', '$controller', '$q', '$injector', '$timeout'];

function foModal($rootScope, $http, $templateCache, $document, $compile, $controller, $q, $injector, $timeout) {

  var $modal;
  var $layer = createLayerElement();
  var $body = angular.element($document).find('body');

  var modal = {

    defaultConfig: {
      showClose: true,
      fixBody: true
    },

    open: function open(options) {
      options = angular.extend(modal.defaultConfig, options);

      // if (options.controller && (angular.isString(options.controller) || angular.isArray(options.controller) || angular.isFunction(options.controller))) {}

      createModalElement(options.templateUrl, options.showClose).then(function (data) {
        $modal = data;

        appendToBody($modal, $layer);

        $compile($modal)($rootScope);

        var promises = handleResolve(options.resolve);

        $q.all(promises).then(function (value) {
          showModal($modal, $layer, options);
          $timeout(function () {
            instantiateController(options.controller, $modal, value);
            return this;
          }, 500);
        });
      }, function (err) {
        // todo
        console.log(err);
      });
    },

    close: function close() {
      angular.element(document.querySelector('.fo-modal')).remove();
      angular.element(document.querySelector('.fo-layer')).remove();
      angular.element($document).find('body').removeClass('fo-fixed');
    }

  };

  return {
    open: modal.open,
    close: modal.close
  };

  /////////////////////////////////////////

  function getTemplateString(templateUrl) {
    var deferred = $q.defer();
    if ($templateCache.get(templateUrl)) {
      deferred.resolve($templateCache.get(templateUrl));
    } else {
      $http.get(templateUrl).then(function (res) {
        deferred.resolve(res.data);
      }, function () {
        deferred.reject('empty template');
      });
    }
    return deferred.promise;
  }

  function createModalElement(templateUrl, showClose) {
    var deferred = $q.defer();
    getTemplateString(templateUrl).then(function (templateString) {
      templateString = showClose ? templateString + '<div fo-modal-close class="modal-close"></div>' : templateString;
      var $wrapper = angular.element('<div class="fo-modal fo-animated"></div>');

      deferred.resolve(angular.element($wrapper).append(templateString));
    }, function (err) {
      deferred.reject(err);
    });
    return deferred.promise;
  }

  function createLayerElement() {
    return angular.element('<div class="fo-layer"></div>');
  }

  function appendToBody($modal, $layer) {
    $body.append($layer);
    $body.append($modal);
  }

  function handleResolve(resolve) {
    var promises = {};

    angular.forEach(resolve, function (value, key) {
      promises[key] = angular.isString(value) ? value : $injector.invoke(value);
    });

    return promises;
  }

  function showModal($modal, $layer, options) {
    var tetherOption = {
      element: $modal[0],
      target: $layer[0],
      attachment: 'middle middle',
      targetAttachment: 'middle middle'
    };

    $layer.addClass('fo-open');
    $modal.addClass('fo-open').addClass('fo-fade-in');
    if (options.fixBody) $body.addClass('fo-fixed');
    if (options.bodyClass) $modal.addClass(options.bodyClass);
    if (options.overlayClass) $layer.addClass(options.overlayClass);
    if (options.bodyId) $modal.addClass(options.bodyId);
    if (options.overlayId) $layer.addClass(options.overlayId);

    $timeout(function () {
      new Tether(tetherOption);
    }, 1);
  }

  function instantiateController(constructor, element, resolveData) {
    var locals = angular.extend({
      $scope: $rootScope,
      $element: $modal
    }, resolveData);

    $controller(constructor, locals);
  }
}

},{}],3:[function(require,module,exports){
'use strict';

var foModalCloseDirective = require('./fo-modal-close.directive');
var foModalService = require('./fo-modal.service');

module.exports = angular.module('foModal', [foModalCloseDirective.name, foModalService.name]);

},{"./fo-modal-close.directive":1,"./fo-modal.service":2}]},{},[3]);
