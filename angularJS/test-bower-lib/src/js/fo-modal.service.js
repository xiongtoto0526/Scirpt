module.exports = angular
  .module('foModal.services', [])
  .factory('foModal', foModal);

foModal.$inject = ['$rootScope', '$http', '$templateCache', '$document', '$compile', '$controller', '$q', '$injector', '$timeout'];

function foModal($rootScope, $http, $templateCache, $document, $compile, $controller, $q, $injector, $timeout) {

  var $modal;
  var $layer = createLayerElement(); // 创建遮罩层
  var $body = angular.element($document).find('body');

  var modal = {

    defaultConfig: {
      showClose: true,
      fixBody: true
    },

    open: function(options) {
      options = angular.extend(modal.defaultConfig, options);

      // if (options.controller && (angular.isString(options.controller) || angular.isArray(options.controller) || angular.isFunction(options.controller))) {}

      createModalElement(options.templateUrl, options.showClose).then(function(data) {
        $modal = data;

        appendToBody($modal, $layer);

        $compile($modal)($rootScope);//modal中存在需要转换的变量，需compile

        var promises = handleResolve(options.resolve);

        $q.all(promises).then(function(value) {
          showModal($modal, $layer, options);
          $timeout(function() {
            instantiateController(options.controller, $modal, value);
            return this;
          }, 500);
        });
      }, function(err) {
        // todo
        console.log(err);
      });

    },

    close: function() {
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

// 异步读取模板：若为url，则先获取url模板，再返回。
  function getTemplateString(templateUrl) {
    var deferred = $q.defer();
    if ($templateCache.get(templateUrl)) {
      deferred.resolve($templateCache.get(templateUrl));
    } else {
      $http.get(templateUrl).then(function(res) {
        deferred.resolve(res.data);
      }, function() {
        deferred.reject('empty template');
      });
    }
    return deferred.promise;
  }

// showClose，是否允许展示‘关闭’按钮。 $wrapper 为整个div的包裹方式
  function createModalElement(templateUrl, showClose) {
    var deferred = $q.defer();
    getTemplateString(templateUrl).then(function(templateString) {
      templateString = showClose ? templateString + '<div fo-modal-close class="modal-close"></div>' : templateString;
      var $wrapper = angular.element('<div class="fo-modal fo-animated"></div>');

      deferred.resolve(angular.element($wrapper).append(templateString));
    }, function(err) {
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

    angular.forEach(resolve, function(value, key) {
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

    // 根据配置信息，添加样式
    if (options.fixBody) $body.addClass('fo-fixed');
    if (options.bodyClass) $modal.addClass(options.bodyClass);
    if (options.overlayClass) $layer.addClass(options.overlayClass);
    if (options.bodyId) $modal.addClass(options.bodyId);
    if (options.overlayId) $layer.addClass(options.overlayId);

    $timeout(function() {
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
