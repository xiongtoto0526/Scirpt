#!/bin/bash
echo 'pkg begin...'
LANG="zh_CN.UTF-8"
pwd

target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`

cd $target
pwd

ruby ./run.rb $target
# touch step1_ok.txt
echo 'pkg end...'
