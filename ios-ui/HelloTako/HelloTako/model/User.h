
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface TakoUser : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *createTime;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end

