(function () {
  var app = angular.module('plunker', []);
  
  function TooltipModel (config) {
    // Boolean - if the tooltip should be shown - component decorators can modify this property.
    this.shouldShow = config.shouldShow || true;
    
    // Boolean - if the tooltip is currently being shown. Component decorators can use this property to test if the tooltip is being shown
    this.isShowing = config.isShowing || false;
    
    // String - the message the tooltip contains. It is an angular expression
    this.message = config.message || '';
    
    // Number - the x coordinate of the tooltip
    this.x = config.x || 0;
    
    // Number - the y coordinate of the tooltip
    this.y = config.y || 0;
  }
  
  function TooltipController () {
  
    // API for state
    this.model = new TooltipModel({});
  }
  
  TooltipController.prototype.show = function showTooltip () {
    if (this.model.shouldShow) {
      this.model.isShowing = true;
    }
  };
  
  TooltipController.prototype.hide = function hideTooltip () {
    this.model.isShowing = false;
  }
  
  TooltipController.prototype.setPosition = function setPosition (x, y) {
    this.model.x = x;
    this.model.y = y;
  }
  app.controller('TooltipController', TooltipController);

  // Tooltip directive
  app.directive('tooltip', function($compile) {
    return {
      restrict: 'A',
      controller: 'TooltipController',
      // controllerAs: 'tooltip', // we won't use this since we are kind of stepping outside normal angular stuff
  
      link: function tooltipLink ($scope, $element, $attrs, TooltipController) {
        var $body = angular.element(document.body);
        var $tooltipElement;
        var tooltipScope = $scope.$new(true); // new isolate scope
        tooltipScope.tooltip = TooltipController; // controllerAs in the isolate scope
  
        // events
        $element.on('mouseover', function onMouseover (event) {
          TooltipController.setPosition(event.clientX + 10, event.clientY + 10);
          TooltipController.show();
          tooltipScope.$digest(); // let Angular know something interesting happened - local digest for performance
        });
  
        $element.on('mouseout', function onMouseout (event) {
          TooltipController.hide();
          tooltipScope.$digest(); // let Angular know something interesting happened - local digest for performance
        });
  
        // react to state changes
        tooltipScope.$watch('tooltip.model.isShowing', function (isShowing) {
          if (isShowing) {
            // lazy initialization of tooltip contents
            if (!$tooltipElement) {
              $tooltipElement = $compile('<div class="tooltip">{{tooltip.model.message}}</div>')(tooltipScope);
            }
            $tooltipElement.css({
              top: TooltipController.model.y + 'px',
              left: TooltipController.model.x + 'px'
            });
            $body.append($tooltipElement);
          } else {
            $tooltipElement && $tooltipElement.remove();
          }
        });
      }
    };
  });
  
  app.directive('tooltipMessage', function () {
    return {
      restrict: 'A',
      require: 'tooltip',
      
      link: function tooltipMessageLink ($scope, $element, $attrs, TooltipController) {
        $scope.$watch($attrs.tooltipMessage, function (message) {
          TooltipController.model.message = message;
        });
      }
    }
  });
  
  app.directive('tooltipOverflow', function () {
    return {
      restrict: 'A',
      require: 'tooltip',
      
      link: function tooltipOverflowLink ($scope, $element, $attrs, TooltipController) {
        $element.on('mouseover', function (event) {
          if ($element[0].scrollWidth > $element[0].clientWidth) {
            TooltipController.model.shouldShow = true;
          } else {
            TooltipController.model.shouldShow = false;
          }
        });
      }
    }
  });

})();

                