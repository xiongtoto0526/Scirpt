
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

// 本地服务
var connect = require('gulp-connect'); // 暂时不用gulp-connect,mock数据有问题，使用下面的 gulp-webserver 代替。
var webserver = require('gulp-webserver');  

var myPort = 8151;
var mocer = require('mocer');


// 入口 （如需并发可[]中加入）
gulp.task('default', function() {
  return runSequence('clean', 'copy', 'bundle', 'connect','server','jsConvert','watch','open');
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


//使用connect启动一个Web服务器
gulp.task('connect', function () {
  // connect.server({
  //   root: process.cwd(),// 将整个工程目录都监控起来，以便可以加载到插件 power_components
  //   livereload: true,
  //   port: myPort
  // });
});

gulp.task('server', function () {  
  return gulp.src(process.cwd())
    .pipe(webserver({
            livereload: true,
            directoryListing: {
                enable:true
                // path: 'market'
            },
            port: myPort,
            // 这里是关键,直接mock本地数据
            middleware: function(req, res, next) {
                var urlObj = url.parse(req.url, true),
                    method = req.method;
                switch (urlObj.pathname) {
                    case '/api/orders':
                        var data = {
                            "status": 0,
                            "msg": "it is ok !", 
                            "data": [{'x':'1','h':'2','t':'3'}]
                        };
                        res.setHeader('Content-Type', 'application/json');
                        res.end(JSON.stringify(data));
                        return;
                    case '/api/goods':
                        // ...
                        return;
                    case '/api/images':
                        // ...
                        return;
                    default:
                        ;
                }
                next();
            }
        }));
});

//创建watch任务,其监测的文件改动之后，去调用一个Gulp的Task（即本文件的reload）
gulp.task('watch', function () {
  gulp.watch(['./src/js/**/*.js'], ['jsReload']); // 监控src下面所有JS文件
  gulp.watch(['./src/view/*.html'], ['htmlReload']);// 监控src下面所有html文件
});

gulp.task('jsReload',['jsConvert'],function() {
  return gulp.src(tmp+'/js')
    .pipe(connect.reload());
});

gulp.task('htmlReload', function() {
  return gulp.src('src/view/*.html')
    .pipe(gulp.dest(tmp + '/view'))
    .pipe(connect.reload());
});



// 语法转换： 将nodeJS转换为javsscript，并将转换后的资源拷贝到tmp目录
gulp.task('jsConvert', function() {
  return browserify(src+'/js/app.js')
    .transform(babelify)
    .bundle()
    .pipe(source('app.js'))
    .pipe(gulp.dest(tmp+'/js'));
});



// 浏览器打开
gulp.task('open', function() {
  return opn('http://localhost:'+myPort+'/tmp/view');
});


