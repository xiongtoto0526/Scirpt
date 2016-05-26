'use strict';

// @ngInject
export default ($location, $timeout) => {

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
  }

  function getTpl() {
    let tpl = `
      <footer class="main-footer">
        <div class="pull-right hidden-xs">
          <!-- <b>Version</b> 2.3.3 -->
        </div>
        <strong>Copyright &copy; 2016-2016 <a href="http://project.seasungame.com">西山居平台</a>.</strong> All rights
        reserved.
      </footer>
    `;
    return tpl;
  }

};
