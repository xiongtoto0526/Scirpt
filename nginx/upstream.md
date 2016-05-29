# reference
http://www.jbxue.com/article/26828.html


# document

nginx中upstream的几种方式：

1、轮询(weight=1)
默认选项，当weight不指定时，各服务器weight相同，
每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器down掉，能自动剔除。
 

upstream bakend {
server 192.168.1.10;
server 192.168.1.11;
}
2、weight
指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况。
如果后端服务器down掉，能自动剔除。
比如以下配置，则1.11服务器的访问量为1.10服务器的两倍。
 

upstream bakend {
server 192.168.1.10 weight=1;
server 192.168.1.11 weight=2;
}
3、ip_hash
每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session不能跨服务器的问题。
如果后端服务器down掉，要手工down掉。（www.jbxue.com 整理）
 

upstream resinserver{
ip_hash;
server 192.168.1.10:8080;
server 192.168.1.11:8080;
}
4、fair（第三方插件）
按后端服务器的响应时间来分配请求，响应时间短的优先分配。
 

upstream resinserver{
server 192.168.1.10:8080;
server 192.168.1.11:8080;
fair;
}
5、url_hash（第三方插件）
按访问url的hash结果来分配请求，使每个url定向到同一个后端服务器，后端服务器为缓存服务器时比较有效。
在upstream中加入hash语句，hash_method是使用的hash算法。
 

upstream resinserver{
server 192.168.1.10:8080;
server 192.168.1.11:8080;
hash $request_uri;
hash_method crc32;
}
 
设备的状态有:
1、down 表示单前的server暂时不参与负载
2、weight 权重,默认为1。 weight越大，负载的权重就越大。
3、max_fails 允许请求失败的次数默认为1。当超过最大次数时，返回proxy_next_upstream 模块定义的错误
4、fail_timeout max_fails次失败后，暂停的时间。
5backup 备用服务器, 其它所有的非backup机器down或者忙的时候，请求backup机器。所以这台机器压力会最轻。-

介绍了这么多，下面来看一个负载均衡实例：
 

upstream tel_img_stream {
-#ip_hash;
server 192.168.11.68:20201;
server 192.168.11.69:20201 weight=100 down;
server 192.168.11.70:20201 weight=100;
server 192.168.11.71:20201 weight=100 backup;
server 192.168.11.72:20201 weight=100 max_fails=3 fail_timeout=30s;
}
 
--- 说明:
1)、down 表示当前的server暂时不参与负载
2)、weight 默认为1.weight越大，负载的权重就越大。
3)、backup： 其它所有的非backup机器down或者忙的时候，请求backup机器。所以这台机器压力会最轻。
4)、上例中192.168.11.72:20201 设置最大失败次数为 3，也就是最多进行 3 次尝试，且超时时间为 30秒。max_fails 的默认值为 1，fail_timeout 的默认值是 10s。
注意，当upstream中只有一个 server 时，max_fails 和 fail_timeout 参数可能不会起作用。
weight\backup 不能和 ip_hash 关键字一起使用。

最后在需要使用负载均衡的server中增加 proxy_pass http://tel_img_stream/;
获取访问head信息：
 

location ~* ^/tel_img/(.*)$
{
proxy_pass http://tel_img_stream;
proxy_set_header Host $host;
proxy_set_header X-Forwarded-For $remote_addr;
}
 
location 对URL进行匹配，可以进行重定向或者进行新的代理负载均衡。