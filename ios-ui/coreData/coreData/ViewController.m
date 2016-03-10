//
//  ViewController.m
//  coreData
//
//  Created by 熊海涛 on 16/3/9.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "App+CoreDataProperties.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.myAppDelegate = [UIApplication sharedApplication].delegate;
    
    // 增加
    NSManagedObject* app = [NSEntityDescription insertNewObjectForEntityForName:@"App" inManagedObjectContext:self.myAppDelegate.managedObjectContext];
    [app setValue:@"123" forKey:@"appid"];
//    [app setValue:[NSData new] forKey:@"createtime"];
    [self.myAppDelegate saveContext];
    
    
    // 查询
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"App" inManagedObjectContext:self.myAppDelegate.managedObjectContext];
    
    NSError *error = nil;
    NSArray* objects = [self.myAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
    for (id obj in objects) {
        NSLog(@"obj is:%@",obj);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
