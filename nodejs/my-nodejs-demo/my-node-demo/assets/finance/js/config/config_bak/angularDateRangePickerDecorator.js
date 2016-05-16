'use strict';

// @ngInject
// Fixed Single Date Picker Issue.
// For angular-daterangepicker
// For version 0.2.1
export default function($provide) {
  $provide.decorator('dateRangePickerDirective', function($delegate, $compile, $timeout, $parse, dateRangePickerConfig) {
    var link = function($scope, element, attrs, modelCtrl) {
      var customOpts;
      var el;
      var opts;
      var _clear;
      var _format;
      var _init;
      var _initBoundaryField;
      var _mergeOpts;
      var _picker;
      var _setDatePoint;
      var _setEndDate;
      var _setStartDate;
      var _setViewValue;
      var _validate;
      var _validateMax;
      var _validateMin;
      _mergeOpts = function() {
        var extend;
        var localeExtend;
        localeExtend = angular.extend.apply(angular, Array.prototype.slice.call(arguments).map(function(opt) {
          return opt != null ? opt.locale : void 0;
        }).filter(function(opt) {
          return !!opt;
        }));
        extend = angular.extend.apply(angular, arguments);
        extend.locale = localeExtend;
        return extend;
      };
      el = $(element);
      customOpts = $scope.opts;
      opts = _mergeOpts({}, dateRangePickerConfig, customOpts);
      _picker = null;
      _clear = function() {
        _picker.setStartDate();
        return _picker.setEndDate();
      };
      _setDatePoint = function(setter) {
        return function(newValue) {
          if (_picker && newValue) {
            return setter(moment(newValue));
          }
        };
      };
      _setStartDate = _setDatePoint(function(m) {
        if (_picker.endDate < m) {
          _picker.setEndDate(m);
        }
        return _picker.setStartDate(m);
      });
      _setEndDate = _setDatePoint(function(m) {
        if (_picker.startDate > m) {
          _picker.setStartDate(m);
        }
        return _picker.setEndDate(m);
      });
      _format = function(objValue) {
        var f;
        f = function(date) {
          if (!moment.isMoment(date)) {
            return moment(date).format(opts.locale.format);
          } else {
            return date.format(opts.locale.format);
          }
        };
        if (objValue) {
          if (opts.singleDatePicker) {
            // Start Fixed Single Date Picker Issue.
            if (objValue.startDate) {
              return f(objValue.startDate);
            } else {
              return f(objValue);
            }
          // End Fixed Single Date Picker Issue.
          } else {
            return [f(objValue.startDate), f(objValue.endDate)].join(opts.locale.separator);
          }
        } else {
          return '';
        }
      };
      _setViewValue = function(objValue) {
        var value;
        value = _format(objValue);
        el.val(value);
        return modelCtrl.$setViewValue(value);
      };
      _validate = function(validator) {
        return function(boundary, actual) {
          if (boundary && actual) {
            return validator(moment(boundary), moment(actual));
          } else {
            return true;
          }
        };
      };
      _validateMin = _validate(function(min, start) {
        return min.isBefore(start) || min.isSame(start, 'day');
      });
      _validateMax = _validate(function(max, end) {
        return max.isAfter(end) || max.isSame(end, 'day');
      });
      modelCtrl.$formatters.push(_format);
      modelCtrl.$render = function() {
        if (modelCtrl.$modelValue && modelCtrl.$modelValue.startDate) {
          _setStartDate(modelCtrl.$modelValue.startDate);
          _setEndDate(modelCtrl.$modelValue.endDate);
        } else {
          _clear();
        }
        return el.val(modelCtrl.$viewValue);
      };
      modelCtrl.$parsers.push(function(val) {
        var f;
        var objValue;
        var x;
        f = function(value) {
          return moment(value, opts.locale.format);
        };
        objValue = {startDate: null, endDate: null};
        if (angular.isString(val) && val.length > 0) {
          if (opts.singleDatePicker) {
            objValue = f(val);
          } else {
            x = val.split(opts.locale.separator).map(f);
            objValue.startDate = x[0];
            objValue.endDate = x[1];
          }
        }
        return objValue;
      });
      modelCtrl.$isEmpty = function(val) {
        return !(angular.isString(val) && val.length > 0);
      };
      _init = function() {
        var eventType;
        var _results;
        el.daterangepicker(angular.extend(opts, {
          autoUpdateInput: false
        }), function(start, end) {
          return _setViewValue({startDate: start, endDate: end});
        });
        _picker = el.data('daterangepicker');
        _results = [];
        for (eventType in opts.eventHandlers) {
          _results.push(el.on(eventType, function(e) {
            var eventName;
            eventName = e.type + '.' + e.namespace;
            return $scope.$evalAsync(opts.eventHandlers[eventName]);
          }));
        }
        return _results;
      };
      _init();
      $scope.$watch('model.startDate', function(n) {
        _setStartDate(n);
        return _setViewValue($scope.model);
      });
      $scope.$watch('model.endDate', function(n) {
        _setEndDate(n);
        return _setViewValue($scope.model);
      });
      _initBoundaryField = function(field, validator, modelField, optName) {
        if (attrs[field]) {
          modelCtrl.$validators[field] = function(value) {
            return value && validator(opts[optName], value[modelField]);
          };
          return $scope.$watch(field, function(date) {
            opts[optName] = date ? moment(date) : false;
            return _init();
          });
        }
      };
      _initBoundaryField('min', _validateMin, 'startDate', 'minDate');
      _initBoundaryField('max', _validateMax, 'endDate', 'maxDate');
      if (attrs.options) {
        $scope.$watch('opts', function(newOpts) {
          opts = _mergeOpts(opts, newOpts);
          return _init();
        }, true);
      }
      if (attrs.clearable) {
        $scope.$watch('clearable', function(newClearable) {
          if (newClearable) {
            opts = _mergeOpts(opts, {
              locale: {
                cancelLabel: opts.clearLabel
              }
            });
          }
          _init();
          return el.on('cancel.daterangepicker', (newClearable ? _setViewValue.bind(this, {
            startDate: null,
            endDate: null
          }) : null));
        });
      }
      return $scope.$on('$destroy', function() {
        return _picker != null ? _picker.remove() : void 0;
      });
    };

    $delegate[0].compile = function() {
      return function($scope, element, attrs, modelCtrl) {
        link.apply(this, arguments);
      };
    };

    return $delegate;
  });
};
