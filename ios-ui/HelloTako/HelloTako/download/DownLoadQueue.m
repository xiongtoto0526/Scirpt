
#import "DownloadQueue.h"



@implementation DownloadInfo

@end


NSMutableArray* workerThreadPool = nil;
NSMutableDictionary* taskQueueDict = nil;

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
        taskQueueDict = [[NSMutableDictionary alloc]init];
        workerThreadPool = [[NSMutableArray alloc]init];
    }
    return self;
}


- (void)add:(NSString*)url appid:(NSString*)appid tag:(NSString*)tag delegate:(id<XHtDownLoadDelegate>)delegate{
    
    if (url==nil) {
        NSLog(@"the download url is invalid...");
        return;
    }
    
    BOOL isDup = [taskQueueDict objectForKey:tag]!=nil;
    
    if (!isDup) {
        // 保存请求
        DownloadInfo* d = [DownloadInfo new];
        d.url = url;
        d.tag = tag;
        d.delegate = delegate;
        d.isSuspend = NO;// 只有被用户主动暂停时，该标志位才会为YES
        d.isExecuting =NO;
        [taskQueueDict setObject:d forKey:tag];
    }
    
    // 去除暂停标志。
    DownloadInfo* d = (DownloadInfo*)[taskQueueDict objectForKey:tag];
    d.isSuspend = NO;
    
    DownloadWorker* worker = [self newWorker];
    // 最大线程数之外的请求，排队。
    if (worker==nil) {
        NSLog(@"Request reach max thread size,will be waitting in taskQueue ...");
        return;
    }
    
    [worker startWithUrl:[NSURL URLWithString:url] appid:appid tag:tag delegate:self ];
    d.isExecuting=YES;// 更新执行状态
    
    
}

-(void)startOne{
    NSUInteger count =[taskQueueDict count];
    id keys = [taskQueueDict allKeys];
    for (int i = 0; i < count; i++)
    {
        id key = [keys objectAtIndex: i];
        id value = [taskQueueDict objectForKey: key];
        DownloadInfo* downloadInfo = (DownloadInfo*)value; // 选取任务
        if (!downloadInfo.isExecuting && !downloadInfo.isSuspend) {
            DownloadWorker* worker = [self newWorker];// 选取线程
            [worker startWithUrl:[NSURL URLWithString:downloadInfo.url] appid:nil tag:downloadInfo.tag  delegate:self];
            downloadInfo.isExecuting=YES;
            break;
        }
    }
    
}

-(DownloadWorker*)newWorker{
    
    // 从线程池中获取
    for (int i = 0; i < [workerThreadPool count]; i++)
    {
        id value = [workerThreadPool objectAtIndex: i];
        DownloadWorker* worker = (DownloadWorker*)value;
        if (worker.isFree) {
            return worker;
        }
    }
    
    // 池中资源不够，创建。
    if ([workerThreadPool count]<MAX_DOWNLOAD_THREAD_COUNT) {
        DownloadWorker* worker = [DownloadWorker new];
        [workerThreadPool addObject:worker];// d的free标志会同步更新到pool? 待测试。
        return worker;
    }
    
    return nil;
}


// 暂停
- (void)pause:(NSString*)tag{
    
    // 从线程池中查找对应的线程
    for (int i = 0; i < [workerThreadPool count]; i++)
    {
        id value = [workerThreadPool objectAtIndex: i];
        DownloadWorker* worker = (DownloadWorker*)value;
        if ([worker.tag isEqualToString:tag]) {
            [worker pause:tag];
            
            // 更新队列信息
            DownloadInfo* d = (DownloadInfo*)[taskQueueDict objectForKey:tag];
            d.isExecuting=NO;
            d.isSuspend=YES;
            [self startOne];
            return;
        }
    }

    NSLog(@"download is still waiting...");
}

// 停止（下次将重新下载）
- (void)stop:(NSString*)tag{
    
    // 从线程池中查找获取
    for (int i = 0; i < [workerThreadPool count]; i++)
    {
        id value = [workerThreadPool objectAtIndex: i];
        DownloadWorker* worker = (DownloadWorker*)value;
        if ([worker.tag isEqualToString:tag]) {
            [worker stop:tag];
            
            // 更新队列信息
            DownloadInfo* d = (DownloadInfo*)[taskQueueDict objectForKey:tag];
            d.isExecuting=NO;
            d.isSuspend=YES;
            [self startOne];
            return;
        }
    }
    
    NSLog(@"download is still waiting...");
}

#pragma mark delegate

-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize tag:(NSString*)tag{
    NSLog(@"progress wrapper in downloadQueue...");
    DownloadInfo* d =  (DownloadInfo*)[taskQueueDict objectForKey:tag];
    [d.delegate downloadingWithTotal:totalSize complete:finishSize tag:tag];
}

-(void)downloadFinish:(BOOL)isSuccess msg:(NSString*)msg tag:(NSString*)tag{
    NSLog(@"finish wrapper in downloadQueue...");
    DownloadInfo* d =  (DownloadInfo*)[taskQueueDict objectForKey:tag];
    [d.delegate downloadFinish:isSuccess msg:msg tag:tag];
    if (isSuccess) {
        [taskQueueDict removeObjectForKey:tag];
    }
        
    [self startOne];
}


@end