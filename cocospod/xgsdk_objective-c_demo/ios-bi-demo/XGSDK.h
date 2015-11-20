
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, XGInterfaceOrientationMask)
{
    XGInterfaceOrientationMaskPortrait=0,
    XGInterfaceOrientationMaskLandscape,
};


typedef NS_ENUM(NSInteger, XGPayResult)
{
    XGPayResultSuccess = 0,
    XGPayResultCancle,
    XGPayResultFail,
    XGPayResultUnknow,
    XGPayHighRiskCurrency,
    XGPayResultProgress,
};

typedef NS_ENUM(NSInteger, XGInitResult)
{
    XGInitSuccess = 0,
    XGInitFail,
};


typedef NS_ENUM(NSInteger, XGLoginResult)
{
    XGLoginSuccess = 0,
    XGLoginFail,
    XGLoginCancel,
};

typedef NS_ENUM(NSInteger, XGLogoutResult)
{
    XGLogoutSuccess = 0,
    XGLogoutFail,
};


/*
 分享渠道的标志值
 */
#if !defined(CHANNELVALUE)
#define CHANNELVALUE
enum CHANNELVALUE
{
    WEIXIN_FRIEND = 0,      //微信好友
    WEIXIN_FRIEND_LINE,     //微信朋友圈
    WEIXIN_FAVORITE,        //微信收藏
    QQ_VALUE,               //QQ
    QQ_ZONE,                //QQ空间
    TENCENT_WEIBO,          //腾讯微博
    SINA_WEIBO,             //新浪微博
    MESSAGE_VALUE,          //短信
    MAIL_VALUE,             //邮件
    RENREN_VALUE,           //人人网
    KAIXIN_VALUE,           //开心网
    TWITER_VALUE,           //Twitter
    GOOGLE_VALUE,           //Google+
    YINXIN_FRIEND,          //易信好友
    YIXIN_LINE,             //易信好友圈
    PRINT_VALUE,            //打印
    COPY_VALUE,             //拷贝
    DOUPIAN_VULUE,          //豆瓣
    YINXINANG_NOTE,         //印象笔记
    FACEBOOK_VALUE,         //Facebook
    LINKEDIN_VALUE,         //LinkedIn
    PINTEREST_VALUE,        //Pinterest
    POCKET_VALUE,           //Pocket
    INSTAPAPER_VALUE,       //Instapaper
    YOUDAO_NOTE,            //有道云笔记
    SOUHU_KANKAN,           //搜狐随身看
    FLICKR_VALUE,           //Flicfr
    TUMBLR_VALUE,           //Tumblr
    DROPBOX_VALUE,          //Dropbox
    INSTAGRAM_VALUE,        //Instagram
    VKONTAKTE_VALUE,        //VKontakte
    MINGDAO_NOTE,           //明道
    LINE_VALUE,             //Line
    WHATAPP_VALUE,          //WhatsApp
    KAKAO_TALK,             //KakaoTalk
    KAKO_STRING             //KakaoStinng
};
#endif



@interface XGRoleInfo : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *roleId;
@property (nonatomic, copy) NSString *roleType;
@property (nonatomic, copy) NSString *roleLevel;
@property (nonatomic, copy) NSString *roleVipLevel;
@property (nonatomic, copy) NSString *serverId;
@property (nonatomic, copy) NSString *zoneId;
@property (nonatomic, copy) NSString *roleName;
@property (nonatomic, copy) NSString *serverName;
@property (nonatomic, copy) NSString *zoneName;
@property (nonatomic, copy) NSString *partyName;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *balance;
@end

/**
 @breif 购买信息属性
 **/
@interface XGBuyInfo : NSObject
@property (nonatomic, copy) NSString *tradeSN;
@property (nonatomic, copy) NSString *tokenId;
@property (nonatomic, copy) NSString *accountID;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productUnit;
@property (nonatomic, copy) NSString *productQuantity;
@property (nonatomic, copy) NSString *productUnitPrice;
@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *payAmount;
@property (nonatomic, copy) NSString *productDesc;
@property (nonatomic, copy) NSString *currencyName;
@property (nonatomic, copy) NSString *roleId;
@property (nonatomic, copy) NSString *roleName;
@property (nonatomic, copy) NSString *roleLevel;
@property (nonatomic, copy) NSString *roleVipLevel;
@property (nonatomic, copy) NSString *serverId;
@property (nonatomic, copy) NSString *zoneId;
@property (nonatomic, copy) NSString *partyName;
@property (nonatomic, copy) NSString *virtualCurrencyBalance;
@property (nonatomic, copy) NSString *customInfo;
@property (nonatomic, copy) NSString *gameTradeNo;
@property (nonatomic, copy) NSString *gameCallbackUrl;
@property (nonatomic, copy) NSString *additionalParams;
@end




#pragma mark - 回调接口
@protocol XgsdkDelegate <NSObject>
//初始化回调
-(void) onInitFinishWithResultCode:(NSInteger) code resultMsg: (NSString*) msg;

//登录回调
-(void) onLoginSuccessWithResultCode:(NSInteger) code authInfo: (NSString*) authInfo;
-(void) onLoginFailWithResultCode:(NSInteger) code resultMsg: (NSString*) msg channelCode:(NSString*) channelCode;
-(void) onLoginCancelWithResultCode:(NSInteger) code resultMsg:(NSString*) msg;

//登出回调
-(void) onLogoutFinishWithResultCode:(NSInteger) code resultMsg:(NSString*) msg;

