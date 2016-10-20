# for install
$ wget http://download.redis.io/releases/redis-2.8.17.tar.gz
$ tar xzf redis-2.8.17.tar.gz
$ cd redis-2.8.17
$ make

# start server
$ cd src
$ ./redis-server

# for client connect
$ cd src
$ ./redis-cli
redis> set foo xht
OK
redis> get foo
"bar"


# done.

常用命令：
1.获取配置
config get *
2.更改配置
config set loglevel notice
3.连接远程客户端
$ redis-cli -h host -p port -a password
4.字符串: foo
5.map: fooMap
6.发布/订阅
client 1: subscribe xhtChat
client 2: publish xhtChat "hello everyone"
(client 1 将收到“hello everyone”的消息)
7.查看当前redis状态
info


