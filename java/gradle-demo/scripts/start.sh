#!/bin/bash

ws=`pwd`
echo $pname
cd ~financial/seasun-financial/run

java -Xms1024m -Xmx4096m -XX:NewSize=1024m -XX:MaxNewSize=2048m -jar ./$pname | tee -a ./start.log  &
sleep 1
echo "starting..... logging redirected to start.log"

cd "$ws"