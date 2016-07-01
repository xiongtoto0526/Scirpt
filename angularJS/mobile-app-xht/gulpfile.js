
'use strict';

// 定义gulp插件
var gulp = require('gulp'),
  rename = require('gulp-rename'),
  url = require('url'),
  source = require('vinyl-source-stream'),
  browserify = require('browserify'),
  babelify = require('babelify'),
  path = require('path'), // path为原生的，无需install
  rimraf = require('rimraf'),// 清除
  runSequence = require('run-sequence'),
  opn = require('opn'),
  flatten = require('gulp-flatten'); // 扁平化目录
  



// 定义本地目录
var tmp = path.join(process.cwd(), 'tmp'),
    src = path.join(process.cwd(), 'src');

var myPort = 8151;
var mocer = require('mocer');
var browserSync = require('browser-sync').create();




// 入口 （如需并发可[]中加入）
gulp.task('default', function() {
  return runSequence('clean', 'copy', 'bundle','browser-sync','watch','open');
});


// 清理temp目录
gulp.task('clean', function(cb) {
  return rimraf(tmp, cb);
});

// 拷贝源文件至临时目录
gulp.task('copy', function() {
});


gulp.task('bundle',function(){});


// Static server, http://localhost:myPort/users ，will return your users.GET.md file.
gulp.task('browser-sync', function() {
  browserSync.init({
    server: {
    baseDir: './',
    middleware: [
      mocer(src + '/mocks')
    ]},
    port: myPort
  });
});



//创建watch任务,其监测的文件改动之后，去调用一个Gulp的Task（即本文件的reload）
gulp.task('watch', function () {
  gulp.watch(['./src/js/**/*.js'],function(){console.log('modify....');}); // 监控src下面所有JS文件
  gulp.watch(['./src/view/*.html']),function(){};// 监控src下面所有html文件
});


//创建watch任务,其监测的文件改动之后，去调用一个Gulp的Task（即本文件的reload）
gulp.task('watch', function () {
  gulp.watch(['./src/js/**/*.js'], ['jsReload']); // 监控src下面所有JS文件
  gulp.watch(['./src/view/*.html'], ['htmlReload']);// 监控src下面所有html文件
});

gulp.task('jsReload',function() {
  return gulp.src('./src/js/**/*.js')
    .pipe(browserSync.stream());
});

gulp.task('htmlReload', function() {
  return gulp.src('src/view/*.html')
    .pipe(browserSync.stream());
});


// 浏览器打开
gulp.task('open', function() {
  return opn('http://localhost:'+myPort+'/src/view');
});


