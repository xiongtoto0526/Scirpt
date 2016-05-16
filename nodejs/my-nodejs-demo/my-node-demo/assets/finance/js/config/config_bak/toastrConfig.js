'use strict';

// @ngInject
export default function(toastrConfig) {
  angular.extend(toastrConfig, {
    containerId: 'toast-container',
    iconClasses: {
      error: 'toast-error',
      info: 'toast-info',
      success: 'toast-success',
      warning: 'toast-warning'
    },
    maxOpened: 0,
    messageClass: 'toast-message',
    positionClass: 'toast-top-center',
    progress: true,
    timeOut: 500
  });
};
