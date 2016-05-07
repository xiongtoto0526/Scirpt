'use strict';

var cwd = process.cwd();

module.exports = {
  stylesPath: [
    'assets/finance-we/sass/main-finance-we.scss'
  ],

  template: {
    financeWe: {
      files: 'assets/finance-we/views/**/*.tpl.html',
      fileName: 'template-finance-we.js',
      moduleName: 'assets.template.finance.we'
    }
  },

  bundle: {
    financeWe: {
      type: 'finance-we',
      entry: 'assets/finance-we/js/main-finance-we.js',
      weClient: true
    }
  },

  paths: {
    expressjs: [
      'app.js',
      'routes/**/*.js'
    ],
    sass: [
      'assets/**/*.scss'
    ],
    views: cwd + '/views/**/*.ejs',

    tpl: {
      financeWe: 'assets/finance-we/views/**/*.tpl.html'
    },
    js: {
      financeWe: ['assets/finance-we/**/*.js', '!app/finance-we/js/template-finance-we.js']
    }
  }
};
