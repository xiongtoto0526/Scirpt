//
//  SharedInstallManager.m
//  InstallProgress
//
//  Created by star on 14/12/21.
//  Copyright (c) 2014年 Star. All rights reserved.
//

#import "SharedInstallManager.h"

#import "LSApplicationProxy.h"
#import "LSApplicationWorkspace.h"
#import <dlfcn.h>

#import "InstallingModel.h"

@implementation SharedInstallManager


+(SharedInstallManager *)shareInstWithdelegate:(id<XHTInstallProgressDelegate>)delegate{

    static SharedInstallManager *shareInstallInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        
        if (shareInstallInstance == nil) {
            
            shareInstallInstance = [[SharedInstallManager alloc] init];
            shareInstallInstance.delegate = delegate;
        }
        
    });
    
    return shareInstallInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _installAry = [[NSMutableArray alloc] init];
        
        [self run];
        
    }
    return self;
}


- (void)run{
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateInstallList) userInfo:nil repeats:YES];
}

-(void)updateInstallList{

    void *lib = dlopen("/System/Library/Frameworks/MobileCoreServices.framework/MobileCoreServices", RTLD_LAZY);
    
    NSMutableArray* newInstallItems = [NSMutableArray new];
    NSMutableArray* currentInstallItems = [NSMutableArray new];
    NSMutableArray* finishedInstallItems = [NSMutableArray new];
    
    if (lib)
    {
        Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
        id AAURLConfiguration1 = [LSApplicationWorkspace defaultWorkspace];
        
        if (AAURLConfiguration1)
        {
            id arrApp = [AAURLConfiguration1 allApplications];
            
            for (int i=0; i<[arrApp count]; i++) {
                
                LSApplicationProxy *LSApplicationProxy = [arrApp objectAtIndex:i];
                NSString* bundleId =[LSApplicationProxy applicationIdentifier];
               
                
                NSProgress *progress = (NSProgress *)[LSApplicationProxy installProgress];
                InstallingModel *model = [self getInstallModel:bundleId];

                if (progress)
                {
                    if (model) {
                        
                        model.progress = [[progress localizedDescription] substringToIndex:2];
                        model.status  =  [NSString stringWithFormat:@"%@",[[progress userInfo] valueForKey:@"installState"]];
                        
                        // 更新安装进度
                        [currentInstallItems addObject:model];
                        
                    }else{
                        InstallingModel *model = [[InstallingModel alloc] init];
                        
                        model.bundleID = bundleId;
                        model.progress = [[progress localizedDescription] substringToIndex:2];
                        model.status  = [NSString stringWithFormat:@"%@",[[progress userInfo] valueForKey:@"installState"]];
                        
                        [_installAry addObject:model];
                        
                        // 新增安装
                        [newInstallItems addObject:model];
                        
                    }
                    
                }else{
                
                    // 新增结束
                    [_installAry removeObject:model];
                    if (model) {
                        [finishedInstallItems addObject:model];
                    }
                }
            }
        }
        
        if (lib) dlclose(lib);
    }

    if ([newInstallItems count] > 0) {
        NSLog(@"发现新增安装任务：%lu",(unsigned long)[newInstallItems count]);
        [self.delegate newInstall:newInstallItems];
    }
    if ([currentInstallItems count] > 0) {
        NSLog(@"发现新的安装任务进度有更新：%lu",(unsigned long)[currentInstallItems count]);
        [self.delegate currentInstallProgress:currentInstallItems];
    }
    if ([finishedInstallItems count] > 0) {
        NSLog(@"发现新的安装任务结束：%lu",(unsigned long)[finishedInstallItems count]);
        [self.delegate finishInstall:finishedInstallItems];
    }
    
}


-(InstallingModel *)getInstallModel:(NSString *)bunldID{

    for (InstallingModel *model in _installAry) {
        
        if ([model.bundleID isEqualToString:bunldID]) {
            
            return model;
        }
    }

    return nil;
}

@end
