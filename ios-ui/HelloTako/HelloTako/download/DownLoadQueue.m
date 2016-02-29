
#import "DownloadQueue.h"

@implementation DownloadInfo

@end


NSMutableDictionary* workerThreadDict = nil;
NSMutableDictionary* taskDict = nil;

@implementation XHtDownLoadQueue



+ (instancetype)share
{
    static XHtDownLoadQueue *mainQueue = nil;
    if (mainQueue == nil)
    {
        mainQueue = [[XHtDownLoadQueue alloc] init];
    }
    return mainQueue;
}

-(id)init{
    if ((self = [super init])){
        taskDict = [[NSMutableDictionary alloc]init];
        workerThreadDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}


- (void)add:(NSString*)url tag:(NSString*)tag delegate:(id<XHtDownLoadDelegate>)delegate{
    
    BOOL isDup = [taskDict objectForKey:tag]!=nil;
    
    if (!isDup) {
    // 保存请求
    DownloadInfo* d = [DownloadInfo new];
    d.url = url;
    d.tag = tag;
    d.delegate = delegate;
    [taskDict setObject:d forKey:tag];
    }
    
    // 允许重复请求(即暂停后的恢复)
    if (isDup || [workerThreadDict count]<2) {
        [self newWorker:tag];
        [[workerThreadDict objectForKey:tag] startWithUrl:[NSURL URLWithString:url] delegate:self tag:tag];
        DownloadInfo* d = (DownloadInfo*)[taskDict objectForKey:tag];
        d.isExecuting=YES;// 记录执行状态
    }else{
        NSLog(@"reach max thread size,will wait...");
    }
}

-(void)startOne{
    NSUInteger a =[taskDict count];
    id keys = [taskDict allKeys];
    for (int i = 0; i < a; i++)
    {
        id key = [keys objectAtIndex: i];
        id value = [taskDict objectForKey: key];
//        NSLog (@"Key: %@ for value: %@", key, value);
        DownloadInfo* downloadInfo = (DownloadInfo*)value;
        if (!downloadInfo.isExecuting) {
            [self newWorker:downloadInfo.tag];
            [[workerThreadDict objectForKey:downloadInfo.tag] startWithUrl:[NSURL URLWithString:downloadInfo.url] delegate:self tag:downloadInfo.tag];
            downloadInfo.isExecuting=YES;
            break;
        }
    }
   
}

-(void)newWorker:(NSString*)tag{
    if([workerThreadDict objectForKey:tag]==nil){
        [workerThreadDict setObject:[DownloadWorker new] forKey:tag];
    }
}


// 暂停
- (void)pause:(NSString*)tag{
    if ([workerThreadDict objectForKey:tag] !=nil) {
         [(DownloadWorker*)[workerThreadDict objectForKey:tag] pause];
    }else{
        NSLog(@"download is still waiting...");
    }
   
}

// 停止（下次将重新下载）
- (void)stop:(NSString*)tag{
    if ([workerThreadDict objectForKey:tag] !=nil) {
        [(DownloadWorker*)[workerThreadDict objectForKey:tag] stop];
    }else{
        NSLog(@"download is still waiting...");
    }
}

#pragma mark delegate

-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize tag:(NSString*)tag{
    NSLog(@"progress wrapper in downloadQueue...");
   DownloadInfo* d =  (DownloadInfo*)[taskDict objectForKey:tag];
    [d.delegate downloadingWithTotal:totalSize complete:finishSize tag:tag];
}

-(void)downloadFinish:(BOOL)isSuccess tag:(NSString*)tag{
    NSLog(@"finish wrapper in downloadQueue...");
    DownloadInfo* d =  (DownloadInfo*)[taskDict objectForKey:tag];
    [d.delegate downloadFinish:isSuccess tag:tag];
    if (isSuccess) {
        [taskDict removeObjectForKey:tag];
        [workerThreadDict removeObjectForKey:tag];
        [self startOne];
    }
}


@end