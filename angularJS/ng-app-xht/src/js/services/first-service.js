'use strict';

// @ngInject
export default function($resource) {
  return {
    querySharedDefine: data => {
      debugger;
      return $resource('/apis/auth/share/shared-define').query().$promise;
    },

    queryPlatformPrivilege: data => {
      return $resource('/apis/auth/share/plat-perm').query().$promise;
    },

    querySharedData: (platformId, cityId, month) => {
      return $resource('/apis/auth/share/shared-data').query({
        shareItemId: platformId,
        cityId: cityId,
        month: month
      }).$promise;
    },

    saveSharedData: (data) => {
      return $resource('/apis/auth/share/shared-data').save(data).$promise;
    },

    getExcelPath: (month) => {
      return $resource('/apis/auth/share/excel').get({
        month: month
      }).$promise;
    }
  };
}
