'use strict';

import testDirective from './test-directive.js'
import xhtSimditor from './xht-simditor.js'

export default angular
  .module('app.directives', [])
  .directive('testDirective', testDirective)
  .directive('xhtSimditor', xhtSimditor);
