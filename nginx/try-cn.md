/*首先nignx的注释使用符号# */
#user  nobody;
/*运行服务的用户，其默认是被注释的，无需修改*/
worker_processes  1;
/*服务开启的进程数，值为数字，可配置与CPU内核数一致，若不确定，可以设置为auto*/

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;
/*日志文件配置*/
#pid        logs/nginx.pid;
/*pid文件是nginx的主进程号，nginx运行时可通过 pgrep nginx -l 查看，无需修改*/

events {
    worker_connections  1024;
  /*单个进程允许的最大连接数，总连接数为 work_processes * worker_connections，其可以设置不会超越服务器所支持的上限*/
}


http {
/*对http请求的配置，同比https*/
    include       mime.types;
 /* include 用户添加另外一文件，可以将某些相对独立且繁琐的配置独立成一文件，使用include来加载，可以到同目录下打开看下mime.types的文件内容，其罗列的文件扩展名的映射。*/
    default_type  application/octet-stream;
/*设置默认的mime-type*/
    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;
    /*设置客户端keep-alive链接的超时时间，设置低值，nginx的工作时间超长*/
    #gzip  on;
    /*设置 传输内容的gzip压缩，我下载的该版本本身没有显示很多，但该项的配置内容较多，通常有以下配置项
    gzip on;     #nignx采用gzip压缩发送，以减少传输数据量
    gzip_disable "msie6";     #对不支持的浏览器设置禁用，通常为IE6
    gzip_static on;          #压缩前先判断是否有压缩后，有则不再压缩
    gzip_proxied any;     #允许或禁止压缩流，any表示压缩所有
    gzip_min_length 1;     #     启用最小压缩，低于则不压缩。作用提高效率
    gzip_types text/plain text/css ..  #设置需要压缩的数据格式
    gzip_comp_level 4;     #设置压缩等级 1-9，数字越大，压缩越大时间越慢，折中4合适
    gzip_buffers     4 4k/8k     #用于指定存放被压缩响应的缓冲的数量和大小。
    gzip_http_version 1.1;
    */
    server {
        /*server是我们最常用使用的配置，每个服务对应一个server配置*/
        listen       8080;
        /*监听端口，win/linux默认是80端口，80是http的默认端口，443是https的默认端口，不过mac的80端口默认会被占用*/
        server_name  localhost;
        /*监听的域名，以这个默认配置，启动用http://localhost:8080 访问
        当服务支持多个域名访问时，可以通过设置多个server_name，代理不同的域名
        如在本地 hosts里添加域名  
        127.0.0.1 www.upopen.com
        修改 server_name www.upopen.com
        此时访问 www.upopen.com:8080即可访问此处设置的请求
        设置多个server，可以相同的listen port，以不同的server_name来区别访问
    */
        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }
/* location 用于匹配请求path，可使用正则，通常可以设置为后缀名匹配，路径匹配
     root 设置目录，html是nginx安装时默认的目录，实现项目中修改到项目目录
    index 设置访问首页 index.html / htm 也是nginx安装时的默认页
*/

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }