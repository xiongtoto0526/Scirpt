
#import "App.h"
#import <objc/runtime.h>
#import <zlib.h>


@implementation TakoApp

-(id)init{
    if((self = [super init])){
        self.propertykeys = [self getObjectKeys:self];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSNull class]]) {
        return;
    }
  
    // refactor: 此处需要server端增加字段，以简化解析。
    if ([key isEqualToString:@"releaseversion"]) {
        
        NSString* versionName = [(NSDictionary*)[(NSDictionary*)value objectForKey:@"package"] objectForKey:@"version"];
        [super setValue:versionName forKey:@"version"];
        
         NSNumber* size = [(NSDictionary*)[(NSDictionary*)value objectForKey:@"package"] objectForKey:@"size"];
        double sizeM = (double)((double)[size longLongValue]/1024)/1024;
        NSString* v = [NSString stringWithFormat:@"%.1f M",sizeM];
        [super setValue:v forKey:@"size"];
        
        NSString* versionId = (NSString*)[(NSDictionary*)value objectForKey:@"id"];
        [super setValue:versionId forKey:@"versionId"];
        return;
    }
   
    
    // 截取到日
    if ([key isEqualToString:@"firstcreated"]) {
        NSString* t = [(NSString*)value substringToIndex:10];
        [super setValue:t forKey:key];
        return;
    }
    
    // appid敏感字符处理
    if ([key isEqualToString:@"id"]) {
        [super setValue:value forKey:@"appid"];
        return;
    }
    
    if (![self.propertykeys containsObject:key]) {
        return;
    }
    
    [super setValue:value forKey:key];
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


- (NSMutableArray*)getObjectKeys:(id)obj
{
    NSMutableArray* keys = [NSMutableArray new];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        [keys addObject:propName];
    }
    return keys;
}

@end