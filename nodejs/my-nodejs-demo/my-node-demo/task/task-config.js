'use strict';

var cwd = process.cwd();

module.exports = {
  stylesPath: [
    'assets/finance-we/sass/main-finance-we.scss',
    'assets/finance/sass/main-finance.scss'
  ],

  template: {
    financeWe: {
      files: 'assets/finance-we/views/**/*.tpl.html',
      fileName: 'template-finance-we.js',
      moduleName: 'assets.template.finance.we'
    },
    finance: {
      files: 'assets/finance/views/**/*.tpl.html',
      fileName: 'template-finance.js',
      moduleName: 'assets.template.finance'
    }
  },

  bundle: {
    financeWe: {
      type: 'finance-we',
      entry: 'assets/finance-we/js/main-finance-we.js',
      weClient: true
    },
    finance: {
      type: 'finance',
      entry: 'assets/finance/js/main-finance.js',
      weClient: false
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
      financeWe: 'assets/finance-we/views/**/*.tpl.html',
      finance: 'assets/finance/views/**/*.tpl.html'
    },
    js: {
      financeWe: ['assets/finance-we/**/*.js', '!app/finance-we/js/template-finance-we.js'],
      finance: ['assets/finance/**/*.js', '!app/finance/js/template-finance.js']
    }
  }
};
