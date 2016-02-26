
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 下载回调协议
@protocol XHtDownLoadDelegate <NSObject>

-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize;
-(void)downloadFinish:(BOOL)isSuccess;

@end

//typedef void (^MyBlock)(int,NSString*);


@interface DownloadWorker : NSObject

@property(nonatomic, strong)id<XHtDownLoadDelegate> delegate;

+ (DownloadWorker*) shareInstance;

// 启动
- (void)startWithUrl:(NSURL*) url delegate:(id<XHtDownLoadDelegate>)delegate;

// 暂停
- (void)pause ;

@end

