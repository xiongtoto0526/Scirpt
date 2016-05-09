'use strict';

$(document).ready(function() {
  (function init() {

    $('body').show();

    loadProjectList();

    function loadProjectList() {

      window.charts = { };
      window.projectList = [];
      window.projectConfig = { };
      window.spinner = new Spinner();

      window.viewProject = function(id) {
        window.projectConfig = _.find(window.projectList, function(item) {
          return item.id == id;
        });

        document.title = '成本看板 - ' + (projectConfig.name == '大连-幽灵(项目二)' ? '大连项目二(三消手游)' : (projectConfig.name == '剑三' ? '剑网3' : projectConfig.name));
        var $iframe = $('<iframe src="/favicon.ico"></iframe>');
        $iframe.on('load', function() {
          setTimeout(function() {
            $iframe.off('load').remove();
          }, 0);
        }).appendTo($('body'));

        initProject();
      };

      window.back2ProjectList = function() {
        document.title = '成本看板';
        var $iframe = $('<iframe src="/favicon.ico"></iframe>');
        $iframe.on('load', function() {
          setTimeout(function() {
            $iframe.off('load').remove();
          }, 0);
        }).appendTo($('body'));

        $('.project-list').show();

        setTimeout(function() {
          window.projectScroll.refresh();
        }, 0);
      };

      window.showSpinner = function() {
        spinner.spin($('body')[0]);
        $('body').css('opacity', 0.2);
      };

      window.hideSpinner = function() {
        spinner.stop();
        $('body').css('opacity', 1);
      };

      $('.wp-inner').fullpage({
        beforeChange: function(e) {
          var visiblePageSize = _.filter($('.page'), function(item) {
            return $(item).css('display') != 'none';
          }).length;
          if (e.next == visiblePageSize) {
            return false;
          }
        },
        afterChange: function(e) {
          _.each(_.values(window.charts), function(chart) {
            chart.resize();
          });
        }
      });

      $('.left-switch-btn, .right-switch-btn').on('click', function() {
        if ($(this).hasClass('active')) {
          return;
        } else {
          $('.switch-btn-group .active').removeClass('active');
          $(this).addClass('active');
          $('.cost-table-wrap .table').remove();
          window.createCostDetailTable(window.projectResult, ($(this).hasClass('left-switch-btn') ? 'directCostItems' : 'indirectCostItems'));
        }
      });

      window.handleOutsourceCost = function() {
        _.each(window.projectResult.history, function(history) {
          var indirectCosts = history.indirectCostItems;
          var outsourceItem = _.filter(indirectCosts, function(indirectCost) {
            return indirectCost.name == '外包费用';
          })[0];

          if (outsourceItem && outsourceItem.value) {
            var directCosts = history.directCostItems;
            for (var i = 0; i < directCosts.length; i++) {
              var directCost = directCosts[i];
              if (directCost && (directCost.name == '直接费用' || directCost.name == '研发费' || directCost.name == '直接费用（研发+运营）')) {
                directCost.value = (directCost.value - outsourceItem.value);
              }
            }

            for (var i = 0; i < indirectCosts.length; i++) {
              var indirectCost = indirectCosts[i];
              if (indirectCost && indirectCost.name == '分摊费用') {
                indirectCost.value = (indirectCost.value + outsourceItem.value);
              }
            }
          }
        });
      };

      window.createCostDetailTable = function(data, type) {
        var monthArray = _.pluck(data.history, 'month');
        var monthTh = _.reduce(monthArray, function(memo, item, index) {
          if (index == monthArray.length - 1) {
            return memo + '<th>' + new moment(item, 'YYYY-M').format('M月') + '<span class="red blue small">环比</span></th>';
          } else {
            return memo + '<th>' + new moment(item, 'YYYY-M').format('M月') + '</th>';
          }
        }, '');

        var table = $('<table class="table fixed-headers"></table>');
        table.append($('<thead><tr><th>费用名称</th>' + monthTh + '</tr></thead>'));
        var tbody = $('<tbody class="tbody"></tbody>');
        table.append(tbody);
        var scrollTr = $('<tr></tr>');
        tbody.append(scrollTr);

        var itemNames = [];
        var lastItemName = '';
        _.each(_.pluck(data.history, type), function(items) {
          _.each(items, function(item) {
            var itemName = item.name;
            if (itemNames.indexOf(itemName) <= -1) {
              if (itemNames.indexOf(lastItemName) > -1) {
                itemNames.splice(itemNames.indexOf(lastItemName) + 1, 0, itemName);
              } else {
                itemNames.push(itemName);
              }
            }
            lastItemName = itemName;
          });
        });

        for (var i = 0; i < itemNames.length; i++) {
          var itemName = itemNames[i];
          var itemAlias = itemName;
          if (itemName == '分摊费用') {
            continue;
          }
          if (itemName == '直接费用') {
            itemAlias = '人力成本';
          } else if (itemName == '西山居总裁室') {
            itemAlias = '西山居管理平台（含总裁办）';
          }
          var itemLevel = _.find(_.flatten(_.pluck(data.history, type)), function(item) {
            return item.name == itemName;
          }).level;
          var row = $('<tr' + ((itemLevel == 1 || (type == 'indirectCostItems' && itemLevel == 2)) ? ' class="first-level"' : '') + '></tr>');
          row.append($('<td></td>').html('<div class="name' + (itemAlias.length > 5 ? ' small' : '') + '">' + itemAlias.replace(/\s/, '<br/>') + '</div>'));

          var values = _.map(_.pluck(data.history, type), function(items, index) {
            var theItem = _.filter(items, function(item) {
              return item.name == itemName;
            })[0];
            return theItem;
          }, { history: data.history });

          var haveNotZeroValue = _.some(values, function(item) {
            return item && item.value && Number(Number(item.value).toFixed(1));
          });
          if (!haveNotZeroValue) {
            continue;
          }

          _.each(values, function(item, index, array) {
            if (index == array.length - 1) {
              var last2Item = array[array.length - 2];
              var lastItem = array[array.length - 1];
              var compareHtml = '';
              if (!last2Item || !Number(last2Item.value) || !Number(Number(last2Item.value).toFixed(1))) {
                compareHtml = '<span class="blue margin3">-</span>';
              } else if (!lastItem || !Number(lastItem.value) || !Number(Number(lastItem.value).toFixed(1))) {
                compareHtml = '<span class="blue margin3">-</span>';
              } else {
                var ratio = Number(((Number(Number(lastItem.value).toFixed(1)) - Number(Number(last2Item.value).toFixed(1))) / Number(Number(last2Item.value).toFixed(1)) * 100).toFixed(1));
                if (ratio > 20) {
                  compareHtml = '<span class="red margin3">' + ratio.toFixed(1) + '%</span>';
                } else {
                  compareHtml = '<span class="blue margin3">' + ratio.toFixed(1) + '%</span>';
                }
              }

              row.append($('<td></td>').html(((item && item.value) ? Number(Number(item.value).toFixed(1)) : '0') + compareHtml));
            } else {
              row.append($('<td></td>').html((item && item.value) ? Number(Number(item.value).toFixed(1)) : '0'));
            }
          });

          scrollTr.append(row);
        }

        table.appendTo('.cost-table-wrap');

        var scroll = new IScroll('.cost-table-wrap .tbody');
        scroll.on('scrollEnd', function() {
          if (Math.abs(this.y) < 10) {
            $.fn.fullpage.start();
          } else {
            $.fn.fullpage.stop();
          }
        });
      };

      var code = getUrlParameter('code');

      window.showSpinner();
      $.getJSON('/wechat/project-list', {
        code: code,
        month: new moment().format('YYYY-MM')
      }, loadProjectListCallBack);

      function getUrlParameter(name) {
        return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) || [, ''])[1].replace(/\+/g, '%20')) || null;
      }

      function loadProjectListCallBack(result) {
        window.projectList = result;
        if (_.isEmpty(result)) {
          alert('您没有负责项目');
          window.hideSpinner();
        } else if (result.length == 1) {
          $('.project-list').hide();
          $('.project-select').hide();
          window.projectConfig = result[0];
          document.title = '成本看板 - ' + (projectConfig.name == '大连-幽灵(项目二)' ? '大连项目二(三消手游)' : (projectConfig.name == '剑三' ? '剑网3' : projectConfig.name));
          var $iframe = $('<iframe src="/favicon.ico"></iframe>');
          $iframe.on('load', function() {
            setTimeout(function() {
              $iframe.off('load').remove();
            }, 0);
          }).appendTo($('body'));
          initProject();
        } else {
          $('.project-list').show();
          $('.project-select').show();

          _.each(result, function(item) {
            var paneHeight = $('.project-wrap').width() * 0.4 * 1.35;
            var statusCls = item.status == 'dev' ? 'dev' : 'oper';
            var itemName = (item.name == '大连-幽灵(项目二)' ? '大连项目二(三消手游)' : (item.name == '剑三' ? '剑网3' : item.name));
            var leftBudgetStr = '剩余预算 ' + (Number(Number(item.leftBudget).toFixed(1)) ? Number(item.leftBudget).toFixed(1) : '-');
            var revenueStr = '当月收入 ' + (Number(Number(item.revenue).toFixed(1)) ? Number(item.revenue).toFixed(1) : '-');

            var projectPane = $('<div class="project-pane ' + statusCls + '" style="height: ' + paneHeight + 'px" onclick="window.viewProject(' + item.id + ')"></div>');
            projectPane.append($('<button class="invisible-btn"></button>'));
            projectPane.append($('<div class="project-name">' + itemName + '</div>'));
            projectPane.append($('<div class="leaders">' + (_.isEmpty(item.leaders) ? '' : item.leaders.join(', ')) + '</div>'));
            projectPane.append($('<div class="info">' + (item.status == 'dev' ? leftBudgetStr : revenueStr) + '</div>'));
            projectPane.append($('<div class="project-view-btn-wrap"><button class="project-view-btn">查看</button></div>'));
            $('.project-wrap').append(projectPane);
          });

          if ($('.wp').width() < 380) {
            $('.project-pane').children().css('zoom', .7);
          }
          window.projectScroll = new IScroll('.project-scroll');
          window.hideSpinner();
        }
      }

      function initProject() {
        window.showSpinner();
        $.fn.fullpage.moveTo(0);
        $.fn.fullpage.start();
        $('.project-list').hide();

        if (window.projectConfig.status == 'all') {
          loadLabProject();
          $('.page1').show();
        } else {
          $('.page1').hide();
        }
        loadProjectReport();

        function loadLabProject() {
          $.getJSON('/repr/devproj', {
            code: getUrlParameter('code'),
            month: new moment().format('YYYY-MM')
          }, loadLabProjectCallBack);
        }

        function loadLabProjectCallBack(r) {
          var result = r.data;

          $('.table-wrap .table').remove();
          createTable(result);

          function createTable(data) {
            var table = $('<table class="table fixed-headers"></table>');
            table.append($('<thead><tr><th>项目</th><th>负责人</th><th>总预算</th><th>剩余预算</th><th>累计成本</th><th>当月成本/人数</th></tr></thead>'));
            var tbody = $('<tbody class="tbody"></tbody>');
            table.append(tbody);
            var scrollTr = $('<tr></tr>');
            tbody.append(scrollTr);
            for (var i = 0; i < data.length; i++) {
              var rowData = data[i];
              var row = $('<tr></tr>');
              var name = rowData.name == '大连-幽灵(项目二)' ? '大连项目二(三消手游)' : (rowData.name == '剑三' ? '剑网3' : rowData.name);
              row.append($('<td></td>').html('<div class="name' + (name.length > 5 ? ' small' : '') + '">' + name.replace(/\s/, '<br/>') + '</div><div class="small">' + new moment(rowData.startTime).format('YYYY-MM') + '</div>'));
              var leaderContent = '';
              for (var j = 0; j < rowData.leaders.length; j++) {
                var leaderName = rowData.leaders[j];
                leaderContent += '<div class="leader">' + leaderName + '</div>';
              }
              row.append($('<td></td>').html(leaderContent));
              row.append($('<td></td>').html(rowData.totalBudget ? Number(rowData.totalBudget).toFixed(1) : '-'));
              if (Number(rowData.leftBudget) >= 0) {
                row.append($('<td></td>').html(rowData.leftBudget ? Number(rowData.leftBudget).toFixed(1) : '-'));
              } else {
                row.append($('<td></td>').html('<span class="red">' + (rowData.leftBudget ? Number(rowData.leftBudget).toFixed(1) : '-') + '</span>'));
              }
              row.append($('<td></td>').html(rowData.totalCost ? Number(rowData.totalCost).toFixed(1) : ''));
              row.append($('<td></td>').html((rowData.monthlyCost ? Number(rowData.monthlyCost).toFixed(1) : '') + ' / ' + (rowData.monthlyPeople ? Number(rowData.monthlyPeople).toFixed(0) : '')));

              scrollTr.append(row);
            }

            table.appendTo('.table-wrap');

            $.fn.fullpage.stop();
            var scroll = new IScroll('.table-wrap .tbody');
            scroll.on('scrollEnd', function() {
              if (Math.abs(this.maxScrollY) - Math.abs(this.y) < 10) {
                $.fn.fullpage.start();
              } else {
                $.fn.fullpage.stop();
              }
            });

            if ($('.wp').width() < 380) {
              $('.page1 .title').css('zoom', 0.85);
              $('.page1 .table').css('zoom', 0.85);
            }
          }
        }

        function loadProjectReport() {
          var startMonth = new moment().add(-4, 'M');
          if (startMonth.isBefore('2016-01')) {
            startMonth = new moment('2016-01');
          }
          $.getJSON('/repr/proj', {
            code: getUrlParameter('code'),
            projectId: window.projectConfig.id,
            startMonth: startMonth.format('YYYY-MM'),
            endMonth: new moment().format('YYYY-MM')
          }, loadProjectReportCallBack);
        }

        function loadProjectReportCallBack(r) {
          var result = r.data;
          window.projectResult = result;
          window.handleOutsourceCost();

          if (window.projectConfig.status != 'all') {
            initSummaryPage(result);
            $('.page2').show();
          } else {
            $('.page2').hide();
          }
          if (window.projectConfig.status != 'dev') {
            initProfitPage(result);
            initRevenuePage(result);
            $('.page3').show();
            $('.page4').show();
          } else {
            $('.page3').hide();
            $('.page4').hide();
          }
          initCostPage(result);
          initCostDetailPage(result);

          window.hideSpinner();

          function initSummaryPage(result) {
            $('.summary-month').html(moment(result.currentMonth.month, 'YYYY-M').format('YYYY 年 MM 月'));
            if (window.projectConfig.status == 'dev') {
              $('.first-label').html('当月费用');
              $('.first-value').html((result.currentMonth.cost ? Number(result.currentMonth.cost).toFixed(1) : '-') + '万');
              $('.second-label').html('累计费用');
              $('.second-value').html((result.currentMonth.totalCost ? Number(result.currentMonth.totalCost).toFixed(1) : '-') + '万');
              $('.third-label').html('总预算');
              $('.third-value').html((result.currentMonth.totalBudget ? Number(result.currentMonth.totalBudget).toFixed(1) : '-') + '万');
              $('.fourth-label').html('剩余预算');
              $('.fourth-value').html((result.currentMonth.leftBudget ? Number(result.currentMonth.leftBudget).toFixed(1) : '-') + '万');
              $('.summary-feet').hide();
            } else {
              $('.first-label').html('当月收入');
              $('.first-value').html((result.currentMonth.revenue ? Number(result.currentMonth.revenue).toFixed(1) : '-') + '万');
              $('.second-label').html('当月费用');
              $('.second-value').html((result.currentMonth.cost ? Number(result.currentMonth.cost).toFixed(1) : '-') + '万');
              $('.third-label').html('当月利润');
              $('.third-value').html((result.currentMonth.profit ? Number(result.currentMonth.profit).toFixed(1) : '-') + '万');
              $('.fourth-label').html('当月利润率');
              if (window.projectConfig.name == '锤子三国') {
                $('.fourth-value').html('-');
              } else {
                $('.fourth-value').html((result.currentMonth.profitMargin ? ((Number(result.currentMonth.profitMargin) * 100).toFixed(1) + '%') : '-'));
              }

              $('.summary-feet').show();
              $('.bottom-left-label').html('当月人均利润');
              $('.bottom-left-value').html((result.currentMonth.profitPerPerson ? Number(result.currentMonth.profitPerPerson).toFixed(1) : '-') + '万');
              $('.bottom-right-label').html('年收入预算');
              $('.bottom-right-value').html((result.currentMonth.anticipatedRevenue ? Number(result.currentMonth.anticipatedRevenue).toFixed(1) : '-') + '万');
            }

            if ($('.wp').width() < 380) {
              $('.page2 .summary-panes').css('zoom', 0.85);
              $('.page2 .summary-feet').css('zoom', 0.85);
            }
          }

          function initProfitPage(result) {
            initTop(result);
            initBottom(result);

            function initTop(result) {
              if (window.charts.profitChart) {
                window.charts.profitChart.dispose();
              }
              var option = {
                tooltip: {
                  trigger: 'axis',
                  axisPointer: {
                    type: 'line',
                    lineStyle: {
                      opacity: 0
                    }
                  },
                  formatter: function(params) {
                    var str = params[0].name + '<br/>';
                    str += params[0].seriesName + ' ' + params[0].value + '<br/>';
                    str += params[1].seriesName + ' ' + (Number(params[1].value) * 100).toFixed(1) + '%';
                    return str;
                  }
                },
                grid: {
                  top: 30,
                  bottom: 25,
                  left: 45,
                  right: 55
                },
                xAxis: [
                  {
                    type: 'category',
                    boundaryGap: true,
                    position: 'bottom',
                    nameTextStyle: {
                      color: 'transparent'
                    },
                    splitLine: {
                      show: false
                    },
                    axisLine: {
                      lineStyle: {
                        color: '#FFFFFF'
                      }
                    },
                    axisTick: {
                      lineStyle: {
                        color: '#FFFFFF'
                      }
                    },
                    axisLabel: {
                      textStyle: {
                        color: 'rgba(255, 255, 255, .8)'
                      }
                    },
                    data: (function() {
                      return _.map(_.pluck(result.history, 'month'), function(item) {
                        return new moment(item, 'YYYY-M').format('M月');
                      });
                    })()
                  }
                ],
                yAxis: [
                  {
                    type: 'value',
                    name: '利润',
                    position: 'left',
                    splitNumber: 3,
                    nameTextStyle: {
                      color: 'transparent'
                    },
                    splitLine: {
                      show: false
                    },
                    axisLine: {
                      lineStyle: {
                        color: '#FFFFFF'
                      }
                    },
                    axisTick: {
                      lineStyle: {
                        color: '#FFFFFF'
                      }
                    },
                    axisLabel: {
                      textStyle: {
                        color: 'rgba(255, 255, 255, .8)'
                      }
                    }
                  },
                  {
                    type: 'value',
                    name: '利润率',
                    position: 'right',
                    scale: true,
                    splitNumber: 3,
                    nameTextStyle: {
                      color: 'transparent'
                    },
                    splitLine: {
                      show: false
                    },
                    axisLine: {
                      lineStyle: {
                        color: '#FFFFFF'
                      }
                    },
                    axisTick: {
                      lineStyle: {
                        color: '#FFFFFF'
                      }
                    },
                    axisLabel: {
                      formatter: function(value, index) {
                        return (Number(value) * 100).toFixed(0) + '%';
                      },
                      textStyle: {
                        color: 'rgba(255, 255, 255, .8)'
                      }
                    }
                  }
                ],
                series: [
                  {
                    name: '利润',
                    type: 'bar',
                    xAxisIndex: 0,
                    yAxisIndex: 0,
                    barCategoryGap: '60%',
                    itemStyle: {
                      normal: {
                        color: 'rgba(255, 255, 255, .5)',
                        barBorderRadius: [2, 2, 0, 0]
                      },
                      emphasis: {
                        color: 'rgba(255, 255, 255, .8)',
                        shadowColor: '#2E8AE8',
                        shadowOffsetX: 2,
                        shadowOffsetY: 2
                      }
                    },
                    label: {
                      normal: {
                        show: true,
                        position: 'top',
                        textStyle: {
                          color: '#FFFFFF',
                          opacity: 1
                        }
                      },
                      emphasis: {
                        show: true,
                        position: 'top',
                        textStyle: {
                          color: '#FFFFFF',
                          opacity: 1,
                          fontSize: 16
                        }
                      }
                    },
                    data: (function() {
                      return _.map(_.pluck(result.history, 'profit'), function(item) {
                        return Number(item).toFixed(1);
                      });
                    })()
                  },
                  {
                    name: '利润率',
                    type: 'line',
                    xAxisIndex: 0,
                    yAxisIndex: 1,
                    symbol: 'roundRect',
                    symbolSize: 7,
                    lineStyle: {
                      normal: {
                        color: '#FFFFFF',
                        opacity: 0.8
                      }
                    },
                    itemStyle: {
                      normal: {
                        color: '#0072E2',
                        opacity: 0.8
                      }
                    },
                    data: (function() {
                      return _.map(_.pluck(result.history, 'profitMargin'), function(item) {
                        return (Number(item)).toFixed(3);
                      });
                    })()
                  }
                ]
              };

              var chart = echarts.init($('.profit-chart')[0]);
              chart.setOption(option);
              window.charts.profitChart = chart;
            }

            function initBottom(result) {
              if (window.charts.pppChart) {
                window.charts.pppChart.dispose();
              }
              var option = {
                tooltip: {
                  trigger: 'axis',
                  axisPointer: {
                    type: 'line',
                    lineStyle: {
                      opacity: 0
                    }
                  },
                  formatter: function(params) {
                    var str = params[0].name + '<br/>';
                    str += params[0].seriesName + ' ' + params[0].value;
                    return str;
                  }
                },
                grid: {
                  top: 30,
                  bottom: 25,
                  left: 60,
                  right: 30
                },
                xAxis: [
                  {
                    type: 'category',
                    boundaryGap: false,
                    position: 'bottom',
                    nameTextStyle: {
                      color: 'transparent'
                    },
                    splitLine: {
                      lineStyle: {
                        color: '#F0F0F0'
                      }
                    },
                    axisLine: {
                      lineStyle: {
                        color: '#EDEDED'
                      }
                    },
                    axisTick: {
                      lineStyle: {
                        color: '#EDEDED'
                      }
                    },
                    axisLabel: {
                      textStyle: {
                        color: '#696969'
                      }
                    },
                    data: (function() {
                      return _.map(_.pluck(result.history, 'month'), function(item) {
                        return new moment(item, 'YYYY-M').format('M月');
                      });
                    })()
                  }
                ],
                yAxis: [
                  {
                    type: 'value',
                    name: '人均利润',
                    position: 'left',
                    splitNumber: 3,
                    nameTextStyle: {
                      color: 'transparent'
                    },
                    splitLine: {
                      lineStyle: {
                        color: '#F0F0F0'
                      }
                    },
                    axisLine: {
                      lineStyle: {
                        color: '#EDEDED'
                      }
                    },
                    axisTick: {
                      lineStyle: {
                        color: '#EDEDED'
                      }
                    },
                    axisLabel: {
                      margin: 20,
                      textStyle: {
                        color: '#696969'
                      }
                    }
                  }
                ],
                series: [
                  {
                    name: '人均利润',
                    type: 'line',
                    symbol: 'emptyCircle',
                    symbolSize: 7,
                    lineStyle: {
                      normal: {
                        color: '#0072E2'
                      }
                    },
                    itemStyle: {
                      normal: {
                        color: '#0072E2'
                      }
                    },
                    areaStyle: {
                      normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                          offset: 0,
                          color: '#0072E2'
                        }, {
                          offset: 1,
                          color: '#02BCF7'
                        }])
                      }
                    },
                    label: {
                      normal: {
                        show: true,
                        position: 'top',
                        textStyle: {
                          color: '#0072E2'
                        }
                      },
                      emphasis: {
                        show: true,
                        position: 'top',
                        textStyle: {
                          color: '#0072E2',
                          fontSize: 16
                        }
                      }
                    },
                    data: (function() {
                      return _.map(_.pluck(result.history, 'profitPerPerson'), function(item) {
                        return Number(item).toFixed(2);
                      });
                    })()
                  }
                ]
              };

              var chart = echarts.init($('.ppp-chart')[0]);
              chart.setOption(option);
              window.charts.pppChart = chart;
            }
          }

          function initRevenuePage(result) {
            initTop(result);
            initBottom(result);

            function initTop(result) {
              if (window.charts.revenueChart) {
                window.charts.revenueChart.dispose();
              }
              var option = {
                tooltip: {
                  trigger: 'axis',
                  axisPointer: {
                    type: 'line',
                    lineStyle: {
                      opacity: 0
                    }
                  },
                  formatter: function(params) {
                    var str = params[0].name + '<br/>';
                    str += params[0].seriesName + ' ' + params[0].value;
                    return str;
                  }
                },
                grid: {
                  top: 30,
                  bottom: 25,
                  left: 75,
                  right: 30
                },
                xAxis: [
                  {
                    type: 'category',
                    boundaryGap: false,
                    position: 'bottom',
                    nameTextStyle: {
                      color: 'transparent'
                    },
                    splitLine: {
                      lineStyle: {
                        color: '#F0F0F0'
                      }
                    },
                    axisLine: {
                      lineStyle: {
                        color: '#EDEDED'
                      }
                    },
                    axisTick: {
                      lineStyle: {
                        color: '#EDEDED'
                      }
                    },
                    axisLabel: {
                      textStyle: {
                        color: '#696969'
                      }
                    },
                    data: (function() {
                      return _.map(_.pluck(result.history, 'month'), function(item) {
                        return new moment(item, 'YYYY-M').format('M月');
                      });
                    })()
                  }
                ],
                yAxis: [
                  {
                    type: 'value',
                    name: '净收入',
                    position: 'left',
                    splitNumber: 3,
                    nameTextStyle: {
                      color: 'transparent'
                    },
                    splitLine: {
                      lineStyle: {
                        color: '#F0F0F0'
                      }
                    },
                    axisLine: {
                      lineStyle: {
                        color: '#EDEDED'
                      }
                    },
                    axisTick: {
                      lineStyle: {
                        color: '#EDEDED'
                      }
                    },
                    axisLabel: {
                      margin: 25,
                      textStyle: {
                        color: '#696969'
                      }
                    }
                  }
                ],
                series: [
                  {
                    name: '净收入',
                    type: 'line',
                    symbol: 'emptyCircle',
                    symbolSize: 7,
                    lineStyle: {
                      normal: {
                        color: '#0072E2'
                      }
                    },
                    itemStyle: {
                      normal: {
                        color: '#0072E2'
                      }
                    },
                    areaStyle: {
                      normal: {
                        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                          offset: 0,
                          color: '#0072E2'
                        }, {
                          offset: 1,
                          color: '#02BCF7'
                        }])
                      }
                    },
                    label: {
                      normal: {
                        show: true,
                        position: 'top',
                        textStyle: {
                          color: '#0072E2'
                        }
                      },
                      emphasis: {
                        show: true,
                        position: 'top',
                        textStyle: {
                          color: '#0072E2',
                          fontSize: 16
                        }
                      }
                    },
                    data: (function() {
                      var revenue = [];
                      _.each(_.pluck(result.history, 'revenueItems'), function(items) {
                        var firstLevelRevenue = _.filter(items, function(item) {
                          return item.level == 1;
                        });
                        revenue.push(_.reduce(firstLevelRevenue, function(memo, item) {
                          return memo + Number(item.value);
                        }, 0).toFixed(1));
                      });
                      return revenue;
                    })()
                  }
                ]
              };

              var chart = echarts.init($('.revenue-chart')[0]);
              chart.setOption(option);
              window.charts.revenueChart = chart;
            }

            function initBottom(result) {
              if (window.charts.revenueItemChart) {
                window.charts.revenueItemChart.dispose();
              }
              var option = {
                tooltip: {
                  trigger: 'axis',
                  axisPointer: {
                    type: 'line',
                    lineStyle: {
                      opacity: 0
                    }
                  },
                  formatter: function(params) {
                    var str = params[0].name + '<br/>';
                    _.each(params, function(param) {
                      var value = param.value;
                      if (param.seriesName == '内部结算成本' || param.seriesName == '分成给集团') {
                        value = Math.abs(param.value);
                      }
                      str += (param.seriesName.length < 6 ? param.seriesName : (param.seriesName.substr(0, 5) + '...')) + ' ' + Number(value).toFixed(1) + '<br/>';
                    });
                    return str;
                  }
                },
                grid: {
                  top: 20,
                  bottom: 70,
                  left: 70,
                  right: 20
                },
                legend: {
                  bottom: 0,
                  itemHeight: 8,
                  itemWidth: 8,
                  data: _.unique(_.pluck(_.flatten(_.pluck(result.history, 'revenueItems')), 'name'))
                },
                xAxis: [
                  {
                    type: 'category',
                    boundaryGap: true,
                    position: 'bottom',
                    nameTextStyle: {
                      color: 'transparent'
                    },
                    splitLine: {
                      lineStyle: {
                        color: '#F0F0F0'
                      }
                    },
                    axisLine: {
                      lineStyle: {
                        color: '#EDEDED'
                      }
                    },
                    axisTick: {
                      lineStyle: {
                        color: '#EDEDED'
                      }
                    },
                    axisLabel: {
                      textStyle: {
                        color: '#696969'
                      }
                    },
                    data: (function() {
                      return _.map(_.pluck(result.history, 'month'), function(item) {
                        return new moment(item, 'YYYY-M').format('M月');
                      });
                    })()
                  }
                ],
                yAxis: [
                  {
                    type: 'value',
                    name: '收入构成',
                    position: 'left',
                    splitNumber: 3,
                    nameTextStyle: {
                      color: 'transparent'
                    },
                    splitLine: {
                      lineStyle: {
                        color: '#F0F0F0'
                      }
                    },
                    axisLine: {
                      lineStyle: {
                        color: '#EDEDED'
                      }
                    },
                    axisTick: {
                      lineStyle: {
                        color: '#EDEDED'
                      }
                    },
                    axisLabel: {
                      margin: 15,
                      textStyle: {
                        color: '#696969'
                      }
                    }
                  }
                ],
                series: (function() {
                  var colors = ['#0072E2', '#66AAEE', '#99C7F3'];
                  var bars = [];

                  var itemsNames = [];
                  _.each(_.pluck(result.history, 'revenueItems'), function(items) {
                    var itemNames = [];
                    _.each(items, function(item) {
                      if (item.level == 1) {
                        itemNames.push(item.name);
                      }
                    });
                    itemsNames = itemsNames.concat(itemNames);
                  });
                  itemsNames = _.unique(itemsNames);
                  _.each(itemsNames, function(itemName, index) {
                    var revenueItemData = _.map(_.pluck(_.map(_.pluck(result.history, 'revenueItems'), function(items) {
                      return _.filter(items, function(item) {
                        return item.name == itemName;
                      })[0];
                    }), 'value'), function(item) {
                      if (item) {
                        return Number(item).toFixed(1);
                      } else {
                        return 0;
                      }
                    });

                    var haveNotZeroValue = _.some(revenueItemData, function(item) {
                      if (Number(item)) {
                        return true;
                      }
                    });

                    if (!haveNotZeroValue) {
                      return;
                    }

                    bars.push({
                      name: itemName,
                      type: 'bar',
                      barCategoryGap: '40%',
                      stack: 'revenueItems',
                      itemStyle: {
                        normal: {
                          color: colors[index],
                          opacity: 0.8
                        },
                        emphasis: {
                          color: colors[index],
                          opacity: 1
                        }
                      },
                      data: revenueItemData
                    });
                  });
                  return bars;
                })()
              };

              var chart = echarts.init($('.revenue-items-chart')[0]);
              chart.setOption(option);
              window.charts.revenueItemChart = chart;
            }
          }

          function initCostPage(result) {
            initTop(result);
            initBottom(result);

            function initTop(result) {
              if (window.charts.costChart) {
                window.charts.costChart.dispose();
              }
              var option = {
                tooltip: {
                  trigger: 'axis',
                  axisPointer: {
                    type: 'line',
                    lineStyle: {
                      opacity: 0
                    }
                  },
                  formatter: function(params) {
                    var str = params[0].name + '<br/>';
                    str += params[1].seriesName + ' ' + Math.abs(params[1].value).toFixed(1) + '<br/>';
                    str += params[0].seriesName + ' ' + Math.abs(params[0].value).toFixed(1);
                    return str;
                  }
                },
                grid: {
                  top: 20,
                  bottom: 50,
                  left: 55,
                  right: 20
                },
                legend: {
                  bottom: 0,
                  itemHeight: 8,
                  itemWidth: 8,
                  data: [{
                    name: '直接费用',
                    textStyle: {
                      color: '#F9DA39'
                    }
                  }, {
                    name: '间接费用',
                    textStyle: {
                      color: '#FFFFFF'
                    }
                  }]
                },
                xAxis: [
                  {
                    type: 'category',
                    boundaryGap: true,
                    position: 'bottom',
                    nameTextStyle: {
                      color: 'transparent'
                    },
                    splitLine: {
                      show: false
                    },
                    axisLine: {
                      lineStyle: {
                        color: '#FFFFFF'
                      }
                    },
                    axisTick: {
                      lineStyle: {
                        color: '#FFFFFF'
                      }
                    },
                    axisLabel: {
                      textStyle: {
                        color: 'rgba(255, 255, 255, .8)'
                      }
                    },
                    data: (function() {
                      return _.map(_.pluck(result.history, 'month'), function(item) {
                        return new moment(item, 'YYYY-M').format('M月');
                      });
                    })()
                  }
                ],
                yAxis: [
                  {
                    type: 'value',
                    name: '费用',
                    position: 'left',
                    splitNumber: 3,
                    nameTextStyle: {
                      color: 'transparent'
                    },
                    splitLine: {
                      show: false
                    },
                    axisLine: {
                      lineStyle: {
                        color: '#FFFFFF'
                      }
                    },
                    axisTick: {
                      lineStyle: {
                        color: '#FFFFFF'
                      }
                    },
                    axisLabel: {
                      textStyle: {
                        color: 'rgba(255, 255, 255, .8)'
                      }
                    }
                  }
                ],
                series: (function() {
                  var directCost = [];
                  _.each(_.pluck(result.history, 'directCostItems'), function(items) {
                    var firstLevelCost = _.filter(items, function(item) {
                      return item.level == 1;
                    });
                    directCost.push(_.reduce(firstLevelCost, function(memo, item) {
                      return memo + Number(item.value);
                    }, 0).toFixed(1));
                  });

                  var indirectCost = [];
                  _.each(_.pluck(result.history, 'indirectCostItems'), function(items) {
                    var firstLevelCost = _.filter(items, function(item) {
                      return item.level == 1;
                    });
                    indirectCost.push(_.reduce(firstLevelCost, function(memo, item) {
                      return memo + Number(item.value);
                    }, 0).toFixed(1));
                  });

                  return [{
                    name: '间接费用',
                    type: 'bar',
                    barCategoryGap: '40%',
                    stack: 'cost',
                    itemStyle: {
                      normal: {
                        color: '#FFFFFF',
                        opacity: 0.9
                      },
                      emphasis: {
                        color: '#FFFFFF',
                        opacity: 1
                      }
                    },
                    data: indirectCost
                  }, {
                    name: '直接费用',
                    type: 'bar',
                    barCategoryGap: '40%',
                    stack: 'cost',
                    itemStyle: {
                      normal: {
                        color: '#F9DA39',
                        opacity: 0.9
                      },
                      emphasis: {
                        color: '#F9DA39',
                        opacity: 1
                      }
                    },
                    data: directCost
                  }];
                })()
              };

              var chart = echarts.init($('.cost-chart')[0]);
              chart.setOption(option);
              window.charts.costChart = chart;
            }

            function initBottom(result) {
              if (window.charts.directCostChart) {
                window.charts.directCostChart.dispose();
              }
              if (window.charts.indirectCostChart) {
                window.charts.indirectCostChart.dispose();
              }
              $('.cost-month').html(moment(result.currentMonth.month, 'YYYY-M').format('M月'));

              var colors = ['#004C98', '#0072E2', '#66AAEE', '#99C7F3', '#CCE3F9'];

              var currentMonthData = _.filter(result.history, function(item) {
                return item.month == result.currentMonth.month;
              })[0];

              var leftData = _.filter(formatData(_.map(_.filter(currentMonthData.directCostItems, function(item) {
                return item.level == 1;
              }), function(item) {
                item.value = Number(item.value).toFixed(1);
                return item;
              })), function(item) {
                return item && item.value && Number(item.value);
              });

              var rightData = _.filter(formatData(_.map(_.filter(currentMonthData.indirectCostItems, function(item) {
                return item.level == 2;
              }), function(item) {
                item.value = Number(item.value).toFixed(1);
                return item;
              })), function(item) {
                return item && item.value && Number(item.value);
              });

              var leftOption = getPieOption(leftData, colors);
              var rightOption = getPieOption(rightData, colors);

              var leftChart = echarts.init($('.direct-cost-chart')[0]);
              leftChart.setOption(leftOption);
              window.charts.directCostChart = leftChart;

              var rightchart = echarts.init($('.indirect-cost-chart')[0]);
              rightchart.setOption(rightOption);
              window.charts.indirectCostChart = rightchart;

              function formatData(data) {
                var sortedData = _.sortBy(data, function(items) {
                  return 0 - items.value;
                });
                if (sortedData.length > 5) {
                  var leftData = sortedData.slice(4);
                  var leftValue = _.reduce(leftData, function(memo, item) {
                    return memo + Number(item.value);
                  }, 0).toFixed(2);

                  var formattedData = sortedData.slice(0, 4);
                  formattedData.push({
                    name: '其他',
                    value: leftValue,
                    level: '1'
                  });
                  return formattedData;
                } else {
                  return sortedData;
                }
              }

              function getPieOption(data, colors) {
                return {
                  tooltip: {
                    trigger: 'axis',
                    formatter: function(params) {
                      var str = params[0].name + '<br/>';
                      _.each(params, function(param) {
                        str += (param.seriesName.length < 6 ? param.seriesName : (param.seriesName.substr(0, 5) + '...')) + ' ' + Math.abs(param.value) + '<br/>';
                      });
                      return str;
                    }
                  },
                  legend: {
                    bottom: 30,
                    itemHeight: 8,
                    itemWidth: 8,
                    data: data,
                    itemGap: 3,
                    orient: 'horizontal',
                    textStyle: {
                      fontSize: 8
                    },
                    formatter: function(name) {
                      if (name.length > 8) {
                        return name.slice(0, 8) + '...';
                      } else {
                        return name;
                      }
                    }
                  },
                  series: {
                    name: '费用构成',
                    type: 'pie',
                    center: ['50%', '35%'],
                    radius: ['45%', '70%'],
                    avoidLabelOverlap: false,
                    label: {
                      normal: {
                        show: false,
                        position: 'center',
                        textStyle: {
                          color: '#464746',
                          fontSize: 16
                        },
                        formatter: function(params) {
                          return _.reduce(data, function(memo, item) {
                            return memo + Number(item.value);
                          }, 0).toFixed(2);
                        }
                      },
                      emphasis: {
                        show: true,
                        position: 'center',
                        textStyle: {
                          color: '#464746',
                          fontSize: 12
                        },
                        formatter: function(params) {
                          return (params.name.length < 6 ? params.name : (params.name.substr(0, 5) + '...')) + '\n' + Number(params.value).toFixed(1);
                        }
                      }
                    },
                    itemStyle: {
                      normal: {
                        color: function(e) {
                          return colors[e.dataIndex];
                        }
                      }
                    },
                    labelLine: {
                      normal: {
                        show: false
                      }
                    },
                    data: data
                  }
                };
              }
            }
          }

          function initCostDetailPage(result) {

            var result = result;

            $('.switch-btn-group .active').removeClass('active');
            $('.left-switch-btn').addClass('active');
            $('.cost-table-wrap .table').remove();
            window.createCostDetailTable(window.projectResult, 'directCostItems');

            if ($('.wp').width() < 380) {
              $('.page6 .light-blue-pane').css('zoom', 0.85);
              $('.page6 .table').css('zoom', 0.85);
            }
          }
        }
      }
    }
  })();
});
