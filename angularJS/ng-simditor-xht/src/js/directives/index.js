'use strict';

import testDirective from './test-directive.js'

export default angular
  .module('app.directives', [])
  .directive('testDirective', testDirective);
