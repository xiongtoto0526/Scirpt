
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DownloadWorker.h"
#import "Constant.h"

@interface DownloadInfo : NSObject 
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* tag;
@property (nonatomic) BOOL isExecuting;
@property (nonatomic) BOOL isSuspend;
@property(nonatomic, strong)id<XHtDownLoadDelegate> delegate;
@end


@interface XHtDownLoadQueue : NSObject<XHtDownLoadDelegate>

+ (instancetype)share;

// 添加
- (void)add:(NSString*)url appid:(NSString*)appid tag:(NSString*)tag delegate:(id<XHtDownLoadDelegate>)delegate;

// 暂停
- (void)pause:(NSString*)tag ;

// 停止（下次将重新下载）
- (void)stop:(NSString*)tag ;

@end

