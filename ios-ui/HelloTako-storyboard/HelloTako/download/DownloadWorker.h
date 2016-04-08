
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 下载回调协议
@protocol XHtDownLoadDelegate <NSObject>

-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize tag:(NSString*)tag;
-(void)downloadFinish:(BOOL)isSuccess msg:(NSString*)msg tag:(NSString*)tag;

@end



@interface DownloadWorker : NSObject

@property (nonatomic) BOOL isFree;

// 请求标示，即appVersionId
@property (nonatomic, copy) NSString  *tag;

@property (nonatomic, copy) NSString  *appid;

@property (nonatomic, copy) NSString  *password;

@property(nonatomic, strong)id<XHtDownLoadDelegate> delegate;


// 启动
- (void)startWithUrl:(NSURL*) url appid:(NSString*)appid password:(NSString*)password tag:(NSString*)tag delegate:(id<XHtDownLoadDelegate>)delegate;

// 暂停
- (void)pause:(NSString*)tag;

// 停止（下次将重新下载）
- (void)stop:(NSString*)tag;

@end

