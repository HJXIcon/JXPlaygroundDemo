//
//  JXWkWebView.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/9.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXWkWebView.h"
#import <Foundation/Foundation.h>
#import "SDPhotoBrowserd.h"
/**!
 WKWebView(一) API详解及功能介绍:
 http://blog.csdn.net/u011205774/article/details/53396755
 
 WKWebView特性及使用:
 https://mp.weixin.qq.com/s?__biz=MzIzMzA4NjA5Mw==&mid=400327803&idx=1&sn=2a09fa94dd605a9f03bbc16f998e5717#rd
 */

@interface JXWkWebView ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKUserScript *userScript;
@end

@implementation JXWkWebView{
    NSString *_imgSrc;
}

#pragma mark - lazy load
- (WKUserScript *)userScript {
    if (!_userScript) {
        static  NSString * const jsGetImages =
        @"function getImages(){\
        var objs = document.getElementsByTagName(\"img\");\
        var imgScr = '';\
        for(var i=0;i<objs.length;i++){\
        imgScr = imgScr + objs[i].src + '+';\
        };\
        return imgScr;\
        };function registerImageClickAction(){\
        var imgs=document.getElementsByTagName('img');\
        var length=imgs.length;\
        for(var i=0;i<length;i++){\
        img=imgs[i];\
        img.onclick=function(){\
        window.location.href='image-preview:'+this.src}\
        }\
        }";
        
        /**!
         
         Source:
         injectionTime: WKUserScriptInjectionTimeAtDocumentStart --> // 在载入时就添加JS
         forMainFrameOnly: --> // 只添加到mainFrame中
         */
        
        _userScript = [[WKUserScript alloc] initWithSource:jsGetImages injectionTime:WKUserScriptInjectionTimeAtDocumentEnd  forMainFrameOnly:YES];
    }
    return _userScript;
}


#pragma mark - init
- (instancetype)initWithURLString:(NSString *)urlString {
    self = [super init];
    [self setDefaultValue];
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setDefaultValue];
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    WKWebViewConfiguration *configer = [[WKWebViewConfiguration alloc] init];
    // 要通过JS与webview内容交互，就需要到WKUserContentController这个类
    configer.userContentController = [[WKUserContentController alloc] init];
    
    // 添加WKUserScript对象
    // 添加一个JS到HTML中，这样就可以直接在JS中调用我们添加的JS方法
    [configer.userContentController addUserScript:self.userScript];
    
    /// Webview的偏好设置
    configer.preferences = [[WKPreferences alloc] init];
    // 指示是否启用JavaScript 默认YES
    configer.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，JavaScript能否自动通过窗口打开
    configer.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    configer.allowsInlineMediaPlayback = YES;
    self = [super initWithFrame:frame configuration:configer];
    [self setDefaultValue];
    return self;
}

- (void)setDefaultValue {
    _displayHTML = NO;
    _displayCookies = NO;
    _displayURL = YES;
    self.UIDelegate = self;
    self.navigationDelegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
}



#pragma mark - Public Method
// 加载本地HTML页面
- (void)loadLocalHTMLWithFileName:(nonnull NSString *)htmlName {
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:htmlName
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
    [self loadHTMLString:htmlCont baseURL:baseURL];
}


#pragma mark - setter
- (void)setJsHandlers:(NSArray<NSString *> *)jsHandlers {
    _jsHandlers = jsHandlers;
    for (NSString *handlerName in jsHandlers) {
        [self.configuration.userContentController addScriptMessageHandler:self name:handlerName];
    }
}


