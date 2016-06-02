# CN:
http://blog.chinaunix.net/uid-15117916-id-2777222.html

# EN-offical
http://nginx.org/en/docs/http/ngx_http_core_module.html

# practice

$host
请求中的主机头字段，如果请求中的主机头不可用，则为服务器处理请求的服务器名称。

$is_args
如果$args设置，值为"?"，否则为""。

$args
这个变量等于请求行中的参数。

$1
location()中的参数,例：

^/images/([a-z]{2})/([a-z0-9]{5})/(.*)\.(png|jpg|gif)$   
---->http://xxxx.com/images/aa/abc01/test.gif  
<pre> 其中   
$1=([a-z]{2})      #$1=aa  
$2=([a-z0-9]{5})   #$2=abc01  
$3=(.*)            #$3=test  
$4=(png|jpg|gif)   #$4=gif  
  
上面的4个地段都是query 串中匹配的字符串  
</pre>




