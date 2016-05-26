require('require-dir')('./task');
// 此处指定了所有task存放的路径。
// 使用：
// - gulp 命令会启动 ./task 目录下的 default task（即当前的development.js环境）
// - gulp deploy 命令会启动 ./task 目录下的 deploy task（即当前的production.js环境）

// 区别：生产环境的js会压缩，css会去除 map 标记


