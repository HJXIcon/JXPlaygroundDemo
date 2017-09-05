//
//  JXMineViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/5.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXMineViewController.h"

@interface JXMineViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  个人页面图片
 */
@property (nonatomic, strong) UIImageView * headerView;
/**
 *  设置视图
 */
@property (nonatomic, strong) UITableView * settingView;

@end

@implementation JXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人页面图片下拉放大效果 ";
    
    [self initailHeaderView];
    [self initailSettingView];
}


- (void)initailHeaderView {
    
    self.headerView = [[UIImageView alloc] init];
    self.headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
    /**!
     对于 UIImageView 而言,默认的图片展示模式是 UIViewContentModeScaleToFill (缩放填充) ,而我们所换的 UIViewContentModeScaleAspectFill 填充方式则是始终根据UIImageView的最长边为基准来等比例缩放展示图片的.当下拉改动 UIImageView 的高度长度逐渐超过宽度时,图片就又以 UIImageView 的宽度为基准来展示图片,对应的图片(提供的图片必须是宽度大于高度)的宽度由于等比例缩放显示不全,同时图片也会以中心点为准整体放大
     */
    self.headerView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerView.image = [UIImage imageNamed:@"照片图库"];
    [self.view addSubview:self.headerView];
}

- (void)initailSettingView {
    
    self.settingView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.settingView.backgroundColor = [UIColor clearColor];
    self.settingView.delegate = self;
    self.settingView.dataSource = self;
    self.settingView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    [self.settingView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.settingView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"index == %ld",indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGRect newFrame = self.headerView.frame;
    CGFloat settingViewOffsetY = 50 - scrollView.contentOffset.y;
    newFrame.size.height = settingViewOffsetY;
    
    if (settingViewOffsetY < 50) {
        newFrame.size.height = 50;
    }
    self.headerView.frame = newFrame;
}

@end
