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

