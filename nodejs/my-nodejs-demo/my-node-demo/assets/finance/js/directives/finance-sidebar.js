'use strict';

// @ngInject
export default ($location) => {

  return {
    restrict: 'E',
    replace: true,
    template: getTpl(),
    scope: true,
    controller: controller,
    controllerAs: 'vm',
    bindToController: {}
  };

  // @ngInject
  function controller($state, $location) {
    let vm = this;
    let appId;
    let takoAppId;
    vm.hasAccessRight = true;

    vm.toDetails = function() {
      $state.go('details');
    };

    vm.toShare = function() {
      $state.go('share');
    };
  }

  function getTpl() {
    let tpl = `
      <aside class="main-sidebar">
        <section class="sidebar">
          <ul class="sidebar-menu">
            <li class="treeview">
              <a ng-click="vm.toDetails()">
                <i class="fa fa-rmb"></i> <span>财务明细查看</span>
              </a>
            </li>
            <li class="treeview active">
              <a  ng-click="vm.toShare()">
                <i class="fa fa-table"></i> <span>平台分摊人数比例</span>
              </a>
            </li>
          </ul>
        </section>
      </aside>
    `;
    return tpl;
  }

};
