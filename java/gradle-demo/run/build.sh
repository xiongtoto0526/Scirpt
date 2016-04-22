#!/bin/bash

appName="xht-app-0.0.1-SNAPSHOT"
cd ..

echo "==================== START BUILD ========================="
gradle build -x test
echo "==================== AFTER BUILD ========================="

cp ./build/libs/$appName.jar ./run/$appName.jar

cd ./run
username=`whoami`
pname=$appName
pids=`ps -fu $username | grep -w $pname | grep -w -v ps | grep -v ssh |grep -v -w grep |grep -v -w vi|grep -v -w ls|awk '{print $2}'`

echo "====================  KILL ALL SYSTEM PROCCESSES =========================="
echo "stopping all system [jar]..."
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

echo "====================  RESTART SYSTEM =========================="
echo "ready to start system in " `pwd`
nohup java -Xms1024m -Xmx2048m -XX:NewSize=1024m -XX:MaxNewSize=1024m -jar ./$appName.jar --server.port=39090 | tee -a ./start.log  &
sleep 1
echo "starting.....  please view ./start.log"