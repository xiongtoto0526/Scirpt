'use strict';

export default angular.module('app.route', [])

  .config(function($stateProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/');

    $stateProvider
      .state('home', { url: '/', template: '' })

      .state('details', {
        url: '/details',
        templateUrl: 'views/details.tpl.html'
      })

      .state('share', {
        url: '/share',
        templateUrl: 'views/share.tpl.html'
      });

  });
