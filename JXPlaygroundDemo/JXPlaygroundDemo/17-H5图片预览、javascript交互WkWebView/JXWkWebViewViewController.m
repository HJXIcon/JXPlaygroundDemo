//
//  JXWkWebViewViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/9.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXWkWebViewViewController.h"
#import "JXWkWebView.h"

@interface JXWkWebViewViewController ()

@end

@implementation JXWkWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    JXWkWebView *webView = [[JXWkWebView alloc] initWithFrame:self.view.bounds];
//    [webView loadLocalHTMLWithFileName:@"source"];
    
    
    //  Example like this, you need set ATS allow load Yes.
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    
    [self.view addSubview:webView];
    
}


@end
