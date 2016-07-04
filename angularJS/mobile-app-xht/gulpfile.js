
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

// html检查 https://github.com/bezoerb/gulp-htmlhint  
var htmlhint = require("gulp-htmlhint");

// js检查 https://www.npmjs.com/package/gulp-eslint
const eslint = require('gulp-eslint');

// 压缩html https://github.com/jonschlinkert/gulp-htmlmin
var htmlmin = require('gulp-htmlmin');

// 压缩css https://github.com/scniro/gulp-clean-css
var cleanCSS = require('gulp-clean-css');


// 定义本地目录
var tmp = path.join(process.cwd(), 'tmp'),
    src = path.join(process.cwd(), 'src');

var myPort = 8151;

// see more: https://www.npmjs.com/package/mocer
var mocer = require('mocer');
var browserSync = require('browser-sync').create();

// 替换build-block块：https://www.npmjs.com/package/gulp-useref
var useref = require('gulp-useref');
 


// 入口 （如需并发可[]中加入）
gulp.task('default', function() {
  return runSequence('clean', 'copy', 'bundle','htmlCheck',['htmlMinify','cssMinify'],'jsCheck','browser-sync','watch','open');
});


// 清理temp目录
gulp.task('clean', function(cb) {
  return rimraf(tmp, cb);
});

// 拷贝源文件至临时目录
gulp.task('copy', function() {
});


gulp.task('bundle',function(){});

// 检查html
gulp.task('htmlCheck',function(){
  gulp.src("./src/view/*.html")
    .pipe(htmlhint('.htmlhintrc')).pipe(htmlhint.failReporter())// 控制台输出错误日志
})


gulp.task('htmlMinify', function() {
  return gulp.src('./src/view/*.html')
    .pipe(htmlmin({collapseWhitespace: true}))
    .pipe(gulp.dest('min/html'))
});

gulp.task('cssMinify', function() {
  return gulp.src('./src/css/*.css')
    .pipe(cleanCSS({compatibility: 'ie8'}))
    .pipe(gulp.dest('min/css'));
});


gulp.task('replaceBuildBlock', function () {
    return gulp.src('./src/view/*.html')
        .pipe(useref())
        .pipe(gulp.dest('xhtBuildBlockTest'));
});
// 检查js
gulp.task('jsCheck', () => {
    // ESLint ignores files with "node_modules" paths. 
    // So, it's best to have gulp ignore the directory as well. 
    // Also, Be sure to return the stream from the task; 
    // Otherwise, the task may end before the stream has finished. 
    return gulp.src(['./src/js/*.js','!node_modules/**'])
        // eslint() attaches the lint output to the "eslint" property 
        // of the file object so it can be used by other modules. 
        .pipe(eslint())
        // eslint.format() outputs the lint results to the console. 
        // Alternatively use eslint.formatEach() (see Docs). 
        .pipe(eslint.format())
        // To have the process exit with an error code (1) on 
        // lint error, return the stream and pipe to failAfterError last. 
        .pipe(eslint.failAfterError());
});

// Static server, http://localhost:myPort/users ，will return your users.GET.md file.
gulp.task('browser-sync', function() {
  browserSync.init({
    server: {
    baseDir: './',
    middleware: [
      mocer(src + '/mocks')
    ]},
    port: myPort,
    open: false,  // to prevent conficts with gulp-opn,see open options: https://www.browsersync.io/docs/options 
  });
});



//创建watch任务,其监测的文件改动之后，去调用一个Gulp的Task（即本文件的reload）
gulp.task('watch', function () {
  gulp.watch(['./src/js/**/*.js'],function(){console.log('modify....');}); // 监控src下面所有JS文件
  gulp.watch(['./src/view/*.html']),function(){};// 监控src下面所有html文件
});


//创建watch任务,其监测的文件改动之后，去调用一个Gulp的Task（即本文件的reload）
gulp.task('watch', function () {
  gulp.watch(['./src/js/**/*.js'], ['jsCheck','jsReload']); // 监控src下面所有JS文件
  gulp.watch(['./src/view/*.html'], ['htmlCheck','htmlReload']);// 监控src下面所有html文件
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


