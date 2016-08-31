#!/bin/sh
cd `dirname $0`
echo `basename $0` is in `pwd`
cd `pwd`

username=`whoami`
pname="com.test.app.portal-0.0.1-SNAPSHOT.war"
pids=`ps -fu $username | grep -w $pname | grep -w -v ps | grep -v ssh |grep -v -w grep |grep -v -w vi|grep -v -w ls|awk '{print $2}'`

echo "stopping xg_push_portal [jar]..."
for pid in $pids
do
    kill $pid
    echo "stop process: " $pid
    sleep 1
    cn=`ps -p $pid |wc -l`
    if [ $cn -gt 1 ]; then
        kill -9 $pid
    fi
done




