
'use strict';

// 定义gulp插件
var gulp = require('gulp'),
  rename = require('gulp-rename'),
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

// 本地服务
var connect = require('gulp-connect');




// 入口 （如需并发可[]中加入）
gulp.task('default', function() {
  return runSequence('clean', 'copy', 'bundle', 'connect','serve','jsConvert','babelWatch','watch','open');
});


// 清理temp目录
gulp.task('clean', function(cb) {
  return rimraf(tmp, cb);
});

// 拷贝源文件至临时目录
gulp.task('copy', function() {
  gulp.src(src + '/**/img/*').pipe(flatten()).pipe(gulp.dest(tmp + '/img'));
  gulp.src(src + '/**/view/*').pipe(flatten()).pipe(gulp.dest(tmp + '/view'));
  gulp.src(src + '/**/fonts/*').pipe(flatten()).pipe(gulp.dest(tmp + '/fonts'));
  gulp.src(src + '/**/css/*').pipe(flatten()).pipe(gulp.dest(tmp + '/css'));
  gulp.src(src + '/**/js/*').pipe(flatten()).pipe(gulp.dest(tmp + '/js')); // 此处只会拷贝js目录下的文件，不会递归拷贝子文件夹。
});

gulp.task('bundle',function(){});

gulp.task('serve',function(){});


//使用connect启动一个Web服务器
gulp.task('connect', function () {
  connect.server({
    root: process.cwd(),
    livereload: true,
    port: 8081
  });
});


//创建watch任务,其监测的文件改动之后，去调用一个Gulp的Task（即本文件的reload）
gulp.task('watch', function () {
  gulp.watch(['./src/js/*.js'], ['jsReload']);
  gulp.watch(['./src/view/*.html'], ['htmlReload']);
});

gulp.task('jsReload', function() {
  return gulp.src('src/js/*.js')
    .pipe(gulp.dest(tmp + '/js'))
    .pipe(connect.reload());
});

gulp.task('htmlReload', function() {
  return gulp.src('src/view/*.html')
    .pipe(gulp.dest(tmp + '/view'))
    .pipe(connect.reload());
});


// 将nodeJS语法转换为javsscript语法，并将转换后的资源拷贝到tmp目录
gulp.task('jsConvert', function() {
  return browserify(src+'/js/main.js')
    .transform(babelify)
    .bundle()
    .pipe(source('main.js'))
    .pipe(rename('ng-simditor.js'))
    .pipe(gulp.dest(tmp+'/js'));
});

gulp.task('babelWatch', function() {
  gulp.watch([src+'/js/**/*.js'], ['jsConvert']);
});


// 浏览器打开
gulp.task('open', function() {
  return opn('http://localhost:8081/tmp');
});


