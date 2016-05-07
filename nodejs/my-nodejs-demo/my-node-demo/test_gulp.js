'use strict';

var gulp = require('gulp');
var flatten = require('gulp-flatten');
var nodemon = require('gulp-nodemon');
var path = require('path');
var sourcemaps = require('gulp-sourcemaps');
var sass = require('gulp-sass');
var postcss = require('gulp-postcss');
var $ = require('gulp-load-plugins')();
var autoprefixer = require('autoprefixer-core');
var ngAnnotate = require('gulp-ng-annotate');
var source = require('vinyl-source-stream');
var browserify = require('browserify');
var streamify = require('gulp-streamify');
var regenerator = require('gulp-regenerator');
var minifyHTML = require('gulp-minify-html');
var ngHtml2Js = require('gulp-ng-html2js');
var rimraf = require('rimraf');
var runSequence = require('run-sequence');
var opn = require('opn');
var devip = require('dev-ip');
var livereload = require('gulp-livereload');
var argv = require('minimist')(process.argv.slice(2));
var rucksack = require('gulp-rucksack');
var jetpack = require('fs-jetpack');
// var config = require('../config.json');
// var configPath = path.join(process.cwd(), 'config.json');

// var baseUrl = argv.baseUrl;
// var port = argv.port;

// var taskConfig = require('./task-config');

// var assets = path.join(process.cwd(), 'assets');
// var tmp = path.join(process.cwd(), 'tmp');

// var stylesPath = taskConfig.stylesPath;

console.log('this is a test for the gulp default task')
