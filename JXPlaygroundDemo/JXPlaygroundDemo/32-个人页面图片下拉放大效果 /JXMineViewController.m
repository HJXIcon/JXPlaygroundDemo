//
//  JXMineViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/5.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXMineViewController.h"
#import "JXMinePageTitleView.h"

#define kMainContentWidth 200
#define kHeaderImageViewHeight 164


@interface JXMineViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  个人页面图片
 */
@property (nonatomic, strong) UIImageView * headerImageView;
/**
 *  设置视图
 */
@property (nonatomic, strong) UITableView * settingTableView;

@property (nonatomic, strong) JXMinePageTitleView *pageTitleView;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@end

@implementation JXMineViewController
#pragma mark - *** lazy load
- (UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc]init];
        _mainScrollView.frame = self.view.bounds;
        _mainScrollView.contentSize = CGSizeMake(kScreenW, kScreenH + kHeaderImageViewHeight);
        _mainScrollView.bounces = YES;
        _mainScrollView.delegate = self;
    }
    return _mainScrollView;
}
- (JXMinePageTitleView *)pageTitleView{
    if (_pageTitleView == nil) {
        _pageTitleView = [[JXMinePageTitleView alloc]init];
        _pageTitleView.titles = @[@"动态",@"文章",@"更多"];
        _pageTitleView.backgroundColor = [UIColor whiteColor];
    }
    return _pageTitleView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人页面图片下拉放大效果 ";
    
    [self initailheaderImageView];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kHeaderImageViewHeight);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    self.mainScrollView.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    [self.mainScrollView addSubview:self.pageTitleView];
    [self.pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.mainScrollView);
        make.top.mas_equalTo(self.mainScrollView).offset(kHeaderImageViewHeight);
        make.height.mas_equalTo(44);
    }];
//    [self initailsettingTableView];
}


- (void)initailheaderImageView {
    
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kHeaderImageViewHeight);
    /**!
     对于 UIImageView 而言,默认的图片展示模式是 UIViewContentModeScaleToFill (缩放填充) ,而我们所换的 UIViewContentModeScaleAspectFill 填充方式则是始终根据UIImageView的最长边为基准来等比例缩放展示图片的.当下拉改动 UIImageView 的高度长度逐渐超过宽度时,图片就又以 UIImageView 的宽度为基准来展示图片,对应的图片(提供的图片必须是宽度大于高度)的宽度由于等比例缩放显示不全,同时图片也会以中心点为准整体放大
     */
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.image = [UIImage imageNamed:@"照片图库"];
    [self.view addSubview:self.headerImageView];
}

- (void)initailsettingTableView {
    
    self.settingTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.settingTableView.backgroundColor = [UIColor clearColor];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    self.settingTableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    [self.settingTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.settingTableView];
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
    if (scrollView == self.mainScrollView) {
        CGRect newFrame = self.headerImageView.frame;
        CGFloat settingTableViewOffsetY = 64 - scrollView.contentOffset.y;
        NSLog(@"settingTableViewOffsetY == %f",settingTableViewOffsetY);
        newFrame.size.height = settingTableViewOffsetY;
        
        if (settingTableViewOffsetY < 64) {
            newFrame.size.height = 64;
        }
        self.headerImageView.frame = newFrame;
    }
    
}

@end
