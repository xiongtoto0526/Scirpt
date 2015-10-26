#!/bin/bash

# help选项
if [ $# == 0 ] ; then 
echo "USAGE1: sh update.sh fileName1,fileName2,fileName3..." 
echo "USAGE2: sh update.sh -all" 
exit 1; 
fi 

# 获取待拷贝的文件列表
if test $1 == "-all"  ; then
	echo "will update all libraries..."
	# 扫描目录下的文件列表
	j=0
	for i in `ls -1`
	do
		if [[ $i =~ \update.sh$ ]]  ; then
			echo "是update.sh文件！"
		else
			file_list[j]=$i
			echo "target file is:"$i
			j=`expr $j + 1`
		fi
	done
else
	#由$@取到所有参数,并将参数存入a
	file_list=($@)                   
fi

# 打印待拷贝的文件列表
for i in ${file_list[@]};do         
		echo $i
done


# 提示先git pull
echo "copy begin..."
echo -n "|Warnig:"
echo -n "|Are you sure all the files is fresh? or make sure --git pull-- is executed before!"
echo -n "|Enter your answer with: Y/N "
read ANS
case $ANS in    
# y|Y|yes|Yes) 
#         rm a.txt
#         ;;
n|N|no|No) 
   echo -n "|Please do the  --git pull-- first . will return... "
        exit 0
        ;;
esac

echo "copy task begin..."

# 获取所有的渠道sdk目录
cd ../../xgsdk-client

j=0
for i in `ls -1`
do
 if [[ $i =~ \.zip$ ]]  ; then
 echo "是zip文件！"
 else
  folder_list[j]=$i
  # echo "dir name is:"$i
  j=`expr $j + 1`
fi
done


# 迭代子目录列表，并依次执行拷贝
for fileIndex in ${!file_list[@]}
do
	for index in ${!folder_list[@]}
	do
		tempFile=${file_list[$fileIndex]}
		srcFile=../commonRes/shell/$tempFile
		destFile=${folder_list[$index]}"/package/"$tempFile
		echo "cp command is: cp "$srcFile" "$destFile
		cp $srcFile $destFile
	done
done

echo "copy task end..."

