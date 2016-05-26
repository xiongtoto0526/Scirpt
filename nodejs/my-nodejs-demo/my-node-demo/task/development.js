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
var config = require('../config.json');
var configPath = path.join(process.cwd(), 'config.json');

var baseUrl = argv.baseUrl;
var port = argv.port;

var taskConfig = require('./task-config');

var assets = path.join(process.cwd(), 'assets');
var tmp = path.join(process.cwd(), 'tmp');

var stylesPath = taskConfig.stylesPath;

// 入口
gulp.task('default', function() {
  return runSequence('development');
});

gulp.task('development', function() {
  return runSequence('clean', ['copy', 'env:development', 'template', 'style', 'url'], 'bundle', 'serve', 'watch', 'opn');
});

// 清理temp目录
gulp.task('clean', function(cb) {
  return rimraf(tmp, cb);
});

// 拷贝源文件至临时目录
gulp.task('copy', function() {
  gulp.src(assets + '/**/img/*').pipe(flatten()).pipe(gulp.dest(tmp + '/img'));
  gulp.src(assets + '/**/fonts/*').pipe(flatten()).pipe(gulp.dest(tmp + '/fonts'));
  gulp.src(assets + '/**/file/*').pipe(flatten()).pipe(gulp.dest(tmp + '/file'));
  gulp.src(assets + '/**/js/*').pipe(flatten()).pipe(gulp.dest(tmp + '/js')); // 此处只会拷贝js目录下的文件，不会递归拷贝子文件夹。
});

// 设置环境变量
gulp.task('env:development', function() {
  process.env.NODE_ENV = 'development';
  process.env.PORT = port ? port : config.port;
});

// 压缩html,并将anularJs的模板文件生成js，放置到tmp/js目录下。
gulp.task('template', ['template:financeWe', 'template:finance']);
gulp.task('template:financeWe', () => template(taskConfig.template.financeWe));
gulp.task('template:finance', () => template(taskConfig.template.finance));

function template(app) {
  return gulp.src(app.files)
    .pipe(minifyHTML({ empty: true, spare: true, quotes: true }))
    .pipe(ngHtml2Js({ moduleName: app.moduleName, prefix: 'views/' }))
    .pipe($.concat(app.fileName))
    .pipe(gulp.dest(tmp + '/js'));
}


// 压缩css，并生成sourceMap文件，放置到tmp/css目录下。并实时监控该目录（livereload，配合下面的watch task）
gulp.task('style', function() {
  return gulp.src(stylesPath)
    .pipe(sourcemaps.init())
    .pipe(sass().on('error', sass.logError))
    .pipe(rucksack())
    .pipe(postcss([autoprefixer({ browsers: ['last 2 version'] })]))
    .pipe(sourcemaps.write('.'))
    .pipe(gulp.dest(tmp + '/css'))
    .pipe(livereload());
});

// 将命令行的baseUrl写入配置文件
gulp.task('url', function() {
  config.baseUrl = baseUrl ? baseUrl : 'http://' + devip()[0] + ':' + config.port;
  jetpack.write(configPath, config);
});

// 将打包好的模板文件js，babel化，并重命名拷贝到tmp/js目录， 并实时监控该目录（livereload，配合下面的watch task）
gulp.task('bundle', ['bundle:financeWe', 'bundle:finance']);
gulp.task('bundle:financeWe', ['template:financeWe'], () => bundle(taskConfig.bundle.financeWe));
gulp.task('bundle:finance', ['template:finance'], () => bundle(taskConfig.bundle.finance));


function bundle(app) {
  if (app.weClient) {
    return browserify(app.entry)
      .transform('babelify', { presets: 'es2015', compact: false })// es6 ==> es5
      .bundle()
      .pipe(source('main.js'))
      .pipe($.rename({ suffix: '-' + app.type, extname: '.js' })) // main.js ==> main-finance.js
      .pipe(gulp.dest(tmp + '/js'))
      .pipe(livereload());
  } else {
    return browserify(app.entry)
      .transform('babelify', { presets: 'es2015', compact: false })
      .bundle()
      .pipe(source('main.js'))
      .pipe(ngAnnotate({ add: true })) // ngAnnotate, 将ngInjest的标签注入依赖
      .pipe(streamify(regenerator({ includeRuntime: true })))
      .pipe($.rename({ suffix: '-' + app.type, extname: '.js' }))
      .pipe(gulp.dest(tmp + '/js'))
      .pipe(livereload());
  }
}

// 启node服务
gulp.task('serve', function() {
  return nodemon({
    script: './bin/www',
    ext: 'js ejs',
    watch: ['app/views/', 'app/routes/', 'app/app.js', '/bin/'],
    ignore: ['./pub/**/*']
  }).on('restart', function() {
    setTimeout(() => {
      livereload.reload();
    }, 1000);
  });
});

// 监听资源文件，如有变化，则重启
gulp.task('watch', function() {
  livereload.listen();

  gulp.watch(taskConfig.paths.sass, ['style']);
  gulp.watch([taskConfig.paths.js.financeWe, taskConfig.paths.tpl.financeWe], ['bundle:financeWe']);
});

// 浏览器打开
gulp.task('opn', function() {
  // return opn('http://' + devip()[0] + ':' + process.env.PORT+'/testxht');
  return opn('http://' + devip()[0] + ':' + process.env.PORT+'/finance');
});
