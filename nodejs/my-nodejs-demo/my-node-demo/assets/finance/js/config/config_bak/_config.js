'use strict';
import httpInterceptor from './httpInterceptor';
import uiZeroclipConfig from './uiZeroclipConfig';
import toastrConfig from './toastrConfig';
import angularDateRangePickerDecorator from './angularDateRangePickerDecorator';
import nvd3LineChartFixTips from './nvd3LineChartFixTips';

export default angular
  .module('app.config', [])
  .config(httpInterceptor)
  .config(uiZeroclipConfig)
  .config(toastrConfig)
  .config(angularDateRangePickerDecorator)
  .config(nvd3LineChartFixTips);

