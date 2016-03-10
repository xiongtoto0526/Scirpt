
#import "DownloadWorker.h"

#import "UIHelper.h"
#import "Constant.h"
#import "Server.h"
#import "DownloadHistory.h"

@interface DownloadWorker ()<NSURLConnectionDataDelegate>

// 文件句柄对象
@property (nonatomic, strong) NSFileHandle *writeHandle;

// 文件的总长度
@property (nonatomic, assign) long long totalLength;

// 当前已经写入的总大小
@property (nonatomic, assign) long long  currentLength;

// 下载进度百分比
@property (nonatomic, assign) double  progress;

@property (nonatomic, strong) NSURLConnection *connection;

// 本地home路径
@property (nonatomic, copy) NSString  *homePath;

// 下载到本地的路径
@property (nonatomic, copy) NSString  *localPath;

// 下载文件保存到本地时的文件名
@property (nonatomic, copy) NSString  *filename;

@property (nonatomic, copy) NSString  *downloadspeed;

@property (nonatomic, retain)NSDate*  lastDate;
@property (nonatomic,assign)long long lastSize;

@end


@implementation DownloadWorker


-(id)init{
    if ((self = [super init])){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.homePath =[paths firstObject];
    }
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentProgressBeforeTerminate) name:APPLICATION_WILL_TERMINATE_NOTIFICATION object:nil];
    
    return self;
}

#pragma mark - NSURLConnectionDataDelegate代理方法

/**
 *  请求失败时调用（请求超时、网络异常）
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *messageString = [error localizedDescription];
    //    NSString *moreString = [error localizedFailureReason];
    NSLog(@"下载结束，结果为失败。错误信息: %@",messageString);
    self.isFree=YES;
    [self.delegate downloadFinish:NO msg:@"无法连接到服务器，请重试。" tag:self.tag];
    [self saveCurrentProgress:DOWNLOADED_FAILED];
}



/**
 *  1.接收到服务器的响应就会进入该回调
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    if (response.expectedContentLength == -1) {
        NSLog(@" Warning!!!! file length is -1");
    }
    
    // 校验下载链接是否为ipa文件。
    if (![[response.suggestedFilename pathExtension] isEqualToString:@"ipa"]) {
        [self.connection cancel];
        self.connection = nil;
        self.isFree = YES;
        [self.delegate downloadFinish:NO msg:@"文件格式错误。" tag:self.tag];
        return;
    }
    
    
    self.filename = [NSString stringWithFormat:@"%@.ipa",self.versionid];
    //    self.homePath = [self.homePath  stringByAppendingPathComponent:@"xgtakofiles"]; // todo:该目录不可写,暂不设置子目录
    NSString* filepath = [self.homePath stringByAppendingPathComponent:self.filename];
    NSLog(@"local file path is:%@",filepath);
    self.localPath = filepath;
    
    // 若文件不存在，则创建一个空的文件到沙盒中。只有首次下载时,才会创建新文件。
    NSFileManager* mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:filepath]) {
        [mgr createFileAtPath:filepath contents:nil attributes:nil];
    }
    
    // 创建一个用来写数据的文件句柄对象
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:filepath];
    
    // 只有首次下载时，才需要刷新总大小。
    if (self.currentLength==0) {
        self.totalLength = response.expectedContentLength;
    }
}


/**
 *  2.当接收到服务器返回的实体数据时调用（这个方法可能会被调用多次）
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 移动到文件的最后面
    [self.writeHandle seekToEndOfFile];
    
    // 将数据写入沙盒
    [self.writeHandle writeData:data];
    
    // 累计写入文件的长度
    self.currentLength += data.length;
    
    // 下载进度
    double newProgress = (double)self.currentLength / self.totalLength;
    self.progress = newProgress;
    
    // 计算下载速度
    NSDate *currentDate = [NSDate date];
    if (self.lastDate==nil) {
        self.lastDate = currentDate;
    }
    if (self.lastSize == 0) {
        self.lastSize = self.currentLength;
    }
    
    if ([currentDate timeIntervalSinceDate:self.lastDate] >= 1) {
        double time = [currentDate timeIntervalSinceDate:self.lastDate];
        self.downloadspeed = [XHTUIHelper formatByteCount:(self.currentLength-self.lastSize)/time];
        self.lastDate = currentDate;
        self.lastSize = self.currentLength;
        NSLog(@"current speed is:%@/s",self.downloadspeed);
    }
    
    if (self.downloadspeed==nil) {
        self.downloadspeed = @"2k";// use 2kb/s to init speed display.
    }
    
    [self.delegate downloadingWithTotal:self.totalLength complete:self.currentLength speed:[NSString stringWithFormat:@"%@/s",self.downloadspeed] tag:self.tag];
    
}


/**
 *  3.加载完毕后调用（服务器的数据已经完全返回后）
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"download worker:下载完成。");
    
    //    [self isDevicefileExist];// 调试用
    
    // 重置状态
    self.currentLength = 0;
    self.totalLength = 0;
    
    // 关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;
    self.isFree = YES;
    
    [self.delegate downloadFinish:YES msg:@"下载成功。" tag:self.tag];
    
    NSLog(@"下载结束，结果为成功...");
    [self saveCurrentProgress:DOWNLOADED];
    
}

- (void)startWithUrl:(NSURL*) url DownloadInfo:(DownloadHistory*)info tag:(NSString*)tag delegate:(id<XHtDownLoadDelegate>)delegate {
    if (![self isDelegateAvailable:delegate]) {
        return;
    }
    
    self.delegate=delegate;
    self.tag = tag;
    self.versionid = info.download_app_version;
    self.versionname = info.download_app_version_name;
    self.password = info.download_password;
    self.isFree = NO;
    self.lastSize=0;
    self.lastDate=nil;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    DownloadHistory* hisInfo = [[DownloadHistory shareInstance] fetchWithAppid:tag];
    
    // 若之前有下载记录，则直接读取之前的进度。
    if(hisInfo!=nil){
        self.currentLength = [hisInfo.download_current_length longLongValue];
        self.totalLength = [hisInfo.download_total_length longLongValue];
    }else{
        self.currentLength = 0;
    }
    
    
    NSString* filepath = [self.homePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ipa",self.versionid]];
    // 若文件不存在，则创建一个空的文件到沙盒中。只有首次下载时,才会创建新文件。
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:filepath] && self.currentLength == 0) {
        [mgr removeItemAtPath:filepath error:nil];
    }
    
    // 请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%lld-", self.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"]; // set this field to avoid -1 return ,see more http://stackoverflow.com/questions/11136020/response-expectedcontentlength-return-1

    
    // todo:connectionWithRequest is deprecated in ios9.0, 需要改为 NSURLSession.
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

/*
 暂停
 */
