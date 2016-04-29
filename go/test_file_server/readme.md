reference:
http://github.com/widuu/staticserver


1.in terminal , use: sh install
  will gen bin,pkg dir
2.cd bin, use ./myPackage
  will run a server

目录结构：
goWorkSpace  // (goWorkSpace为GOPATH目录)
  -- bin  // golang编译可执行文件存放路径，可自动生成。
  -- pkg  // golang编译的.a中间文件存放路径，可自动生成。
  -- src  // 源码路径。按照golang默认约定，go run，go install等命令的当前工作路径（即在此路径下执行上述命令）。
  
  标准结构参考：
  http://blog.csdn.net/Alsmile/article/details/48290223
  


