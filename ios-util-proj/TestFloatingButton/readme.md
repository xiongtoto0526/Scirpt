# bundle工程说明

1. MyTako这个target是用于输出xib的bundle文件
2. bundle的配置参考的是：
   http://www.jianshu.com/p/a8c9e52c80de
3. bundle配置中的要点：
  - "Base SDK" 设置为 "IOS 8.3" (Xcode 6.3.2为例)
  若不配置为ios,则只能生产mac-os平台的bundle
  - 选择 scheme 导出时，必须选择真机导出（ios device）
  若选择的是模拟器，则只能导出一个plist文件，png和xib均无法导出
  

 