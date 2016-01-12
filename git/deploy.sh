!/bin/bash

WS=$(pwd)
cd /root/tako/gotako
echo 'pull latest code from dev branch'
git reset --hard HEAD
git pull
echo 'update go 3rd libs'
rm -rf /root/golib/src/github.com/yaosxi
sh -x ./golib
echo 'build tako web service'
go install -ldflags "-s -w" github.com/yaosxi/mgox
go install -ldflags "-s -w" takows
echo 'deploy tako web service'
cp bin/takows /tako/takows_rc
service takows restart
echo 'build and deploy web client'
cd /root/tako/client/web
grunt build
cd $WS