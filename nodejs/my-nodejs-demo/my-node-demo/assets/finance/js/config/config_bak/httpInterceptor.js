'use strict';

// @ngInject
export default function($provide, $httpProvider) {

  $provide.factory('HttpInterceptor', function($q) {
    return {
      request: function(config) {
        return config || $q.when(config);
      },

      requestError: function(rejection) {
        return $q.reject(rejection);
      },

      response: function(res) {
        var statusCodeString = res.status.toString();
        var fistCode = statusCodeString.charAt(0);

        // TODO
        switch (fistCode) {
          case '2':
            break;
          case '3':
            break;
          default:
            break;
        }
        return res;
      },

      responseError: function(rejection) {
        var statusCodeString = rejection.status.toString();
        console.log(statusCodeString);
        var fistCode = statusCodeString.charAt(0);

        // TODO
        switch (fistCode) {
          case '4':
            break;
          case '5':
            $('#error-info').text('Oh~ 服务器君你又调皮了');
            $('#error-info').fadeIn();
            setTimeout(function() {
              $('#error-info').fadeOut();
            }, 2000);
            break;
          default:
            break;
        }

        // if (statusCodeString === '401') {
        //   if (location.hash.length > 5) {
        //     location.href = '/';
        //   }
        // }

        return $q.reject(rejection.data);
      }


    };
  });

  $httpProvider.interceptors.push('HttpInterceptor');
};
