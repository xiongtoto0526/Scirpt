
#import "DownloadHistory.h"
#import "Constant.h"
#import "UIHelper.h"

@implementation DownloadHistory

/* appid 为每条记录的主键 */
static DownloadHistory* share = nil;

+(DownloadHistory*) shareInstance{
    @synchronized(self){
        if(share==nil){
            share=[[super alloc] init];
        }
        return share;
    }
}


// 强制返回初始化对象
-(DownloadHistory*)newWithAppid:(NSString*)appid{
    DownloadHistory* info = [DownloadHistory new];
    info = [DownloadHistory new];
    info.download_success_flag = @"0";
    info.download_current_length = @"0";
    info.download_total_length = @"0";
    info.download_success_flag = @"0";
    info.download_status = @"0";// 初始化状态
    info.download_appid = appid;
    info.download_password = @"0";
    info.download_app_version = @"0";
    return info;
}


// 查找
-(DownloadHistory*)fetchWithAppid:(NSString*)appid{
    NSDictionary* all =[XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
    NSLog(@"all dict is:%@",all);
    if(all==nil){
        NSLog(@"not record found by key:%@,will return...",DOWNLOADED_APP_INFO_KEY);
        return nil;
    }
    
    NSDictionary* d = (NSDictionary*)[all objectForKey:appid];
    if (d==nil) {
        NSLog(@"not record found by key:%@,will return...",appid);
        return nil;
    }
    DownloadHistory* info = [self initWithDictionary:d];
    return info;
}

// 全量更新，每个字段都会更新。
-(void)updateWithAppid:(NSString*)appid dict:(NSDictionary*)dict{
    NSDictionary* all =[XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
    if(all==nil){
        NSLog(@"not record found by key:%@,will return",DOWNLOADED_APP_INFO_KEY);
        return;
    }
    
    NSMutableDictionary* multdict = [[NSMutableDictionary alloc] initWithDictionary:all];
    [multdict setObject:dict forKey:appid];
    [XHTUIHelper writeNSUserDefaultsWithKey:DOWNLOADED_APP_INFO_KEY withObject:multdict];
}

// 全量更新，每个字段都会更新。
-(void)updateWithAppid:(NSString*)appid object:(DownloadHistory*)obj{
    NSDictionary* all =[XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
    if(all==nil){
        NSLog(@"not record found by key:%@,will return",DOWNLOADED_APP_INFO_KEY);
        return;
    }
    
    NSDictionary* infoDict = [all objectForKey:appid];
    if(infoDict==nil){
        NSLog(@"not record found by key:%@,will return",appid);
        return;
    }
    
    NSMutableDictionary* multdict = [[NSMutableDictionary alloc] initWithDictionary:all];
    NSDictionary* dict = [XHTUIHelper getObjectData:obj];
    [multdict setObject:dict forKey:appid];
    [XHTUIHelper writeNSUserDefaultsWithKey:DOWNLOADED_APP_INFO_KEY withObject:multdict];
}

// 更新某一个字段
-(void)updateWithAppid:(NSString*)appid key:(NSString*)key value:(id)value{
    NSDictionary* all =[XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
    if(all==nil){
        NSLog(@"not record found by key:%@,will return",DOWNLOADED_APP_INFO_KEY);
        return;
    }
    
    NSDictionary* infoDict = [all objectForKey:appid];
    if(infoDict==nil){
        NSLog(@"not record found by key:%@,will return",appid);
        return;
    }
    
    NSMutableDictionary* mltinfoDict = [[NSMutableDictionary alloc] initWithDictionary:infoDict];
    NSMutableDictionary* multdict = [[NSMutableDictionary alloc] initWithDictionary:all];
    
    [mltinfoDict setObject:value forKey:key];
    [multdict setObject:mltinfoDict forKey:appid];
    [XHTUIHelper writeNSUserDefaultsWithKey:DOWNLOADED_APP_INFO_KEY withObject:multdict];
}

-(void)updateStatusWithAppid:(NSString*)appid status:(NSString*)status{
    NSDictionary* all =[XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
    if(all==nil){
        NSLog(@"not record found by key:%@,will return",DOWNLOADED_APP_INFO_KEY);
        return;
    }
    
    NSDictionary* infoDict = [all objectForKey:appid];
    if(infoDict==nil){
        NSLog(@"not record found by key:%@,will return",appid);
        return;
    }
    NSMutableDictionary* mltinfoDict = [[NSMutableDictionary alloc] initWithDictionary:infoDict];
    NSMutableDictionary* multdict = [[NSMutableDictionary alloc] initWithDictionary:all];

    [mltinfoDict setObject:status forKey:@"download_status"];
    [multdict setObject:mltinfoDict forKey:appid];
    [XHTUIHelper writeNSUserDefaultsWithKey:DOWNLOADED_APP_INFO_KEY withObject:multdict];
}


//// 更新某一个字段
//-(void)updateProgressWithAppid:(NSString*)appid status:(NSString*)status currentlength:(NSString*)currentlength totalLength:(NSString*)totalLength{
//    
//    NSDictionary* all =[XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
//    if(all==nil){
//        NSLog(@"not record found by key:%@,will return",DOWNLOADED_APP_INFO_KEY);
//        return;
//    }
//    
//    NSDictionary* infoDict = [all objectForKey:appid];
//    if(infoDict==nil){
//        NSLog(@"not record found by key:%@,will return",appid);
//        return;
//    }
//    
//    [infoDict setValue:status forKey:@"download_status"];
//    [infoDict setValue:currentlength forKey:@"download_current_length"];
//    [infoDict setValue:totalLength forKey:@"download_total_length"];
//    [XHTUIHelper writeNSUserDefaultsWithKey:DOWNLOADED_APP_INFO_KEY withObject:all];
//}

// 删除
-(void)removeWithAppid:(NSString*)appid{
    NSDictionary* all =[XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
    if(all==nil){
        NSLog(@"not record found by key:%@,will return",DOWNLOADED_APP_INFO_KEY);
        return;
    }
    
    NSMutableDictionary* multdict = [[NSMutableDictionary alloc] initWithDictionary:all];
    [multdict removeObjectForKey:appid];
    [XHTUIHelper writeNSUserDefaultsWithKey:DOWNLOADED_APP_INFO_KEY withObject:multdict];
}

// 新增
-(void)addWithObject:(DownloadHistory*)obj{
    NSDictionary* all =[XHTUIHelper readNSUserDefaultsObjectWithkey:DOWNLOADED_APP_INFO_KEY];
    if(all==nil){
        NSLog(@"firtst created...");
        all = [NSDictionary new];
    }
    NSMutableDictionary* multdict = [[NSMutableDictionary alloc] initWithDictionary:all];

    NSDictionary* infoDict = [XHTUIHelper getObjectData:obj];
    [multdict setValue:infoDict forKey:obj.download_appid];
    [XHTUIHelper writeNSUserDefaultsWithKey:DOWNLOADED_APP_INFO_KEY withObject:multdict];
}



- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        self = [super init];
        if (self) {
            [self setValuesForKeysWithDictionary:dictionary];
        }
        return self;
    } else {
        return nil;
    }
}



@end