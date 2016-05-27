'use strict';

import directives from './directives';
import configs from './configs';
// import simditorOptions from './directives/simditorOptions';
import controllers from './controllers';


angular.module('xhtApp', [
        'toastr',
        // 'ngResource',
        // 'ngWebSocket',
        // 'ngStorage',
        // 'ngFileUpload',
        // 'ui.router',
        // 'ui.select',
        // 'ui.bootstrap',
        configs.name,
        directives.name,
        controllers.name
    ])
   // .value('simditorOptions', {})// 直接为该模块引入value
   .config(function($provide) {

  // 重新设置 simditorOptions 
  $provide.decorator('simditorOptions', ['$delegate', function(simditorOptions) {
    simditorOptions.toolbar = [
      'title',
      'bold',
      'italic',
      'underline',
      'strikethrough',
      'color',
      'ol',
      'ul',
      'blockquote',
      'code',
      'table',
      'link',
      'image',
      'hr',
      'indent',
      'outdent',
      'alignment',
    ];

    simditorOptions.toolbarFloat = false;
    return simditorOptions;
  }]);

})
    .controller('TestDrCtrl', ['$scope', function($scope) {
        $scope.test = 'This Ctrl do not use ~';
    }]);