-(void)pause:(NSString*)tag{
    [self.connection cancel];
    self.connection = nil;
    self.isFree = YES;
    self.tag=tag;
    
    
    [self saveCurrentProgress:PAUSED];
}


-(void)saveCurrentProgressBeforeTerminate{
    if (!self.isFree) {
        [self saveCurrentProgress:STARTED];
    }
}

// 保存当前进度，以便下次退出应用后，仍可继续。
-(void)saveCurrentProgress:(int) status{
    
    BOOL isNew = NO;
    DownloadHistory* info =  [[DownloadHistory shareInstance] fetchWithAppid:self.tag];
    if (info==nil) {
        info = [[DownloadHistory shareInstance] newWithAppid:self.tag];
        isNew = YES;
    }
    info.download_current_length = [NSString stringWithFormat:@"%qi",self.currentLength];
    info.download_total_length = [NSString stringWithFormat:@"%qi",self.totalLength];
    info.download_status = [NSString stringWithFormat:@"%d",status];
    info.download_app_version_name = self.versionname;
//    info.download_app_version = self.versionid;
    
    // 只有当app从未下载，或app下载完成之后且新的versionid和老的versionid不一样时，才需要更新versionid字段
    if ([info.download_app_version isEqualToString: @"0"] || (![self.versionid isEqualToString:info.download_app_version] && status >= DOWNLOADED)) {
        info.download_app_version = self.versionid;
    }
    
    if (status == DOWNLOADED) {
        info.download_success_flag = @"1";
    }
    
    if (isNew) {
        [[DownloadHistory shareInstance] addWithObject:info];
    }else{
        [[DownloadHistory shareInstance] updateWithAppid:self.tag object:info];
    }
}

/*
 取消
 */
- (void)stop:(NSString*)tag{
    [self.connection cancel];
    self.connection=nil;
    self.lastSize = 0;
    self.lastDate = nil;
    self.currentLength=0;
    self.isFree = YES;
    self.tag=tag;
    
    [self saveCurrentProgress:INITED];
}

-(BOOL) isDelegateAvailable:(id<XHtDownLoadDelegate>) delegate{
    BOOL isAllAvailable = YES;
    
    if(![delegate respondsToSelector:@selector(downloadingWithTotal:complete:speed:tag:)]){
        NSLog(@"Error!!! Please implement mehtod < downloadingWithTotal:complete:tag: > in <XHtDownLoadDelegate> first!");
        isAllAvailable = NO;
    }
    
    if(![delegate respondsToSelector:@selector(downloadFinish:msg:tag:)]){
        NSLog(@"Error!!! Please implement mehtod < downloadFinish:msg:tag: > in <XHtDownLoadDelegate> first!");
        isAllAvailable = NO;
    }
    return isAllAvailable;
}




@end