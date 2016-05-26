'use strict';

import directives from './directives';

angular.module('xhtApp', [
	'ngSimditor',
      directives.name
])
.config(['simditorConfig',function(simditorConfig) {
	simditorConfig.placeholder = '这里输入文字...';
	simditorConfig.toolbar = [
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
}])
.controller('XhtCtrl', ['$scope', function($scope){
	$scope.test = 'test  content 12';
}]);