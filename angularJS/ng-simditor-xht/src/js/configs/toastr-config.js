
// @ngInject
export default ($provide, $httpProvider) => {

  $provide.factory('HttpInterceptor', $q => {

    return {
      request: req => {
        req.headers.Token = localStorage.token;
        return req;
      },
      responseError: rejection => {
        if(rejection.status == '401') {
          location = '/?add=NAR';
        }
      }
   };
  });

  $httpProvider.interceptors.push('HttpInterceptor');
};
