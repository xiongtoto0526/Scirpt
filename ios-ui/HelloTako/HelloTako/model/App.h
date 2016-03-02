
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TakoApp : NSObject
@property (nonatomic,copy) NSString *appname;
@property (nonatomic,copy) NSString *appid;
@property (nonatomic, copy) NSString *version;//appversion 1.0.1
@property (nonatomic, copy) NSString *versionId;//appversionid 34343435ssds55
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *uri;
@property (nonatomic, copy) NSString *packagename;
@property (nonatomic, copy) NSString *logourl;
@property (nonatomic, copy) NSString *firstcreated;
@property (nonatomic, copy) NSString *password;


@property (nonatomic) NSArray* propertykeys;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end

