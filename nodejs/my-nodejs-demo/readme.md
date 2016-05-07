reference:

# 创建node-demo工程
参考：node+express
http://www.myext.cn/javascript/a_7300.html

1.安装node
brew install node  

2.安装express + express-generator
sudo npm install -g express
sudo npm install -g express-generator

3.创建my-node-demo项目
express my-node-demo

4.启动
npm start

5.gulp启动
sudo npm install -g gulp	
- gulp 测试
sublime中，打开test_gulp，command +B 运行（前提是安装了sublime的nodeJS插件）。

## 目录详解
- app.js.bak : 旧的app.js，移动至 app文件夹。app.js的路径在www中可配。
  存放整个node服务的模板信息，入口参数，路由等信息。
- app文件夹。管理所有的应用的路由，模板，js。路径在app.js中可配。
- bin: 可执行文件夹，启动脚本
- bower_components: bower下载的js库。通过bower.json配置，bower install下载。
- bower_json:js库配置文件
- gulpfile.js: 前端构建工具gulp的配置文件。可简化启动。
- node_modules: node依赖的库。通过package.json配置，npm install下载。
- package.json:node库配置文件
- public:旧的public目录，移动至pub。存放静态资源文件。（js中尚未生效？？）
- routes:旧的路由目录。移动至app/routes。存放所有的路由.
- task: gulp构建的脚本文件。通过gulpfile.js指定该路径。默认执行"default"task.
- views:旧的模板目录。移动至app/views.存放所有html.(通过app.js配置所用的模板引擎)

