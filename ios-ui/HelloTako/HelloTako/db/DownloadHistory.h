
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface DownloadHistoryInfo : NSObject
@property (nonatomic,copy) NSString* currentLength;
@property (nonatomic,copy) NSString* TotalLength;
@property (nonatomic,copy) NSString* status;
@property (nonatomic,copy) NSString* versionid;
@property (nonatomic,copy) NSString* appid;
@property (nonatomic,copy) NSString* downloadSuccessFlag;
@property (nonatomic,copy) NSString* password;

@end

