
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface App : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *size;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end

