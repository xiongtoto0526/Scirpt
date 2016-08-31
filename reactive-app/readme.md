# 安装
1. 安装react-native 环境，参考： https://facebook.github.io/react-native/docs/getting-started.html#content
  -- brew install node （使用 brew upgrde node, 安装最新版本 ）
  -- brew install watchman
  -- npm install -g react-native-cli (尽量不使用cnpm，因为里面很多依赖包都是通过npm下载的)

2.安装ignite环境
  npm install -g react-native-ignite

3. 生成app框架
  ignite new MyApplication
  
4. 测试
  react-native run-ios

# 安装问题汇总：
 （1） 问题： node -v 显示安装成功，但是npm -v 却显示：npm is not a command.
  解决办法：sudo chown -R $USER /usr/local， 然后brew postinstall node
  
  (2) 问题：重新安装node，link时报错 “/usr/local/share/doc/node is not writable”
  解决办法：先 cd到 “/usr/local/share/doc/“，再执行 “brew link node”
  
  (3) 问题：node无法更新到最新
  解决办法：
  先用brew安装旧版本node:
		brew install node（注意：这里安装下来的居然是v0.12.5,所以必须升级node版本。）
  然后用brew升级node: 
        brew update ，
        brew upgrade node，
        npm install -g npm
  (4) 问题：执行react-native 出错：Command `run-ios` unrecognized. Did you mean to run this inside a react-native project?
  解决办法：由于老工程里面的react-native不是最新版本，需要重新安装npm install --save react-native@latest






