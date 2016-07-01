'use strict';

angular.module('MobileAngularUiExamples')
.filter('filesize', function() {
  return function(size) {
    return typeof size === 'number' ? (size / 1024 / 1024).toFixed(1) + ' M' : '未知大小';
  };
});
