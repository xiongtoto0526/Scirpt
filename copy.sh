#!/bin/bash
echo "copy begin..."
echo -n "|Warnig:"
echo -n "|Are you sure all the files in  commonfile/files is done --svn update--? "
echo -n "|If not, you will break the sdk_zip file in svn, this is forbidden!!"
echo -n "|Enter your answer with: Y/N "
read ANS
case $ANS in    
# y|Y|yes|Yes) 
#         rm a.txt
#         ;;
n|N|no|No) 
   echo -n "|Please do the  --svn update-- in commonfile/files first . will return... "
        exit 0
        ;;
esac

srcdir=""
destdir=""
head_file=""
run_file=""
com_lib=""
util_file=""
i=0

# 初始化配置变量
for LINE in `cat copy.conf`
do
	echo $LINE
    key=`echo $LINE | cut -d"=" -f1`
    if [ $key == srcdir ]; then
     srcdir=`echo $LINE | cut -d"=" -f2` 
    fi

    if [ $key == destdir ]; then
     destdir=`echo $LINE | cut -d"=" -f2` 
    fi

    if [ $key == head_file ]; then
     head_file=`echo $LINE | cut -d"=" -f2` 
    fi

    if [ $key == run_file ]; then
     run_file=`echo $LINE | cut -d"=" -f2` 
    fi

    if [ $key == com_lib ]; then
     com_lib=`echo $LINE | cut -d"=" -f2` 
    fi

    if [ $key == util_file ]; then
     util_file=`echo $LINE | cut -d"=" -f2` 
    fi

    if [ $key == channel_id ]; then
     channel_id_list[i]=`echo $LINE | cut -d"=" -f2` 
     i=$i+1
    fi

done

# 查看变量初始化结果
# echo $srcdir
# echo $destdir
# for index in ${!channel_id_list[@]}
# do
# echo ${channel_id_list[index]}
# done

# 执行文件拷贝
for index in ${!channel_id_list[@]}
do
# 拷贝header文件
srcFile=${srcdir}${head_file}
resDir=${channel_id_list[$index]}"/res/src/"
destFile=${destdir}${resDir}${head_file}
echo "1---begin"
echo $srcFile
echo $destFile
echo "1---end"
cp $srcFile $destFile

# 拷贝src文件
srcFile=${srcdir}${run_file}
channelDir=${channel_id_list[$index]}
destFile=${destdir}${channelDir}/${run_file}
echo "1---begin"
echo $srcFile
echo $destFile
echo "1---end"
cp $srcFile $destFile

# 拷贝util文件
srcFile=${srcdir}${util_file}
channelDir=${channel_id_list[$index]}
destFile=${destdir}${channelDir}/${util_file}
echo "1---begin"
echo $srcFile
echo $destFile
echo "1---end"
cp $srcFile $destFile

# 拷贝lib文件
srcFile=${srcdir}${com_lib}
channelDir=${channel_id_list[$index]}
destFile=${destdir}${channelDir}/res/lib/${com_lib}
echo "1---begin"
echo $srcFile
echo $destFile
echo "1---end"
cp $srcFile $destFile

done