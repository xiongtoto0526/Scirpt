#!/bin/bash
echo "zip begin..."
echo -n "|Warnig:"
echo -n "|Are you sure all the files in  channels_zip/* (such as libxgcommon.a, run.rb, ios_xx_1.0.zip )is new ? "
echo -n "|If not, you will break the sdk_zip file in svn, this is forbidden!!"
echo -n "|Enter your answer with: Y/N "
read ANS
case $ANS in    
# y|Y|yes|Yes) 
#         rm a.txt
#         ;;
n|N|no|No) 
   echo -n "|Please do the  --svn update-- in channels_zip first, then replace your new file and rerun this script, will return... "
        exit 0
        ;;
esac
# 变量定义
destdir=./
xgVersion=""
i=0
j=0

lib_List=""
channel_id_list=""
outputdir="01output/"


# 初始化配置变量
for LINE in `cat zip.conf`
do
	echo $LINE
    key=`echo $LINE | cut -d"=" -f1`
    if [ $key == lib ]; then
     lib_List[j]=`echo $LINE | cut -d"=" -f2`
     j=$j+1
    fi

    if [ $key == channel_id ]; then
     channel_id_list[i]=`echo $LINE | cut -d"=" -f2` 
     i=$i+1
    fi

    if [ $key == xgVersion ]; then
     xgVersion=`echo $LINE | cut -d"=" -f2` 
    fi
done


# 执行zip
for index in ${!lib_List[@]}
do
echo "zip begin..."
zipDir=${destdir}${channel_id_list[$index]}

cd ${zipDir}
zipFileName="ios_"${channel_id_list[$index]}"_1.0.zip"
rm -rf ${zipFileName}
zip -r ${zipFileName} *
echo "zip dir is: ./"${outputdir}${zipFileName}
cp ${zipFileName} "../"${outputdir}${zipFileName}
cd ..
done

# 打开output目录
echo "open :"${outputdir}
open ${outputdir}
echo "copy done..."

