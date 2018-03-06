//
//  JXSupspensionViewController.m
//  JXSuspension
//
//  Created by HJXICon on 2018/3/6.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXSupspensionViewController.h"
#import "JXSuspension.h"

@interface JXSupspensionViewController ()
@property (nonatomic, weak) JXSuspension *fWin;
@end

@implementation JXSupspensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    JXSuspension *fWin = [[JXSuspension alloc] init];
    fWin.windowOriginCenter = CGPointMake(25, self.view.center.y);
    _fWin = fWin;
    fWin.windowSize = CGSizeMake(40, 40);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_fWin removeFromApplication];
}


@end
