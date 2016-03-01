
#import "DownloadWorker.h"

#import "UIHelper.h"
#import "Constant.h"

@interface DownloadWorker ()<NSURLConnectionDataDelegate>

// 文件句柄对象
@property (nonatomic, strong) NSFileHandle *writeHandle;

// 文件的总长度
@property (nonatomic, assign) long long totalLength;

// 当前已经写入的总大小
@property (nonatomic, assign) long long  currentLength;

// 下载进度百分比
@property (nonatomic, assign) long long  progress;

@property (nonatomic, strong) NSURLConnection *connection;

// 下载到本地的路径
@property (nonatomic, copy) NSString  *localPath;


// 本地home路径
@property (nonatomic, copy) NSString  *homePath;

// 下载文件的文件名
@property (nonatomic, copy) NSString  *filename;


@end



@implementation DownloadWorker


-(id)init{
    if ((self = [super init])){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.homePath =[paths firstObject];
    }
    return self;
}

#pragma mark - NSURLConnectionDataDelegate代理方法

/**
 *  请求失败时调用（请求超时、网络异常）
 *
 *  @param error      错误原因
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"下载结束，结果为失败...%@",error);
    [self.delegate downloadFinish:NO tag:self.tag];
}



/**
 *  1.接收到服务器的响应就会调用
 *
 *  @param response   响应
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   
//    self.homePath = [self.homePath  stringByAppendingPathComponent:@"xgtakofiles"]; // todo:该目录不可写
    NSString* filepath = [self.homePath stringByAppendingPathComponent:response.suggestedFilename];
    self.filename = response.suggestedFilename;
    
    NSLog(@"local file path is:%@",filepath);
    self.localPath = filepath;
    
    // 若文件不存在，则创建一个空的文件到沙盒中
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

    
    NSLog(@"current length is:%qi",self.currentLength);
    NSLog(@"total length is:%qi",self.totalLength);
    
}


/**
 *  2.当接收到服务器返回的实体数据时调用（具体内容，这个方法可能会被调用多次）
 *
 *  @param data       这次返回的数据
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
    self.progress = (double)self.currentLength / self.totalLength;
    NSLog(@"当前下载进度:%lld",self.progress);
    [self.delegate downloadingWithTotal:self.totalLength complete:self.currentLength tag:self.tag];
}


/**
 *  3.加载完毕后调用（服务器的数据已经完全返回后）
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"下载完成。");
    [self isDevicefileExist];
    
    // local file server ok
    NSString* itermServiceUrl =@"itms-services://?action=download-manifest&url=https://doc.xgsdk.com:28443/service/app/ios/local/56c58a86e13823dfca398cc6/56cd25a7e1382365706e5911.plist";

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itermServiceUrl]];
    
    self.currentLength = 0;
    self.totalLength = 0;
    
    // 关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;
    self.isFree = YES;
    
    [self.delegate downloadFinish:YES tag:self.tag];
    
    
    NSLog(@"下载结束，结果为成功...");
    
}

/*
 启动
 */
- (void)startWithUrl:(NSURL*) url delegate:(id<XHtDownLoadDelegate>)delegate tag:(NSString*)tag{
    
    if (![self isDelegateAvailable:delegate]) {
        return;
    }
    
    self.delegate=delegate;
    self.tag = tag;
    self.isFree = NO;
    
    // 1.待下载url
    url = [NSURL URLWithString:@"http://doc.xgsdk.com:28870/static/TakoTest01_resigned.ipa"];
    url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg"];
    url=[NSURL URLWithString: @"http://www.haima.me/Download.ashx?t=1&c=000000036&r=0.7960992017760873"];
    url = [NSURL URLWithString: @"http://qa.tako.im:28870/m6g3"];

    
    // 2.请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 若之前有下载记录，则直接读取之前的进度。
    if([XHTUIHelper readNSUserDefaultsObjectWithkey:self.tag]!=nil){
        NSDictionary* t = (NSDictionary*)[XHTUIHelper readNSUserDefaultsObjectWithkey:self.tag];
        self.currentLength = [(NSString*)[t objectForKey:CURRENT_LENGTH_KEY] longLongValue];
        self.totalLength = [(NSString*)[t objectForKey:TOTAL_LENGTH_KEY] longLongValue];
    }else{
        self.currentLength = 0;
    }
    
    // 请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%lld-", self.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
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
    
    
    [self saveCurrentProgress];
}

// 保存当前进度，以便下次退出应用后，仍可继续。
-(void)saveCurrentProgress{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    NSString* currentLength = [NSString stringWithFormat:@"%qi",self.currentLength];
    NSString* totalLength = [NSString stringWithFormat:@"%qi",self.totalLength];
    [dict setObject:currentLength forKey:CURRENT_LENGTH_KEY];
    [dict setObject:totalLength forKey:TOTAL_LENGTH_KEY];
    [XHTUIHelper writeNSUserDefaultsWithKey:self.tag withObject:dict];
}

/*
 取消
 */
- (void)stop:(NSString*)tag{
    [self.connection cancel];
    self.connection=nil;
    self.currentLength=0;
    self.isFree = YES;
    self.tag=tag;
    
    [self saveCurrentProgress];
}

-(BOOL) isDelegateAvailable:(id<XHtDownLoadDelegate>) delegate{
    BOOL isAllAvailable = YES;
    
    if(![delegate respondsToSelector:@selector(downloadingWithTotal:complete:tag:)]){
        NSLog(@"Error!!! Please implement mehtod < downloadingWithTotal:complete: > in <XHtDownLoadDelegate> first!");
        isAllAvailable = NO;
    }
    
    if(![delegate respondsToSelector:@selector(downloadFinish:tag:)]){
        NSLog(@"Error!!! Please implement mehtod < downloadFinish: > in <XHtDownLoadDelegate> first!");
        isAllAvailable = NO;
    }
    return isAllAvailable;
}



-(BOOL)isfileExist:(NSString*)file{
    NSFileManager* mgr = [NSFileManager defaultManager];
    return [mgr fileExistsAtPath:file];
}


// t:调试用
-(void)isDevicefileExist{
    NSString* path = self.localPath;
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:path]==YES) {
        NSLog(@"device File exists");
        NSLog(@"file is:%@",path);
    }else{
        NSLog(@"device File not exists");
    }
    
}



@end