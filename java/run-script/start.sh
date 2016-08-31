#!/bin/sh
cd `dirname $0`
echo `basename $0` is in `pwd`
cd `pwd`

nohup java -Xms1024m -Xmx2048m -jar com.test.app.portal-0.0.1-SNAPSHOT.war &
sleep 1
echo "starting.....  please view ./nohup.out"

