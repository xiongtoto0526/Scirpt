
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol XHtDownLoadDelegate <NSObject>

-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize;
-(void)downloadFinish:(BOOL)isSuccess;

@end

//typedef void (^MyBlock)(int,NSString*);


@interface DownloadWorker : NSObject

@property(nonatomic, strong)id<XHtDownLoadDelegate> delegate;

+ (DownloadWorker*) shareInstance;

- (void)startWithUrl:(NSURL*) url delegate:(id<XHtDownLoadDelegate>)delegate;

- (void)pause ;

@end

