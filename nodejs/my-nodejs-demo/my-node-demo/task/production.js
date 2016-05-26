'use strict';

var gulp = require('gulp');
var $ = require('gulp-load-plugins')();

var path = require('path');
var rimraf = require('rimraf');
var runSequence = require('run-sequence');

var assets = path.join(process.cwd(), 'assets');
var pub = path.join(process.cwd(), 'pub');
var viewsSrc = path.join(process.cwd(), 'app', 'views', 'src');
var viewsDist = path.join(process.cwd(), 'app', 'views', 'dist');


// 注意：deploy task本身依赖 development.js的资源处理,需要先运行 gulp（如：babel，browserify）
gulp.task('deploy', function() {
  return runSequence('production');
});

gulp.task('production', function() {
  return runSequence(['clean:pub', 'clean:views'], 'copy:production', 'useref');
});

// 清除pub目录
gulp.task('clean:pub', function(cb) {
  return rimraf(pub, cb);
});

// 清除app/view/dist目录
gulp.task('clean:views', function(cb) {
  return rimraf(viewsDist, cb);
});

// 拷贝asset下面的img,font目录到pub目录下
gulp.task('copy:production', function() {
  gulp.src(assets + '/**/img/*').pipe($.flatten()).pipe(gulp.dest(pub + '/img'));
  gulp.src(assets + '/**/fonts/*').pipe($.flatten()).pipe(gulp.dest(pub + '/fonts'));
  gulp.src(assets + '/**/file/*').pipe($.flatten()).pipe(gulp.dest(pub + '/file'));
});

// 将dist目录中的ejs文件里包含的 “build” 块，压缩为单一文件引用。并将压缩后的文件拷贝到pub目录下。
gulp.task('useref', function() {
  return gulp.src(viewsSrc + '/**/*.ejs')
    .pipe($.useref({
      base: 'pub',   // 压缩文件输出的目录
      searchPath: ['pub', 'tmp', '.'] // 搜索ejs文件的目录
    }))  // 压缩后的文件拷贝到pub目录下
    // .pipe($.if('*.js', $.uglify()))
    .pipe($.if('*.css', $.minifyCss({ processImport: false }))) // 将输出的css文件压缩
    .pipe(gulp.dest(viewsDist)); // build块 压缩为单一文件引用
}
);

// 生成版本号
gulp.task('rev', function() {
  return gulp.src(viewsDist + '/**/*.ejs')
    .pipe($.revEasy({ base: pub, fileTypes: ['js', 'css'] }))
    .pipe(gulp.dest(viewsDist));
});