//支付回调
-(void) onPaySuccessWithResultCode:(NSInteger) code resultMsg:(NSString*) msg gameTradeNO:(NSString*) gameTradeNo xgTradeNO:(NSString*) xgTradeNo;
-(void) onPayFailWithResultCode:(NSInteger) code resultMsg:(NSString*) msg gameTradeNO:(NSString*) gameTradeNo channelCode:(NSString*) channelCode channelMsg:(NSString*) channelMsg;
-(void) onPayCancelWithResultCode:(NSInteger) code resultMsg:(NSString*) msg gameTradeNO:(NSString*) gameTradeNo channelCode:(NSString*) channelCode channelMsg:(NSString*) channelMsg;
-(void) onPayProgressWithResultCode:(NSInteger) code resultMsg:(NSString*) msg gameTradeNO:(NSString*) gameTradeNo channelCode:(NSString*) channelCode channelMsg:(NSString*) channelMsg;
-(void) onPayOthersWithResultCode:(NSInteger) code resultMsg:(NSString*) msg gameTradeNO:(NSString*) gameTradeNo channelCode:(NSString*) channelCode channelMsg:(NSString*) channelMsg;
@end



#pragma mark - 主动调用接口
@protocol XGSDK <NSObject>
/**
 @brief 初始化
 参数：无
 返回：retCode  结果码:0为成功
 retMsg   结果描述
 */
-(void)XGInitWith:(NSString *)customInfo xgsdkDelegate:(id<XgsdkDelegate>) xgsdkDelegate;

/**
 @brief 进入登陆页面 (必须等到接收到初始化回调信息后调用)
 参数：customInfo，自定义字段，扩展用。
 返回：resultCode 结果码，参见上方的枚举值
 anthInfo   加密串后的url串
 */
-(void)XGLoginWith:(NSString *)customInfo;

/**
 @brief 登出(登出或注销时调用)
 参数：customInfo，自定义字段，扩展用。
 返回：resultCode 结果码，参见上方的枚举值
 resultMsg  消息描述
 */
-(void)XGLogout:(NSString *)customInfo;

/**
 @brief 支付(点击购买时调用)
 参数：buyInfo，购买信息，参见上方的interface:XGBuyInfo。
 返回：resultCode 结果码，参见上方的枚举值
 resultMsg  消息描述
 */
-(void)XGPaymentWithBuyInfo:(XGBuyInfo*)buyInfo;

/**
 @brief  获取渠道id
 **/
- (NSString *)XGgetChannelId;



// ----------2. xgsdk optional function --------------
/*
 @breif 绑定账号，仅小米渠道需要调用此接口。
 */
-(void)XGBindAccount:(NSString *)customInfo;


/**
 @brief 进入用户中心
 参数：customInfo  自定义字段，扩展用
 返回：无
 */
-(void)XGUserCenter:(NSString *)customInfo;


/**
 @brief 是否需要显示用户中心
 参数：无
 返回：bool
 */
-(BOOL) isShowUserCenterAvailable;


// ------ 2.0 统计接口 ---------------
/**
 @brief 角色登录成功后调用此接口--调用角色登陆和账号登陆
 */
-(void) onEnterGame:(XGRoleInfo*) roleInfo;

/**
 @brief 角色提升时调用此接口
 */
-(void) onRoleLevelUp:(XGRoleInfo*) roleInfo;


/**
 @brief 自定义事件发送接口,eventContent为json格式
 */
-(void) onEvent:(XGRoleInfo*) roleInfo eventId:(NSString*) eventID enventDesc:(NSString*)eventDesc eventValue:(NSString*)eventValue eventBody:(NSString*) eventContent;


/*
 任务事件
 */
-(void) onMissionBegin:(XGRoleInfo*) roleInfo missionId:(NSString*) missionId missionName:(NSString*)missionName customParams:(NSString*)customParams;


-(void) onMissionSuccess:(XGRoleInfo*) roleInfo missionId:(NSString*) missionId missionName:(NSString*)missionName customParams:(NSString*)customParams;


-(void) onMissionFail:(XGRoleInfo*) roleInfo missionId:(NSString*) missionId missionName:(NSString*)missionName customParams:(NSString*)customParams;

/*
 货币事件
 */
-(void) onVirtualCurrencyPurchase:(XGRoleInfo*) roleInfo amount:(NSString*)amount customParams:(NSString*)customParams;
-(void) onVirtualCurrencyReward:(XGRoleInfo*) roleInfo reason:(NSString*)reason amount:(NSString*)amount customParams:(NSString*)customParams;
-(void) onVirtualCurrencyConsume:(XGRoleInfo*) roleInfo itemName:(NSString*)itemName amount:(NSString*)amount customParams:(NSString*)customParams;

/*
 充值到账
 */
-(void) onPayFinish:(XGBuyInfo*) xgBuyInfo;


// 网络
-(void) pingServer:(NSString*)serverHost;

//----------ios 分享接口 ---------------

/*
 弹出分享渠道选择框
 */

- (void)openShare:(NSString*)mediaObj;

/*
 直接分享接口，不用弹出分享选择框
 */
- (void)directShare:(int)channelValue mediaObj:(NSString*)mediaObj;


//----------ios Push 接口 ---------------

/*
 设置回调接口
 @block      用于回调接口，用于通知游戏跳转到某个指定的页面
 @activity   要跳转的页面，游戏配置给服务器的
 @jsonParam  跳转页面的参数
 */
- (void)setPushActivityBlock:(void (^)(NSString* activity ,NSString* jsonParam))block;

@end


@interface XGSDKFactory : NSObject
+(NSObject<XGSDK>*) defaultSDK;
+(XGSDKFactory*) share;
@property(nonatomic, strong)id<XgsdkDelegate> xgsdkDelegate;

@end