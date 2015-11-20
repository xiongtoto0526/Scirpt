
#import <Foundation/Foundation.h>

#define XGSDK_EVENT_INIT    @"XgsdkInitResult"
#define XGSDK_EVENT_LOGIN   @"XgsdkLoginResult"
#define XGSDK_EVENT_LOGOUT  @"XgsdkLogoutResult"
#define XGSDK_EVENT_PAY     @"XgsdkRechargeResult"
#define XGSDK_EVENT_SWITCH_USER @"XgsdkSwitchUserResult"

@interface XGSDKWrapper : NSObject
+ (void) onResult:(id) obj withEvent:(NSString*) event withRet:(NSInteger) ret withMsg:(NSString*) msg;
@end
