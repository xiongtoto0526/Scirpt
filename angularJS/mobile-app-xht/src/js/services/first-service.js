'use strict';

angular.module('MobileAngularUiExamples')
.factory('log', function($http, api) {
  return {
    download: function(versionid) {
      return $http.post(api.createdownloadlog, { appversionid: versionid });
    }
  }
});
