let foModalCloseDirective = require('./fo-modal-close.directive');
let foModalService = require('./fo-modal.service');

module.exports = angular
  .module('foModal', [
    foModalCloseDirective.name,
    foModalService.name
  ]);
