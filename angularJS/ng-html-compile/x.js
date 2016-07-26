
var app = angular.module('xApp', []);

app.controller('xCtrl', ['$scope', function ($scope) {
   $scope.text = 'x';
   // $scope.xhtHtml = 'htllo';
}])


app.directive('ngHtmlCompile',function ($compile) {
      return {
        restrict: 'A',
        scope: {
         myAttr: '@'
        },
        link: function(scope, element, attrs) {
          debugger;
          scope.$watch(
            function(scope) {
               // watch the 'compile' expression for changes
              return scope.$eval(attrs.ngHtmlCompile);
            },
            function(value) {
              // when the 'compile' expression changes
              // assign it into the current DOM
              element.html(value);

              // compile the new DOM and link it to the current
              // scope.
              // NOTE: we only compile .childNodes so that
              // we don't get into infinite loop compiling ourselves
              $compile(element.contents())(scope);
            }
        );
    }
      };
});
