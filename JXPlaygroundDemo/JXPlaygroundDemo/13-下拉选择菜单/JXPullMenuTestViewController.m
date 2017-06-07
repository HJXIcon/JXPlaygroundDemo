//
//  JXPullMenuTestViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPullMenuTestViewController.h"
#import "JXPullMenuView.h"

@interface JXPullMenuTestViewController ()

@end

@implementation JXPullMenuTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"下拉菜单";
    
    // 发布区域
    NSArray *titlesArr = @[@"全国发布",@"省级发布",@"地市发布"];
    NSArray *subTitlesArr = @[
                              @"活动栏目，全国和所在省级及各个地市选项栏有提示，首页有主题弹幕，粉丝有提示。平台提取交易额8%发福利",
                              @"活动栏目，所在全省和各地市选项栏有提示，粉丝有提示。平台提取交易额5%发福利",
                              @"活动栏目，所在地市选项栏有提示，粉丝有提示。平台提取交易额3%发福利"];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        JXPullMenuModel *model = [[JXPullMenuModel alloc]init];
        model.title = titlesArr[i];
        model.subTitle = subTitlesArr[i];
        [tmpArray addObject:model];
        
    }
    
    
    
    JXPullMenuView *pullMenuView = [[JXPullMenuView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 44) Data:tmpArray leftText:@"发布区域"];

    [pullMenuView setValueChangeBlock:^(JXPullMenuModel *model, NSInteger index){
        
        JXLog(@"index == %ld model == %@",index,model);
        
    }];
    [self.view addSubview:pullMenuView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
