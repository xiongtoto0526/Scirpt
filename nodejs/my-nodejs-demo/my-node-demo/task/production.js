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

gulp.task('deploy', function() {
  return runSequence('production');
});

gulp.task('production', function() {
  return runSequence(['clean:pub', 'clean:views'], 'copy:production', 'useref');
});

gulp.task('clean:pub', function(cb) {
  return rimraf(pub, cb);
});

gulp.task('clean:views', function(cb) {
  return rimraf(viewsDist, cb);
});

gulp.task('copy:production', function() {
  gulp.src(assets + '/**/img/*').pipe($.flatten()).pipe(gulp.dest(pub + '/img'));
  gulp.src(assets + '/**/fonts/*').pipe($.flatten()).pipe(gulp.dest(pub + '/fonts'));
  gulp.src(assets + '/**/file/*').pipe($.flatten()).pipe(gulp.dest(pub + '/file'));
});

gulp.task('useref', function() {
  return gulp.src(viewsSrc + '/**/*.ejs')
    .pipe($.useref({
      base: 'pub',
      searchPath: ['pub', 'tmp', '.']
    }))
    // .pipe($.if('*.js', $.uglify()))
    .pipe($.if('*.css', $.minifyCss({ processImport: false })))
    .pipe(gulp.dest(viewsDist));
});

gulp.task('rev', function() {
  return gulp.src(viewsDist + '/**/*.ejs')
    .pipe($.revEasy({ base: pub, fileTypes: ['js', 'css'] }))
    .pipe(gulp.dest(viewsDist));
});
