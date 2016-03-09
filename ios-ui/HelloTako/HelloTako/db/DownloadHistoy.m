
#import "DownloadHistory.h"
#import "Constant.h"

@implementation DownloadHistory

-(DownloadHistory*)fetchWithAppid:(NSString*)appid{
    NSDictionary* dict =[XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
    NSLog(@"all dict is:%@",dict);
    
    DownloadHistoryInfo* info = [DownloadHistoryInfo new];
    NSDictionary* d = (NSDictionary*)[dict objectForKey:appid];
    info.appid = appid;
    info.downloadSuccessFlag = [d objectForKey:DOWNLOAD_SUCCESS_KEY];
    info.currentLength = [d objectForKey:DOWNLOAD_CURRENT_LENGTH_KEY];
    info.TotalLength = [d objectForKey:DOWNLOAD_TOTAL_LENGTH_KEY];
    info.password = [d objectForKey:DOWNLOAD_PASSWORD_KEY];
    info.status = [d objectForKey:DOWNLOAD_STATUS_KEY];
    info.versionid = [d objectForKey:DOWNLOAD_APP_VERSION_KEY];
    
    return info;
}

-(void)updateWithAppid:(NSString*)appid object:(DownloadHistory*)obj{
   
}

-(void)removeWithAppid:(NSString*)appid{
    
}

-(void)addWithObject:(DownloadHistory*)obj{

}



@end