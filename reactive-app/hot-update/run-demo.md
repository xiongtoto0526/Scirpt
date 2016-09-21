#for demo run:
cd ./react-native-code-push-master/Example

1.npm install -g code-push-cli
2.npm install
3.set deploykey

- code-push app add ios_xhtTestPushApp
echo ==>
Successfully added the "ios_xhtTestPushApp" app, along with the following default deployments:
┌────────────┬───────────────────────────────────────┐
│ Name       │ Deployment Key                        │
├────────────┼───────────────────────────────────────┤
│ Production │ xQ1tV5t7Xa5l2ADsJWIkfp8S685l4ksvOXqog │
├────────────┼───────────────────────────────────────┤
│ Staging    │ p91ddlRFDExwOMHvmMw6XfV5gqKY4ksvOXqog │
└────────────┴───────────────────────────────────────┘
 modify info.plist

4.enable http
NSAppTransportSecurity - NSAllowsArbitraryLoads - YES

5.change build to release version ,otherwise will get bundle null error below:
[
React Native doesn't generate your app's JS bundle by default when deploying to the simulator. If you'd like to test CodePush using the simulator, you can do one of three things depending on your React Native version and/or preferred workflow:

1. Update your AppDelegate.m file to load the JS bundle from the packager instead of from CodePush. You can still test your CodePush update experience using this workflow (debug builds only).

2. Force the JS bundle to be generated in simulator builds by removing the if block that echoes "Skipping bundling for Simulator platform" in the "node_modules/react-native/packager/react-native-xcode.sh" file.

3. Deploy a release build to the simulator, which unlike debug builds, will generate the JS bundle (React Native >=0.22.0 only).
]

# for local server
cd ./code-push-server-master

### 安装：
参考：https://github.com/lisong/code-push-server
$ cd /path/to/code-push-server
$ mysql -uroot -e"create database codepush default charset utf8;"
$ mysql -uroot codepush < ./sql/codepush.sql
$ mysql -uroot codepush < ./sql/codepush-v0.1.1.sql
$ mysql -uroot codepush < ./sql/codepush-v0.1.5.sql
$ npm install

 
### 修改配置： 
- storageType: "local"
- dataDir: "/Users/xionghaitao/my_git_rep/script/reactive-app/localData",
- storageDir: "/Users/xionghaitao/my_git_rep/script/reactive-app/localVersions",

### 使用
1.登录，填写token
$ code-push login http://localhost:3000
2.添加app
$ code-push app add ios_xhtlocal
3.获取deployKey修改工程配置
$ code-push deployment ls ios_xhtlocal -k
3.发布app
code-push release-react ios_xhtlocal ios


###troubleshooting
1.没有任何改变,则会release失败。
[Error]  The uploaded package is identical to the contents of the specified deployment's current release.
2.本地目录为配置，上传失败
[Error]  Not Acceptable
解决办法：
查看源码：  router.post('/:appName/deployments/:deploymentName/release',
增加日志：  console.log(e); res.status(406).send(e.message);
修改配置： 
- storageType: "local"
- dataDir: "/Users/xionghaitao/my_git_rep/script/reactive-app/localData",
- storageDir: "/Users/xionghaitao/my_git_rep/script/reactive-app/localVersions",

# for local web management
参考：https://github.com/lisong/code-push-web
cd ./code-push-web-master
npm install
npm start
目前只能查看，还没有应用管理功能。


#reference
https://github.com/Microsoft/react-native-code-push
https://github.com/lisong/code-push-server
http://microsoft.github.io/code-push/docs/cli.html




