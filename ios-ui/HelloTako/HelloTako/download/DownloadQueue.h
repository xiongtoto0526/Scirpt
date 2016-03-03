
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DownloadWorker.h"
#import "Constant.h"


@interface XHtDownLoadQueue : NSObject<XHtDownLoadDelegate>

+ (instancetype)share;

// 添加
- (void)add:(NSString*)url appid:(NSString*)appid password:(NSString*)password tag:(NSString*)tag delegate:(id<XHtDownLoadDelegate>)delegate;

// 暂停
- (void)pause:(NSString*)tag ;

// 停止（下次将从0开始下载）
- (void)stop:(NSString*)tag ;

@end

