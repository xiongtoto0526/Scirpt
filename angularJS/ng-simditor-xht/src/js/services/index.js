'use strict';

import FirstService from './first-service.js';

export default angular
  .module('app.services', [])
  .factory('FirstService', FirstService);