#pragma mark - js调用原生方法 可在此方法中获得传递回来的参数
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if(self.webDelegate !=nil && [self.webDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]){
        [self.webDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

#pragma mark - 检查cookie及页面HTML元素
//页面加载完成后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //获取图片数组（手动调用JS代码）
    [webView evaluateJavaScript:@"getImages()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        /**!
         componentsSeparatedByString
         两种情景
         1. 没有分割符也生成一个数组，元素就是整个字符串本身，那你就需要判断“”这种字符串。
         2. 分割的元素如果是相同的字符串，指向的是同一个对象。
         */
        
        _imgSrcArray = [NSMutableArray arrayWithArray:[result componentsSeparatedByString:@"+"]];
        if (_imgSrcArray.count >= 2) {
            [_imgSrcArray removeLastObject];
        }
        NSLog(@"_imgSrcArray == %@",_imgSrcArray);
    }];
    
    [webView evaluateJavaScript:@"registerImageClickAction();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {}];
    
    if (_displayCookies) {
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [cookieJar cookies]) {
            NSLog(@"cookie == %@", cookie);
        }
    }
    if (_displayHTML) {
        NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
        [webView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id _Nullable HTMLsource, NSError * _Nullable error) {
            NSLog(@"HTMLsource == %@",HTMLsource);
        }];
    }
    
    if (![self.webDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        return;
    }
    
    if(self.webDelegate !=nil ){
        [self.webDelegate webView:webView didFinishNavigation:navigation];
    }
}


#pragma mark - 页面开始加载就调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (self.webDelegate != nil && [self.webDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [self.webDelegate webView:webView didStartProvisionalNavigation:navigation];
    }
}

#pragma mark - 导航每次跳转调用跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //预览图片
    if ([navigationAction.request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [navigationAction.request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _imgSrc = path;
        
        // 预览图片
        [self previewPicture];
    }
    if (_displayURL) {
        NSLog(@"navigationAction.request.URL.absoluteString == %@",navigationAction.request.URL.absoluteString);
        if (self.webDelegate != nil && [self.webDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
            [self.webDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark - 移除jsHandler
- (void)removejsHandlers {
    NSAssert(_jsHandlers, @"未找到jsHandler!无需移除");
    if (_jsHandlers) {
        for (NSString *handlerName in _jsHandlers) {
            [self.configuration.userContentController removeScriptMessageHandlerForName:handlerName];
        }
    }
}


#pragma mark - 进度条
- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        _progressView.tintColor = [UIColor redColor];
        _progressView.trackTintColor = [UIColor whiteColor];
        [self addSubview:_progressView];
    }
    return _progressView;
}

#pragma mark - 清除cookie
- (void)removeCookies {
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                     completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                         for (WKWebsiteDataRecord *record  in records) {
                             [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                       forDataRecords:@[record]
                                                                    completionHandler:^{
                                                                        NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                    }];
                         }
                     }];
}

- (void)removeCookieWithHostName:(NSString *)hostName {
    WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
    [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                     completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                         for (WKWebsiteDataRecord *record  in records) {
                             if ( [record.displayName containsString:hostName]) {
                                 [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:record.dataTypes
                                                                          forDataRecords:@[record]
                                                                       completionHandler:^{
                                                                           NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                       }];
                             }
                         }
                     }];
}

- (void)callJavaScript:(NSString *)jsMethodName {
    [self callJavaScript:jsMethodName handler:nil];
}

- (void)callJavaScript:(NSString *)jsMethodName handler:(void (^)(id _Nullable))handler {
    
    NSLog(@"call js:%@",jsMethodName);
    [self evaluateJavaScript:jsMethodName completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (handler) {
            handler(response);
        }
    }];
}
- (void)dealloc {
    [self removeCookies];
}


// 预览图片
- (void)previewPicture {
    NSInteger currentIndex = 0;
    for (NSInteger i = 0; i < self.imgSrcArray.count; i++) {
        NSString *path = self.imgSrcArray[i];
        if ([path isEqualToString:_imgSrc]) {
            currentIndex = i;
        }
    }
    SDPhotoBrowserd *browser = [[SDPhotoBrowserd alloc] init];
    browser.imageCount = self.imgSrcArray.count; // 图片总数
    browser.currentImageIndex = currentIndex;
    browser.sourceImagesContainerView = self.superview; // 原图的父控件
    browser.delegate = self;
    [browser show];
}

//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
//    UIImage *img = [UIImage createImageWithColor:[UIColor colorWithHexString:ThemeColor alpha:0.5]];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
//    imgView.frame = CGRectMake(0, 0, ScreenWidth, 200);
//    imgView.center = self.center;
//    return imgView.image;
//}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowserd *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    return [NSURL URLWithString:self.imgSrcArray[index]];
    
}




@end
