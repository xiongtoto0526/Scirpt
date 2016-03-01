
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 下载回调协议
@protocol XHtDownLoadDelegate <NSObject>

-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize tag:(NSString*)tag;
-(void)downloadFinish:(BOOL)isSuccess tag:(NSString*)tag;

@end

//typedef void (^MyBlock)(int,NSString*);


@interface DownloadWorker : NSObject

@property (nonatomic) BOOL isFree;

// 请求标示
@property (nonatomic, copy) NSString  *tag;

@property(nonatomic, strong)id<XHtDownLoadDelegate> delegate;


// 启动
- (void)startWithUrl:(NSURL*) url delegate:(id<XHtDownLoadDelegate>)delegate tag:(NSString*)tag;

// 暂停
- (void)pause:(NSString*)tag;

// 停止（下次将重新下载）
- (void)stop:(NSString*)tag;

@end

