'use strict';

import footerDirective from './footer-directive.js'
import xhtSimditor from './xht-simditor.js'

export default angular
  .module('app.directives', [
  	require('./simditorOptions').name // 将该模块导出，以便主app模块可以使用
  	])
  .directive('footerDirective', footerDirective)
  .directive('xhtSimditor', xhtSimditor);

// module.exports = angular
//   .module('ngSimditor', [
//     require('./simditor.directive').name,
//     require('./simditorOptions.service').name
//   ]);
