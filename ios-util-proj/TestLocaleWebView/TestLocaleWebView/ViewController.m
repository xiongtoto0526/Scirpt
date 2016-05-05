//
//  ViewController.m
//  TestLocaleWebView
//
//  Created by 熊海涛 on 16/5/5.
//  Copyright © 2016年 熊海涛. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    [self.webView loadRequest:request];
    
//    [self loadDocument:@"login.html"];
    [self loadHtml];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)loadHtml{
    

    NSBundle* bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"myBundle.bundle"]];
    
//    bundle = [NSBundle mainBundle];

    NSString* htmlPath = [bundle pathForResource:@"login" ofType:@"html"];
    NSLog(@"html path is:%@",htmlPath);
    
    NSString* htmlString = [[NSString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    // 注意： 此处的 baseURL 切勿弄错
    [self.webView loadHTMLString: htmlString baseURL:[NSURL fileURLWithPath:[bundle bundlePath]]];
    }


//-(void)loadDocument:(NSString *)docName
//{
//    NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
//    NSString *path=[mainBundleDirectory stringByAppendingPathComponent:docName];
//
//    NSURL *url=[NSURL fileURLWithPath:path];
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
////    self.webView.scalesPageToFit=YES;
//    [self.webView loadRequest:request];
//}

@end
