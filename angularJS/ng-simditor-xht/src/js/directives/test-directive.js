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
  function controller($location) {
    let vm = this;
  }

  function getTpl() {
    let tpl = `
      <footer class="main-footer">
        <div class="pull-right hidden-xs">
        </div>
        <strong>Copyright &copy; since 2016 <a href="http://baidu.com"> angular demo by xht</a>.</strong> All rights
        reserved.
      </footer>
    `;
    return tpl;
  }

};
