module.exports = angular
  .module('foModalClose.directive', [])
  .directive('foModalClose', foModalClose);

foModalClose.$inject = ['$document'];

function foModalClose($document) {
  return {
    restrict: 'A',
    scope: true,
    link: function(scope, element, attr) {
      element.bind('click', function() {
        angular.element(document.querySelector('.fo-modal')).remove();
        angular.element(document.querySelector('.fo-layer')).remove();
        angular.element($document).find('body').removeClass('fo-fixed');
      });
    }
  };
}
