#coding

调试：
面板：command + d
刷新：Command + R
log:  react-native log-ios
设备调试：Debugging on a device with Chrome Developer Tools
On iOS devices, open the file RCTWebSocketExecutor.m and change "localhost" to the IP address of your computer, then select "Debug JS Remotely" from the Developer Menu.

1. 应用名
// 注意，这里用引号括起来的'HelloWorldApp'必须和你init创建的项目名一致
AppRegistry.registerComponent('HelloWorldApp', () => HelloWorldApp);

2.JXS 中{}内的会被编译为js表达式

3 flex布局：
组件能够撑满剩余空间的前提是其父容器的尺寸不为零。如果父容器既没有固定的width和height，也没有设定flex，则父容器的尺寸为零。其子组件如果使用了flex，也是无法显示的。

4.
ScrollView适合用来显示数量不多的滚动元素.如果你需要显示较长的滚动列表，那么应该使用功能差不多但性能更好的ListView组件

5.自定义组件
https://facebook.github.io/react/docs/reusable-components.html

6.优秀例子
https://rnplay.org/apps/picks

7.直接操作dom
setNativeProps

8.
ref回调语法
https://facebook.github.io/react/docs/more-about-refs.html#the-ref-callback-attribute

9.定期升级

10.区分平台
ref: http://reactnative.cn/docs/0.31/platform-specific-code.html#content
使用方法：Platform.select()，它可以以Platform.OS为key


idea:
The faster you react, the less you think.
————————————————————————————————————————————————
react 特性：
React是很快的，因为它从不直接操作DOM。React在内存中维护一个快速响应的DOM描述。render()方法返回一个DOM的描述，React能够利用内存中的描述来快速地计算出差异，然后更新浏览器中的DOM。
————————————————————————————————————————————————
______________________________
0.组件类的第一个字母必须大写
1. ...props(正向绑定),filter
2.this.refs,
Ref 的字符串属性
React 支持一个非常特殊的属性，你可以附加到任何从 render() 输出的组件中
ref 回调属性
ref 属性可以是一个回调函数，而不是一个名字。这个回调函数在组件安装后立即执行。被引用的组件作为一个参数传递，且回调函数可以立即使用这个组件，或保存供以后使用(或实现这两种行为)。
3.（反向绑定）添加反向数据流，setState,onChange='handleInput'
4.Props 应该被当作禁止修改的。修改 props 对象可能会导致预料之外的结果，所以最好不要去修改 props 对象。
5.如果往原生 HTML 元素里传入 HTML 规范里不存在的属性，React 不会显示它们。如果需要使用自定义属性，要加 data- 前缀
6.Parent 能通过专门的 this.props.children props 读取子级。
7.多数情况下，可以通过隐藏组件而不是删除它们来绕过这些问题。因为this.state 来在多次渲染过程中里维持数据的状态化组件，这样做潜在很多问题。
8.如果子级要在多个渲染阶段保持自己的特征和状态，在这种情况下，你可以通过给子级设置惟一标识的 key 来区分。当 React 校正带有 key 的子级时，它会确保它们被重新排序（而不是破坏）或者删除（而不是重用）
<ListItemWrapper key={result.id} data={result}/>;
var ListItemWrapper = React.createClass({
  render: function() {
    return <li>{this.props.data.text}</li>;
  }
9.跨模块复用代码
Mixins
10.组件的生命周期包含三个主要部分：
挂载： 组件被插入到DOM中。
更新： 组件被重新渲染，查明DOM是否应该刷新。
移除： 组件从DOM中移除。
11.组件间的通信
 <div onClick={this.handleClick.bind(this, i)} key={i}>{item}</div>
12.Promise对象正在抓取数据（pending状态）


________todo_______________________________

1. JSX 语法转为 JavaScript 语法，这一步很消耗时间，实际上线的时候，应该将它放到服务器完成。
2. 











