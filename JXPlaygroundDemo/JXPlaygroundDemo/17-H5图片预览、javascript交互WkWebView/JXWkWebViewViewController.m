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
    
    /**！
     一.支持H5页面图片预览    二.支持H5调用OC  OC调用H5
     //给webView添加监听title和进度条
     [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
     [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
     
     //kvo监听进度条
     - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
     if ([object isKindOfClass:[JXWkWebView class]]) {
     if ([keyPath isEqualToString:@"estimatedProgress"]) {
     CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
     if (newprogress == 1) {
     self.webView.progressView.hidden = YES;
     [self.webView.progressView setProgress:0 animated:NO];
     }else {
     self.webView.progressView.hidden = NO;
     [self.webView.progressView setProgress:newprogress animated:YES];
     }
     }
     if ([keyPath isEqualToString:@"title"]) {
     if (self.webView.title.length > 10) {
     self.navigationItem.title = [self.webView.title substringToIndex:14];
     } else {
     self.navigationItem.title = self.webView.title;
     }
     }
     } else {
     [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
     }
     }
     //移除监听
     [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
     [self.webView removeObserver:self forKeyPath:@"title"];
     
     
     //js调OC时，需要让前端人员写如下js代码
     //👇 AppModel是我们所注入的对象   也就是SDWebView的jsHandlers
     window.webkit.messageHandlers.AppModel.postMessage({body: response});
     
     //对象可以注入多个，所以jsHandlers是个数组  如下代码：注入三个对象到页面中
     self.webView.jsHandlers = @[TOLOGIN,TOPAY,TOYATI];
     
     //如果注入了对象 要调用如下方法，注销handle 不然会creash
     [self.webView removejsHandlers];
     
     
     //OC调用js时，可以调用如下方法:
     - (void)callJS:(nonnull NSString *)jsMethodName;

     
     
     */
    
}


@end
