/**
 *
 *                 Created by 洪峰 on 15/9/7.
 *                 Copyright (c) 2015年 洪峰. All rights reserved.
 *
 *                 新浪微博:http://weibo.com/hongfenglt
 *                 博客地址:http://blog.csdn.net/hongfengkt
 */
//                 HFDownLoad
//                 HFConnection.m
//

#import "HFConnection.h"

@interface HFConnection ()<NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UILabel *pgLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *myPregress;

/**
 *  用来写数据的文件句柄对象
 */
@property (nonatomic, strong) NSFileHandle *writeHandle;

/**
 *  文件的总长度
 */
@property (nonatomic, assign) long long totalLength;
/**
 *  当前已经写入的总大小
 */
@property (nonatomic, assign) long long  currentLength;
/**
 *  连接对象
 */
@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, copy) NSString  *localPath;

@property (nonatomic, copy) NSString  *filename;

@end

@implementation HFConnection

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"sandbox:%@",NSHomeDirectory());
    
    UIButton* bt = [UIButton new];
    bt.selected = true;
    [self btnClicked:nil];
}


- (void)download
{
    // 创建URL
    //    NSURL* url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/10/25851/jdk-8u40-macosx-x64.1427945120.dmg"];
    NSURL* url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg"];
    // 创建请求
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    // 发送请求去下载 (创建完conn对象后，会自动发起一个异步请求)
    [NSURLConnection connectionWithRequest:request delegate:self];
}


#pragma mark - NSURLConnectionDataDelegate代理方法

/**
 *  请求失败时调用（请求超时、网络异常）
 *
 *  @param error      错误原因
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}
/**
 *  1.接收到服务器的响应就会调用
 *
 *  @param response   响应
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 如果文件已经存在，不执行以下操作
    if (self.currentLength) return;
    // 文件路径
//    NSString* ceches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString* filepath = [ceches stringByAppendingPathComponent:response.suggestedFilename];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *homePath = [paths firstObject];
//    filepath = [homePath  stringByAppendingPathComponent:@"xgtakofiles"];
    NSString* filepath = [homePath stringByAppendingPathComponent:response.suggestedFilename];
    self.filename = response.suggestedFilename;
    
    NSLog(@"file path name is:%@",filepath);
    self.localPath = filepath;
    
    
    // 创建一个空的文件到沙盒中
    NSFileManager* mgr = [NSFileManager defaultManager];
    [mgr createFileAtPath:filepath contents:nil attributes:nil];

    // 创建一个用来写数据的文件句柄对象
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:filepath];
    
    // 获得文件的总大小
    self.totalLength = response.expectedContentLength;

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
    self.myPregress.progress = (double)self.currentLength / self.totalLength;
    
    self.pgLabel.text = [NSString stringWithFormat:@"当前下载进度:%f",(double)self.currentLength / self.totalLength];
}
/**
 *  3.加载完毕后调用（服务器的数据已经完全返回后）
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[[UIAlertView alloc] initWithTitle:@"下载完成" message:@"已成功下载文件" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
    
    [self isDevicefileExist];
    
    // kingsoft ok
     NSString* ser1 = @"itms-services://?action=download-manifest&url=https://doc.xgsdk.com:28443/service/app/ios/56c58a86e13823dfca398cc6/56cd25a7e1382365706e5911.plist";
    
    // local file server ok
    NSString* ser2 =@"itms-services://?action=download-manifest&url=https://doc.xgsdk.com:28443/service/app/ios/local/56c58a86e13823dfca398cc6/56cd25a7e1382365706e5911.plist";
    
    // local file failed
    NSArray* appidList = [self.localPath componentsSeparatedByString:@"/"];
    NSLog(@"appid is :%@",appidList[6]);
    NSString* ser4 = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://doc.xgsdk.com:28443/service/app/ios/file/%@/56c58a86e13823dfca398cc6/56cd25a7e1382365706e5911.plist",appidList[6]];
    
    NSLog(@"request url is:%@",ser4);
    
    [self isDevicefileExist];
    NSString* urlstr = [NSString stringWithFormat:@"http://192.168.3.18:12345/%@",self.filename];
    NSLog(@"web server file name is:%@",urlstr);
    
    
    NSString* testLocalFile = [NSString stringWithFormat:@"file:///var/mobile/Containers/Data/%@/Documents/TakoTest01_resigned.ipa",appidList[6]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ser2]];
    
    
    self.currentLength = 0;
    self.totalLength = 0;
    
    // 关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;
}

#pragma mark --按钮点击事件

- (IBAction)btnClicked:(UIButton *)sender {
    
    // 状态取反
    sender.selected = !sender.isSelected;
    // 断点续传
    // 断点下载
    
//    if (sender.selected) { // 继续（开始）下载
        // 1.URL

         NSURL* url = [NSURL URLWithString:@"http://dlsw.baidu.com/sw-search-sp/soft/9d/25765/sogou_mac_32c_V3.2.0.1437101586.dmg"];
//        url = [NSURL URLWithString:@"file:///Users/xionghaitao/Library/Developer/CoreSimulator/Devices/0F7D04C7-A015-4B90-AE50-75A6EA9D206B/data/Containers/Data/Application/F788D6E2-2CAF-4500-969D-B7D6692225BF/Documents/TakoTest01_resigned.ipa"];
       
        
        url = [NSURL URLWithString:@"http://doc.xgsdk.com:28870/static/TakoTest01_resigned.ipa"];
        
        
        // 2.请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        // 设置请求头
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-", self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        // 3.下载
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
//    } else { // 暂停
    
//        [self.connection cancel];
//        self.connection = nil;
//    }
}


-(void)isDevicefileExist{
    NSString* path1 = self.localPath;
    
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:path1]==YES) {
        NSLog(@"device File exists");
        NSLog(@"file is:%@",path1);
    }else{
        NSLog(@"device File not exists");
    }
    
}

@end
