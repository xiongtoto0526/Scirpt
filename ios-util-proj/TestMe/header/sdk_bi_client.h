#import <Foundation/Foundation.h>



@interface XGDataRoleInfo : NSObject
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
@interface XGDataBuyInfo : NSObject
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


@interface SdkBiClient : NSObject

/**
 @brief 开始启动数据统计SDK客户端
 */
+(void) startStatistic:(NSString*) channelID andOther:(NSDictionary*)other;


/**
 @brief 开始登陆
 */
+(void) beginLogin;


/**XGSDK.bundle
 @brief 账号登录成功后调用此接口
 */
+(void) accountLogin:(NSString *)accountID tokenId:(NSString*)tokenId andOther:(NSDictionary *)other;


/**
 @brief 角色登录成功后调用此接口
 */
+(void) roleLoginWithRoleInfo:(XGDataRoleInfo*) xgDataRoleInfo other:(NSDictionary*)other;

/**
 @brief 自定义事件发送接口 eventContent(json格式串)
 */
+(void) onEvent:(NSString*) eventID eventVal:(NSString*) eventVal eventDesc:(NSString*)eventDesc Content:(NSString*) eventContent;


// 等级提升
+(void)roleLevelUpWithRoleInfo:(XGDataRoleInfo*)xgDataRoleInfo;


// 角色消费
+(void)roleRechargeWithRoleInfo:(XGDataRoleInfo*)xgDataRoleInfo rechargeChannel:(NSString*)rechargeChannel currency:(NSString*)currency money:(NSString*)money gold:(NSString*)gold bindingGold:(NSString*)bindingGold;

// 虚拟货币获赠
+(void)virtualCurrencyRewardWithRoleInfo:(XGDataRoleInfo*)xgDataRoleInfo gold:(NSString *)gold gainChannel:(NSString *)gainChannel;

// 虚拟货币消费
+(void)virtualCurrencyConsumeWithRoleInfo:(XGDataRoleInfo*)xgDataRoleInfo gold:(NSString *)gold itemName:(NSString *)itemName;

// 虚拟货币购买
+(void)virtualCurrencyPurchaseWithRoleInfo:(XGDataRoleInfo*) xgDataRoleInfo gold:(NSString *)gold;

// 任务开始
+(void) missionBeginWithRoleINfo:(XGDataRoleInfo*)xgDataRoleInfo missionId:(NSString *)missionId missionName:(NSString *)missionName customParams:(NSString *)customParams;

// 任务成功
+(void) missionSuccessWithRoleInfo:(XGDataRoleInfo*)xgDataRoleInfo missionId:(NSString *)missionId missionName:(NSString *)missionName customParams:(NSString *)customParams;

// 任务失败
+(void) missionFailWithRoleInfo:(XGDataRoleInfo*)xgDataRoleInfo missionId:(NSString *)missionId missionName:(NSString *)missionName customParams:(NSString *)customParams;

// 充值到账
+(void) payFinish:(XGDataBuyInfo*) xgDataBuyInfo;

/**
 @brief 测试服务器的网络情况
 */
+(void) networkdelay:(NSString*) serverHost;

/**
 @brief 在即将切换到后台运行时调用此接口
 */
+(void) onPause:(NSDictionary*) other;

/**
 @brief 在恢复运行时调用此接口
 */
+(void) onResume:(NSDictionary*) other;


/**
 @brief 发送心跳,300秒一次。
 */
+(void)sendHeart;

@end
