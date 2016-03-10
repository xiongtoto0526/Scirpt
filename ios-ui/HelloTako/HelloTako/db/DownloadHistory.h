
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 当前db方式：直接访问 userdefault

@interface DownloadHistory : NSObject
@property (nonatomic,copy) NSString* download_current_length;
@property (nonatomic,copy) NSString* download_total_length;
@property (nonatomic,copy) NSString* download_status;
@property (nonatomic,copy) NSString* download_app_version;
@property (nonatomic,copy) NSString* download_app_version_name;
@property (nonatomic,copy) NSString* download_appid;
@property (nonatomic,copy) NSString* download_success_flag;
@property (nonatomic,copy) NSString* download_password;

-(DownloadHistory*)fetchWithAppid:(NSString*)appid;

-(DownloadHistory*)newWithAppid:(NSString*)appid;
    
-(void)updateWithAppid:(NSString*)appid dict:(DownloadHistory*)dict;
-(void)updateWithAppid:(NSString*)appid object:(DownloadHistory*)obj;
-(void)updateWithAppid:(NSString*)appid key:(NSString*)key value:(id)value;

-(void)updateStatusWithAppid:(NSString*)appid status:(NSString*)status;

-(void)removeWithAppid:(NSString*)appid;
-(void)addWithObject:(DownloadHistory*)obj;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+(DownloadHistory*)shareInstance;

@end
