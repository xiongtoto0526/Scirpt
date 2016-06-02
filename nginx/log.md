# log config

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  logs/access.log  main;
    # location is ==> /usr/local/Cellar/nginx/1.8.0/logs
    
# show log
10.20.72.104 - - [30/May/2016:11:09:52 +0800] "GET /apis/auth/user/roles HTTP/1.1" 400 0 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36" "-"

- $remote_addr: 10.20.72.104
- $remote_user: -
- [$time_local]:[30/May/2016:11:09:52 +0800]
- $request: GET /apis/auth/user/roles HTTP/1.1
- $status: 400
- $body_bytes_sent：0
- $http_referer：-
- $http_user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36"
- $http_x_forwarded_for: -