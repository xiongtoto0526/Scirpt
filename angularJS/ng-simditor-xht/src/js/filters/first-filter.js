'use strict';

// @ngInject
export default function() {

  return function(input, decimals) {
    if (!$.isNumeric(input)) {
      return input;
    } else {
      return Number(input).toFixed(decimals);
    }
  };
}
