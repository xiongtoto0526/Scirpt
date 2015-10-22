本目录下的readme文件，如果出现换行问题，请用ue或notepad打开。


功能说明：
---------------------------
将本目录下所有sdk渠道文件夹下的资源压缩成zip包，并拷贝至01output目录。
以aisi渠道为例，文件目录为：

ios_aisi_1.0.zip
readme.md
res
run_bak.rb
run.rb
run.yaml
utils.rb

脚本运行时，首先将ios_aisi_1.0.zip删除，然后将剩下的文件打成一个新的zip文件ios_aisi_1.0.zip,最后将该zip文件拷贝到01output目录。
其他渠道类似。



常见场景：
---------------------------
新增一个渠道，直接修改zip.conf,
在原conf文件的lib配置最后，增加一行：lib=新渠道的lib文件名称
在原conf文件的channel_id配置最后，增加一行：channel_id=新渠道的文件夹名称

使用说明：
1. 配置zip.conf,配置方法如下：

// 这里是配置源西瓜版本
xgVersion=1.0


// 这里是配置渠道的库文件名，新增时请在本块的最后追加
lib=libsdk-91.a
lib=libsdk-aisi.a
lib=libsdk-hm.a
...
...


// 这里是需要修改的渠道名。（名称规范: ../channels_zip/渠道文件夹名称），新增时请在本块的最后追加
channel_id=91
channel_id=aisi
...
...


脚本执行:
---------------------------
sh zip.sh
