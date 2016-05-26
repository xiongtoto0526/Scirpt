'use strict';

import footerDirective from './footer-directive.js'
import xhtSimditor from './xht-simditor.js'

export default angular
  .module('app.directives', [])
  .directive('footerDirective', footerDirective)
  .directive('xhtSimditor', xhtSimditor);
