### 注意事项：

- 1. 需要添加 httpEnable 选项
- 2. 支持ios系统7.0
- 3. 对于已安装的应用，无法通过tako再次安装。--需要提示


### todo:
- 特殊logo无法显示。http://tako.kssws.ks-cdn.com/test/logo/99f4a84b-9049-4af7-4da0-ed504e9ece74.png
- bar中的图片分辨率
- 测试页面正在下载时，下载页面未更新。
- 下面的传参格式是否可取？ 两个tableview是否可继承？
// todo: 是否可取？？？？？
-(id)init{
    share = [super init];
    return share;
}
- cell和table的编程规范。 cell变化后，app的信息必须同步更新。

- 保存间隔0.1是否可用？test页面下载完成后，download页面需要移动item在section中的位置  -- todo
- test页面新增任务时（且password正确。），需要向管理页面添加新的item. // todo: 待优化，可提前加入app。-- todo
- // todo:通过监听处理，以减少viewappear中的事件。
- 应用内打开app，暂不支持
- 关闭shareInstance线程。。。。

### 测试场景
- 1 带密码，不带密码
- 2 暂停，恢复，反复测试
- 3 6.0的icon

### 标签说明
- todo：
- refactor
- t













 
