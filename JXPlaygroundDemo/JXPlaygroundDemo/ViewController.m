//
//  ViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoaViewController.h"
#import "JXAMapViewController.h"
#import "GCDBaseViewController.h"
#import "FDTemplateViewController.h"
#import "NSThreadViewController.h"
#import "TestZFPlayerViewController.h"
#import "JSBridgeVC.h"
#import "PicEditViewController.h"
#import "TestAVPlayerViewController.h"
#import "JXBanTangViewController.h"
#import "NotificationViewController.h"
#import "SwipeCardViewController.h"
#import "JXSwipeAbleTestViewController.h"
#import "JXPullMenuTestViewController.h"
#import "JXWaveProgressViewController.h"
#import "JXImageCollectionViewController.h"
#import "JXRotateInOutAttributesAnimator.h"
#import "FlowLayoutTableViewController.h"
#import "JXWkWebViewViewController.h"
#import "JXMainSDKTableViewController.h"
#import "APayViewController.h"
#import "JXTransitionTableViewController.h"
#import "MPBlankPageViewController.h"
#import "MPAdaptationFontViewController.h"
#import "JXLazyScrollViewController.h"
#import "JXAdvertiseViewController.h"
#import "JXMenuHoverTableViewController.h"
#import "JXPopupViewController.h"
#import "XHWebImageAutoSizeExampleViewController.h"
#import "JXTablePlaceHolderViewController.h"
#import "PermanentThreadViewController.h"
#import "LocationViewController.h"
#import "ButtonRepeatViewController.h"
#import "JXMineViewController.h"
#import <JPFPSStatus.h>

@interface ViewController ()

@property(nonatomic, strong) NSArray *dataSource;
@end

@implementation ViewController

- (NSArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = @[
                        @"ReactiveCocoa练习",
                        @"高德地图",
                        @"GCD基础篇",
                        @"FDTemplateLayoutCell测试",
                        @"NSThread",
                        @"AVPlayer视频播放ZFPlayer",
                        @"WebViewJavascriptBridge测试",
                        @"图片添加水印",
                        @"仿半塘首页效果",
                        @"本地推送",
                        @"11-卡片效果",
                        @"12-卡片效果2-支持自定义显示View",
                        @"13-下拉菜单JXPullMenu",
                        @"14-JXWaveProgressView",
                        @"15-JXAnimatedCollectionViewLayout",
                        @"16-自定义UICollectionViewFlowLayout",
                        @"17-H5图片预览、javascript交互WkWebView",
                        @"18-第三方SDK",
                        @"19-模仿支付宝输入支付密码",
                        @"20-自定义转场",
                        @"21-空白页提示",
                        @"22-字体适配机型",
                        @"23-可复用滚动子视图",
                        @"24-启动广告",
                        @"25-下拉菜单悬浮",
                        @"26-弹出视图",
                        @"27-XHWebImageAutoSizeExampleViewController",
                        @"28-tableView无数据占位图",
                        @"29-开永久线程",
                        @"30-系统定位封装",
                        @"31-重复点击button",
                        @"32-个人页面图片下拉放大效果"
                        ];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
#if defined(DEBUG) || defined(_DEBUG)
    [[JPFPSStatus sharedInstance]open];
#endif
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    float value = [NSObject makeCaculators:^(JXCaculatorMaker *maker) {
        maker.add(1).add(2).add(3).add(4);
    }];
    
    NSLog(@"value === %f",value);
    
    
    JXCaculator *caculator = [[JXCaculator alloc]init];
    
    BOOL isEqule = [[[caculator caculator:^float(float result) {
        
        result += 2;
        result *= 5;
        
        return result;
    }] equle:^BOOL(float result) {
        
        return result == 11;
        
    }] isEqule];
    
    
    NSLog(@"isEqule == %d",isEqule);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger index = indexPath.row;
    
    UIViewController *vc;
    switch (index) {
        case 0:
            vc = [[ReactiveCocoaViewController alloc]init];
            break;
            
        case 1:
            vc = [[JXAMapViewController alloc]init];
            break;
            
        case 2:
            vc = [[GCDBaseViewController alloc]init];
            break;
            
        case 3:
            vc = [[FDTemplateViewController alloc]init];
            break;
            
        case 4:
            vc = [[NSThreadViewController alloc]init];
            break;

        case 5:
            // TestZFPlayerViewController
            // TestAVPlayerViewController
            vc = [[TestZFPlayerViewController alloc]init];
            break;
            
        case 6:
            vc = [[JSBridgeVC alloc]init];
            break;
            
        case 7:
            vc = [[PicEditViewController alloc]init];
            break;
          
        case 8:
            vc = [[JXBanTangViewController alloc]init];
            break;
            
        case 9:
            vc = [[NotificationViewController alloc]init];
            break;
            
        case 10:
            vc = [[SwipeCardViewController alloc]init];
            break;
            
        case 11:
            vc = [[JXSwipeAbleTestViewController alloc]init];
            break;
            
        case 12:
            vc = [[JXPullMenuTestViewController alloc]init];
            break;
            
            
        case 13:
            vc = [[JXWaveProgressViewController alloc]init];
            break;
            
            
        case 14:{
            vc = [[JXImageCollectionViewController alloc]init];
            JXRotateInOutAttributesAnimator *animator = [[JXRotateInOutAttributesAnimator alloc]init];
            
            JXImageCollectionViewController *C =(JXImageCollectionViewController *)vc;
            C.animator = animator;
            
            
            vc = C;
        }
            break;
            
            
        case 15:
            vc = [[FlowLayoutTableViewController alloc]init];
            break;
            
           
        case 16:
            vc = [[JXWkWebViewViewController alloc]init];
            break;
            
        case 17:
            vc = [[JXMainSDKTableViewController alloc]init];
            break;
            
        case 18:
            vc = [[APayViewController alloc]init];
            break;
            
        case 19:
            vc = [[JXTransitionTableViewController alloc]init];
            break;
            
        case 20:
            vc = [[MPBlankPageViewController alloc]init];
            break;
            
        case 21:
            vc = [[MPAdaptationFontViewController alloc]init];
            break;
            
        case 22:
            vc = [[JXLazyScrollViewController alloc]init];
            break;
            
        case 23:
            vc = [[JXAdvertiseViewController alloc]init];
            break;
            
        case 24:
            vc = [[JXMenuHoverTableViewController alloc]init];
            break;
            
        case 25:
            vc = [[JXPopupViewController alloc]init];
            break;
            
        case 26:
            vc = [[XHWebImageAutoSizeExampleViewController alloc]init];
            break;
            
        case 27:
            vc = [[JXTablePlaceHolderViewController alloc]init];
            break;
            
        case 28:
            vc = [[PermanentThreadViewController alloc]init];
            break;
            
        case 29:
            vc = [[LocationViewController alloc]init];
            break;
            
        case 30:
            vc = [[ButtonRepeatViewController alloc]init];
            break;
            
        case 31:
            vc = [[JXMineViewController alloc]init];
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
