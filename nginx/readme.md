

nginx 手动安装：http://stevendu.iteye.com/blog/1535466
nginx 自动安装：brew install nginx
安装日志：
Downloading https://homebrew.bintray.com/bottles/pcre-8.38.yosemite.bottle.tar.gz
######################################################################## 100.0%
...
...
...
==> Installing nginx
==> Downloading https://homebrew.bintray.com/bottles/nginx-1.8.0.yosemite.bottle.1.tar.gz
##############################                                            42.5%
curl: (56) SSLRead() return error -9806
Error: Failed to download resource "nginx"
Download failed: https://homebrew.bintray.com/bottles/nginx-1.8.0.yosemite.bottle.1.tar.gz
Warning: Bottle installation failed: building from source.
==> Downloading http://nginx.org/download/nginx-1.8.0.tar.gz
######################################################################## 100.0%
==> ./configure --prefix=/usr/local/Cellar/nginx/1.8.0 --with-http_ssl_module --with-pcre --with-ip
==> make install
==> Caveats
Docroot is: /usr/local/var/www

The default port has been set in /usr/local/etc/nginx/nginx.conf to 8080 so that
nginx can run without sudo.

nginx will load all files in /usr/local/etc/nginx/servers/.

To have launchd start nginx at login:
  ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents
Then to load nginx now:
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
Or, if you don't want/need launchctl, you can just run:
  nginx


Open file /usr/local/etc/nginx/nginx.conf, then add snip below to enable local acess:
-------
      server {
        listen       9998;
        server_name  localhost;
        #charset koi8-r;

        

        location ~* ^/service/(.*) {
            proxy_pass http://0.0.0.0:9999/$1$is_args$args;
            add_header Access-Control-Allow-Origin *;
            proxy_set_header   Host             $host;
            proxy_set_header   X-Real-IP        $remote_addr;
            proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
            client_max_body_size 1024m;
        }

        location / {
            proxy_pass http://test.tako.im;
        }
------

restart nginx: nginx -s reload