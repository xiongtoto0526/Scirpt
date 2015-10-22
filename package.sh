#!/bin/bash
if [ ! -d ./output ];then
	echo "mkdir"
    mkdir ./output
fi

# 初始化配置变量
echo "==>load config"
for LINE in `cat package.conf`
do
	echo $LINE
    key=`echo $LINE | cut -d"=" -f1`
    if [ $key == channel_version ]; then
     channel_version=`echo $LINE | cut -d"=" -f2` 
     continue
    fi

    if [ $key == channel_id ]; then
     channel_id=`echo $LINE | cut -d"=" -f2` 
     continue
    fi

    if [ $key == xgsdk_version ]; then
     xgsdk_version=`echo $LINE | cut -d"=" -f2` 
     continue;
    fi
done

echo "==>gen md5:"
md5_value=`md5 package.sh|cut -d ' ' -f4`

echo "==>gen zip:"
zip -r ./output/${channel_id}_${xgsdk_version}_${channel_version}_$(date +%Y%m%d).zip res run.rb run.yaml utils.rb

echo "==>gen sql:"
echo INSERT INTO cfg_sdk_channel_version VALUES '('$channel_id, $channel_version, v1, NULL, $(date +%Y%m%d), NULL, 2015-8-3 10:52:46, NULL, $md5_value, ACTIVE')'>./output/01_add_new_version.sql
echo "==>done."