'use strict';

import run from './run';
import route from './route';
import config from './config';
import controllers from './controllers';
import directives from './directives';
import services from './services';
import filters from './filters';

if (!window.SEASUN) {
  window.SEASUN = {};
}

window.SEASUN.initFinance = function() {
  angular.module('SEASUN.finance', [

    'ui.router',

    'assets.template.finance',

    route.name,
    config.name,
    controllers.name,
    directives.name,
    services.name,
    filters.name
  ]).run(run);

  $(function() {
    angular.element(document).ready(function() {
      angular.bootstrap(document, ['SEASUN.finance']);
    });
  });

};
