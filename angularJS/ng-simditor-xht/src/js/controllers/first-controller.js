'use strict';


// @ngInject
export default function($scope,toastr) {
  var vm = this;
  $scope.test = 'test first controller content 12';
  // var promise = firstService.querySharedDefine();
  
  $scope.a=function(){
    toastr.warning('请选择正确的文件上传!', '提示');
  }
}
