#!/bin/bash

function checkFileTime(){
    updateTime_current=$(stat -f "%m%t%Sm %N" $checkFile | cut -f1)
    updateTime_common=$(stat -f "%m%t%Sm %N" $CommonFile | cut -f1)

    if [[ updateTime_common -gt updateTime_current ]]; then
        echo "file $checkFile is older then common folder..."
        echo "press 'y' to force continue,press 'n' to exit..."
        read ANS
        case $ANS in
        n|N|no|No)
        echo -n "|Please update file $checkFile first. will return... "
        exit 0
    ;;
    esac
else
    echo "File check is passed!"
fi

}

function checkGitRep(){
if [[ -n $(git status --porcelain) ]]; then
    echo "=git repo is dirty!"
    echo "=press 'y' to continue,press 'n' to exit..."

    read ANS
    case $ANS in
    n|N|no|No)
    echo -n "|use  --git status-- and review you git repo . will return... "
    exit 0
;;
esac
fi

}

# 主方法=========================
main()
{
# 检查 commonRes目录下的 libXgsdkData.a 和 libXgCommon.a 文件是否为最新
checkFile='./res/lib/libxgCommon.a'
CommonFile='../../../commonRes/library/libxgCommon.a'
checkFileTime

checkFile='./res/lib/libXgsdkData.a'
CommonFile='../../../commonRes/library/libXgsdkData.a'
checkFileTime

# 检查git仓库是否干净
checkGitRep

# 检查output目录
if test ! -d ./output ;then
    echo "mkdir"
    mkdir ./output
fi

# 初始化配置变量
echo "== > load config"
for LINE in `cat package.conf`
do
    echo $LINE
    key=`echo $LINE | cut -d"=" -f1`
    if test $key == channel_version ; then
        channel_version=`echo $LINE | cut -d"=" -f2`
        continue
    fi

    if test $key == channel_id ; then
        channel_id=`echo $LINE | cut -d"=" -f2`
        continue
    fi

    if test $key == xgsdk_version ; then
        xgsdk_version=`echo $LINE | cut -d"=" -f2`
        continue;
    fi
done

echo "== > gen md5:"
md5_value=`md5 package.sh|cut -d ' ' -f4`

echo "== > gen zip:"
zip -r ./output/${channel_id}_${xgsdk_version}_${channel_version}_$(date +%Y%m%d_%H%M%S).zip res run.rb run.yaml utils.rb

echo "== > gen sql:"
echo INSERT INTO cfg_sdk_channel_version VALUES '('$channel_id, $channel_version, v1, NULL, $(date +%Y%m%d), NULL, date $(date "+%Y-%m-%d %H:%M:%S"), NULL, $md5_value, ACTIVE')' > ./output/01_add_new_version.sql
echo "== > done."
}

main
