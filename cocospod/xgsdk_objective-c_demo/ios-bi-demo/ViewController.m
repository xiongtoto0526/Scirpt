
#import "ViewController.h"
#import "XGSDK.h"
//
//ViewController* statistic=nil;
//
//@interface ViewController() <XgsdkDelegate>
//@property (nonatomic,strong) XGRoleInfo* xgRoleInfo;
//@end
//
//@implementation ViewController
//
//+(ViewController *)share{
//    @synchronized(self)
//    {
//        if (nil == statistic)
//        {
//            statistic = [[self alloc] init];
//        }
//        return statistic;
//    }
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//    XGRoleInfo* roleInfo = [XGRoleInfo new];
//    
//    //注意：已注明为必填参数的除外，其他参数请尽可能填写完整。
//    
//    roleInfo.uid=@"1";// 账号id，必填
//    roleInfo.roleLevel=@"1";
//    roleInfo.roleVipLevel=@"1";
//    roleInfo.roleType=@"1";
//    roleInfo.roleId=@"1";// 角色id，必填
//    roleInfo.roleName=@"小月";// 角色名称，必填
//    roleInfo.serverId=@"1";// 服id，必填
//    roleInfo.serverName=@"水帘洞";// 服名称，必填
//    roleInfo.partyName=@"结盟1";
//    roleInfo.gender=@"f";
//    roleInfo.zoneId=@"2";
//    roleInfo.zoneName=@"大区2";
//    
//    self.xgRoleInfo=roleInfo;
//    
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
///*
// * 以下回调方法需自己实现，当前仅为空实现。实现前请先声明xgsdkDelegate协议，如下:
// 
// @interface ViewController ()<XgsdkDelegate>
// 
// @end
// * ================ start =======================
// */
////初始化回调
//-(void) onInitFinishWithResultCode:(NSInteger) code resultMsg: (NSString*) msg{
//    NSLog(@"enter init finish block...msg is:%@",msg);
//}
//
////登录回调
//-(void) onLoginSuccessWithResultCode:(NSInteger) code authInfo: (NSString*) authInfo{
//    NSLog(@"enter loginSuccess finish block...authinfo is:%@",authInfo);
//    
//    // 开始游戏后调用,必须调用此接口
//    [[XGSDKFactory defaultSDK] onEnterGame:self.xgRoleInfo];
//}
//-(void) onLoginFailWithResultCode:(NSInteger) code resultMsg: (NSString*) msg channelCode:(NSString*) channelCode{
//    NSLog(@"enter loginFailed finish block...msg is:%@",msg);
//}
//-(void) onLoginCancelWithResultCode:(NSInteger) code resultMsg:(NSString*) msg{
//    NSLog(@"enter loginCancel finish block...msg is:%@",msg);
//}
//
////登出回调
//-(void) onLogoutFinishWithResultCode:(NSInteger) code resultMsg:(NSString*) msg{
//    NSLog(@"enter logout finish block...");
//}
//
////支付回调
//-(void) onPaySuccessWithResultCode:(NSInteger) code resultMsg:(NSString*) msg gameTradeNO:(NSString*) gameTradeNo xgTradeNO:(NSString*) xgTradeNo{
//    NSLog(@"enter paySuccess finish block...msg is:%@",msg);
//}
//
//-(void) onPayFailWithResultCode:(NSInteger) code resultMsg:(NSString*) msg gameTradeNO:(NSString*) gameTradeNo channelCode:(NSString*) channelCode channelMsg:(NSString*) channelMsg{
//    NSLog(@"enter payFailed finish block...msg is:%@",msg);
//}
//
//-(void) onPayCancelWithResultCode:(NSInteger) code resultMsg:(NSString*) msg gameTradeNO:(NSString*) gameTradeNo channelCode:(NSString*) channelCode channelMsg:(NSString*) channelMsg{
//    NSLog(@"enter payCancel finish block...msg is:%@",msg);
//}
//
//-(void) onPayProgressWithResultCode:(NSInteger) code resultMsg:(NSString*) msg gameTradeNO:(NSString*) gameTradeNo channelCode:(NSString*) channelCode channelMsg:(NSString*) channelMsg{
//    NSLog(@"enter payProcess finish block...msg is:%@",msg);
//}
//
//-(void) onPayOthersWithResultCode:(NSInteger) code resultMsg:(NSString*) msg gameTradeNO:(NSString*) gameTradeNo channelCode:(NSString*) channelCode channelMsg:(NSString*) channelMsg{
//    NSLog(@"enter payUnkown finish block...msg is:%@",msg);
//}
//
///*
// * ================== end =====================
// */
//
//
//-(IBAction)initSDK{
//    NSLog(@"will call xgsdk init...");
//    [[XGSDKFactory defaultSDK] XGInitWith:nil xgsdkDelegate:self];// 设置监听类为self。注意:self已经实现了<XgsdkDelegate>协议。
//}
//
//-(IBAction) login{
//    NSLog(@"will call xgsdk login...");
//    [[XGSDKFactory defaultSDK] XGLoginWith:@""];
//}
//
//
//
//-(IBAction) pay{
//    NSLog(@"will call xgsdk pay...");
//    XGBuyInfo *buyInfo = [[XGBuyInfo alloc] init];
//    
//    // !!!! 注意： 以下所有必填参数，不能为空。
//    buyInfo.productId=@"com.game.saierhao1.buy1";//请填写iTunes上注册的产品ID
//    
//    NSLog(@"product id is:%@",buyInfo.productId);
//    
//    buyInfo.accountID=@"1";//必填参数，请填写真实的账号ID
//    
//    buyInfo.productName = @"1";// 请填写产品名称
//    buyInfo.productDesc = @"1";// 请填写产品描述
//    buyInfo.productQuantity = @"1";// 必填参数，请填写产品数量
//    
//    buyInfo.gameTradeNo=@"1";//若存在，请填写游戏的订单号，xg服务端在通知发货时将回传给游戏服务端。
//    buyInfo.gameCallbackUrl=@"www.gameCallbackurl.com";//若填写，则xg服务端将优先使用该地址。若不填，xg服务端将读取portal端配置的游戏回调地址。
//    
//    buyInfo.customInfo =@"1";// 必填参数，!!!注意：该字段不能为空，请填写一个自定义字符串，xg服务端在通知发货时将回传给游戏服务端。
//
//    
//    buyInfo.productUnitPrice =@"1";// 必填参数，请填写产品单价
//    buyInfo.totalAmount=@"1";// 必填参数，请填写产品总价
//    buyInfo.payAmount =@"1";// 必填参数，请填写产品实际支付金额
//    
//    
//    buyInfo.roleId = @"1";// 必填参数，请填写角色id
//    buyInfo.roleName = @"1";// 必填参数，请填写角色名称
//    buyInfo.roleLevel=@"1";// 请填写角色等级
//    buyInfo.roleVipLevel=@"1";// 请填写角色vip等级
//    
//    
//    buyInfo.serverId = @"1";// 若存在，请填写游戏真实的serverId
//    buyInfo.zoneId=@"1"; // 若存在，请填写游戏真实的zoneId
//    buyInfo.currencyName = @"1";// 若存在，请填写货币单位
//    
//    buyInfo.partyName=@"1";// 若存在，请填写帮会名称
//    buyInfo.virtualCurrencyBalance=@"1"; // 若存在，请填写虚拟货币
//    buyInfo.additionalParams=@"1";// 若存在，请填写扩展参数
//    
//    NSLog(@"buyInfo from game...%@",buyInfo);
//    
//    
//    [[XGSDKFactory defaultSDK] XGPaymentWithBuyInfo:buyInfo];
//}
//
//-(IBAction) logout{
//    NSLog(@"will call xgsdk logout...");
//    [[XGSDKFactory defaultSDK] XGLogout:nil];
//}
//
//-(IBAction) userCenter{
//    NSLog(@"will call xgsdk userCenter...");
//    [[XGSDKFactory defaultSDK] XGUserCenter:nil];
//}
//
//
//-(IBAction) enterGame{
//    NSLog(@"will call xgsdk enterGame...");
//    [[XGSDKFactory defaultSDK] onEnterGame:self.xgRoleInfo];
//}
//
//
//
//// 统计类事件
//-(IBAction) sendEvent{
//   
//    
//    // 等级提升后调用
//    self.xgRoleInfo.roleLevel=@"19";
//    [[XGSDKFactory defaultSDK] onRoleLevelUp:self.xgRoleInfo];
//    
//    // 任务开始后调用
//    [[XGSDKFactory defaultSDK] onMissionBegin:self.xgRoleInfo missionId:@"3" missionName:@"missonName3" customParams:@"hello"];
//    
//    // 任务失败后调用
//    [[XGSDKFactory defaultSDK] onMissionFail:self.xgRoleInfo missionId:@"3" missionName:@"missonName3" customParams:@"hello"];
//    
//    // 任务成功后调用
//    [[XGSDKFactory defaultSDK] onMissionSuccess:self.xgRoleInfo missionId:@"3" missionName:@"missonName3" customParams:@"hello"];
//    
//    // 购买货币后调用
//    [[XGSDKFactory defaultSDK] onVirtualCurrencyPurchase:self.xgRoleInfo amount:@"1" customParams:@"custom info"];
//    
//    // 消耗货币后调用
//    [[XGSDKFactory defaultSDK] onVirtualCurrencyConsume:self.xgRoleInfo itemName:@"item4" amount:@"4" customParams:@"custom info"];
//    
//    // 赠送货币后调用
//    [[XGSDKFactory defaultSDK] onVirtualCurrencyReward:self.xgRoleInfo reason:@"reason 1" amount:@"1" customParams:@"custom info"];
//    
//    // 其他自定义事件
//    [[XGSDKFactory defaultSDK] onEvent:self.xgRoleInfo eventId:@"account.login" enventDesc:@"登陆结束" eventValue:@"1" eventBody:@"body json str"];
//    
//}
//
//
//-(IBAction) switchAccount{
//    NSLog(@"will call xgsdk logout...");
//    [[XGSDKFactory defaultSDK] XGLogout:nil];
//}
//
//-(IBAction) pause{
//    
//}
//
//
//-(IBAction) onException{
////    [NSException raise:@"TestException" format:@"Hello, this is a test exception"];
//}
//
//-(IBAction) onError{
////    NSLog(@"on error");
////    int* a = (int*)0x00003;
////    *a = 1;
//}
//@end
