'use strict';

import firstFilter from './first-filter.js';

export default angular
  .module('app.filters', [])
  .filter('firstFilter', firstFilter)
