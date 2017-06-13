//
//  APayViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "APayViewController.h"
#import "CYPasswordView.h"
#import "MBProgressHUD+MJ.h"

@interface APayViewController ()
@property (nonatomic, strong) CYPasswordView *passwordView;
@property (nonatomic, strong) UIButton *showBtn;
@end

#define kRequestTime 3.0f
#define kDelay 1.0f
static BOOL flag = NO;

@implementation APayViewController

- (UIButton *)showBtn{
    if (_showBtn == nil) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setTitle:@"支付" forState:UIControlStateNormal];
        [_showBtn setTitleColor:kRandomColorKRGBColor forState:UIControlStateNormal];
        [_showBtn addTarget:self action:@selector(showPayView) forControlEvents:UIControlEventTouchUpInside];
        _showBtn.frame = CGRectMake(150, 200, 70, 30);
        
    }
    return _showBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.showBtn];
}

- (void)dealloc {
    CYLog(@"cy =========== %@：我走了", [self class]);
}

- (void)cancel {
    CYLog(@"关闭密码框");
    [MBProgressHUD showSuccess:@"关闭密码框"];
}

- (void)forgetPWD {
    CYLog(@"忘记密码");
    [MBProgressHUD showSuccess:@"忘记密码"];
}

- (void)showPayView{
    
    WS(weakSelf);
    self.passwordView = [[CYPasswordView alloc] init];
    [self.passwordView showInView:self.view.window];
    self.passwordView.loadingText = @"提交中...";
    
    self.passwordView.cancelBlock = ^{
        [weakSelf cancel];
    };
    self.passwordView.forgetPasswordBlock = ^{
        [weakSelf forgetPWD];
    };
    
    self.passwordView.finish = ^(NSString *password) {
        [weakSelf.passwordView hidenKeyboard];
        [weakSelf.passwordView startLoading];
        CYLog(@"cy ========= 发送网络请求  pwd=%@", password);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kRequestTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            flag = !flag;
            if (flag) {
                CYLog(@"购买成功，跳转到成功页");
                [MBProgressHUD showSuccess:@"购买成功，做一些处理"];
                [weakSelf.passwordView requestComplete:YES message:@"购买成功……"];
                [weakSelf.passwordView stopLoading];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.passwordView hide];
                });
            } else {
                CYLog(@"购买失败，跳转到失败页");
                [MBProgressHUD showError:@"购买失败……"];
                [weakSelf.passwordView requestComplete:NO];
                [weakSelf.passwordView stopLoading];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.passwordView hide];
                });
                
            }
            
        });
    };
}




@end
