'use strict';

import directives from './directives';
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
        directives.name,
        controllers.name
    ])
    .controller('estDrCtrl', ['$scope', function($scope) {
        $scope.test = 'test  dr 12';
    }]);