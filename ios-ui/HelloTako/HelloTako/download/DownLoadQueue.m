
#import "DownloadQueue.h"
#import "UIHelper.h"

@interface DownloadQueueInfo : NSObject
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* tag;
@property (nonatomic, copy) NSString* versionid;
@property (nonatomic, copy) NSString* versionname;
@property (nonatomic, copy) NSString* password;
@property (nonatomic) BOOL isExecuting;
@property (nonatomic) BOOL isSuspend;
@property(nonatomic, strong)id<XHtDownLoadDelegate> delegate;
@end

//enum TASK_STATUS {
//    WAITING = 0,
//    EXECUTING,
//    SUSPENDING,
//};

@implementation DownloadQueueInfo

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

- (void)add:(NSString*)url DownloadInfo:(DownloadHistory*)info tag:(NSString*)tag delegate:(id<XHtDownLoadDelegate>)delegate{
    
    if (url==nil) {
        NSLog(@"the download url is invalid...");
        return;
    }
    
    BOOL isDup = [taskQueueDict objectForKey:tag]!=nil;
    
    if (!isDup) {
        // 保存请求
        DownloadQueueInfo* d = [DownloadQueueInfo new];
        d.url = url;
        d.tag = tag;
        d.versionid = info.download_app_version;
        d.password = info.download_password;
        d.versionname = info.download_app_version_name;
        d.isSuspend = NO;// 只有被用户主动暂停时，该标志位才会为YES
        d.isExecuting =NO;
        [taskQueueDict setObject:d forKey:tag];
    }
    
    
    // 去除暂停标志。
    DownloadQueueInfo* d = (DownloadQueueInfo*)[taskQueueDict objectForKey:tag];
    d.delegate = delegate; // 同一个tag可以有两个delegte，所以此处需要重新设置delegate
    d.isSuspend = NO;
    
    DownloadWorker* worker = [self newWorker];
    // 最大线程数之外的请求，排队。
    if (worker==nil) {
        NSLog(@"Request reach max thread size,will be waitting in taskQueue ...");
        return;
    }
    
    [worker startWithUrl:[NSURL URLWithString:url] DownloadInfo:info tag:tag delegate:self ];
    d.isExecuting=YES;// 更新执行状态
}


-(void)startOne{
    
    DownloadQueueInfo*  downloadInfo =nil;
    for (NSString* key in taskQueueDict) {
        downloadInfo =  [taskQueueDict objectForKey:key]; // 选取任务
        if (!downloadInfo.isExecuting && !downloadInfo.isSuspend) {
            DownloadWorker* worker = [self newWorker];// 选取线程
            DownloadHistory* info = [DownloadHistory new];
            info.download_app_version = downloadInfo.versionid;
            info.download_app_version_name = downloadInfo.versionname;
            info.download_password = downloadInfo.password;
            [worker startWithUrl:[NSURL URLWithString:downloadInfo.url] DownloadInfo:info tag:downloadInfo.tag  delegate:self];
            downloadInfo.isExecuting=YES;
            break;
        }
    }
    
}

-(DownloadWorker*)newWorker{
    
    // 从线程池中获取闲置线程
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
    
    // 更新队列的状态
    DownloadQueueInfo* info = [taskQueueDict objectForKey:tag];
    info.isSuspend = YES;
    info.isExecuting = NO;
    
    // 从线程池中查找对应的工作线程
    for (int i = 0; i < [workerThreadPool count]; i++)
    {
        id value = [workerThreadPool objectAtIndex: i];
        DownloadWorker* worker = (DownloadWorker*)value;
        if ([worker.tag isEqualToString:tag]) {
            [worker pause:tag];
            
            [self startOne];
            return;
        }
    }
    
    NSLog(@"download is still waiting...");
}

// 停止（下次将重新下载）
- (void)stop:(NSString*)tag{
    
    // 更新队列的状态
    DownloadQueueInfo* info = [taskQueueDict objectForKey:tag];
    info.isSuspend = YES;
    info.isExecuting = NO;
    
    // 从线程池中查找获取
    for (int i = 0; i < [workerThreadPool count]; i++)
    {
        id value = [workerThreadPool objectAtIndex: i];
        DownloadWorker* worker = (DownloadWorker*)value;
        if ([worker.tag isEqualToString:tag]) {
            [worker stop:tag];
            
            [self startOne];
            return;
        }
    }
    
    NSLog(@"download is still waiting...");
}

#pragma mark delegate

//#define XHT_DOWNLOAD_PROGERSS_NOTIFICATION @"XHT_download_progress"
//#define XHT_DOWNLOAD_FINISH_NOTIFICATION @"XHT_download_finish"


// 下载过程中，先进入该回调，然后再转发至viewController
-(void)downloadingWithTotal:(long long)totalSize complete:(long long)finishSize speed:(NSString *)speed tag:(NSString*)tag{
    //    NSLog(@"progress wrapper in downloadQueue...");
    //    DownloadInfo* d =  (DownloadInfo*)[taskQueueDict objectForKey:tag];
    //    [d.delegate downloadingWithTotal:totalSize complete:finishSize tag:tag];
    //
    
    // 获取到button对应的cell
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:[XHTUIHelper stringWithLong:totalSize] forKey:@"totalSize"];
    [dict setObject:[XHTUIHelper stringWithLong:finishSize] forKey:@"finishSize"];
    [dict setObject:speed forKey:@"speed"];
    [dict setObject:tag forKey:@"tag"];
    
    // 发送事件
    NSNotification *notification =[NSNotification notificationWithName:XHT_DOWNLOAD_PROGERSS_NOTIFICATION object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

// 下载结束时，先进入该回调，然后再转发至viewController
-(void)downloadFinish:(BOOL)isSuccess msg:(NSString*)msg tag:(NSString*)tag{
    
    /* 使用 delegate 发送事件*/
    //    NSLog(@"finish wrapper in downloadQueue...");
    //    DownloadInfo* d =  (DownloadInfo*)[taskQueueDict objectForKey:tag];
    //    [d.delegate downloadFinish:isSuccess msg:msg tag:tag];
    
    /* 使用 notification 发送事件*/
    NSString* ret = isSuccess?@"1":@"0";
    // 获取到button对应的cell
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:ret forKey:@"isSuccess"];
    [dict setObject:msg forKey:@"msg"];
    [dict setObject:tag forKey:@"tag"];
    
    // 发送事件
    NSNotification *notification =[NSNotification notificationWithName:XHT_DOWNLOAD_FINISH_NOTIFICATION object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    if (isSuccess) {
        [taskQueueDict removeObjectForKey:tag];
    }
    
    [self startOne];// 领一次任务
}


@end