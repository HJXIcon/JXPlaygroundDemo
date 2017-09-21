//
//  JXPersonDetailViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXPersonDetailViewController.h"
#import "UIImage+Image.h"

static CGFloat const K_HeaderView_Height = 200;
static CGFloat const K_TableViewHeaderView_Height = 44;
static CGFloat const oriOffsetY = -244;
static CGFloat const oriH = 200;

@interface JXPersonDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UIView *tableHeaderView;

@end

@implementation JXPersonDetailViewController

- (UIView *)tableHeaderView{
    if (_tableHeaderView == nil) {
        _tableHeaderView = [[UIView alloc]init];
        _tableHeaderView.backgroundColor = [UIColor blueColor];
    }
    return _tableHeaderView;
}

- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc]init];
        
        _bgImageView = [[UIImageView alloc]init];
        _bgImageView.image = [UIImage imageNamed:@"bg"];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        // 就是当它取值为 YES 时，剪裁超出父视图范围的子视图部分；当它取值为 NO 时，不剪裁子视图。
        _bgImageView.clipsToBounds = YES;
        [_headerView addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(_headerView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.image = [UIImage imageNamed:@"照片图库"];
        [_headerView addSubview:_iconImageView];
        
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(_headerView.mas_centerX);
            make.bottom.mas_equalTo(_headerView.mas_bottom).offset(-60);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
    }
    return _headerView;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人详情页";
    
    [self setupNav];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(K_HeaderView_Height);
    }];
    
    [self.view addSubview:self.tableHeaderView];
    
    [self.tableHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(K_TableViewHeaderView_Height);
        make.left.right.mas_equalTo(self.view).offset(0);
        make.top.mas_equalTo(self.headerView.mas_bottom);
    }];

    self.tableView.contentInset = UIEdgeInsetsMake(K_TableViewHeaderView_Height + K_HeaderView_Height, 0, 0, 0);
    //设置tableView偏移量
    self.tableView.contentOffset = CGPointMake(0, -K_TableViewHeaderView_Height - K_HeaderView_Height);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - Private Method
- (void)setupNav{
    //在导航控制器下的scollView,会默认有一个向下的滚动区域,64
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //让导航条隐藏
    //self.navigationController.navigationBar.hidden = YES;
    //导航条以及自己添加子控件是没有办法设置透明度.
    //self.navigationController.navigationBar.alpha = 0;
    
    //设置导航条背景图片,(设置背景图片必须得是UIBarMetricsDefault)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    
    //设置一张空的图片
    //如果没有指定图片(nil),会自动设置一张半透明图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = @"个人详情页";
    [titleL sizeToFit];
    titleL.alpha = 0;
    titleL.textColor = [UIColor colorWithWhite:0 alpha:0];
    
    self.navigationItem.titleView = titleL;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 23;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *const cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"section == %ld,row == %ld",indexPath.section,indexPath.row];
    
    return cell;
    
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
    
    
    //NSLog(@"%f",scrollView.contentOffset.y);
    //移动的偏移量
    CGFloat offset = scrollView.contentOffset.y - oriOffsetY;
    NSLog(@"%f",offset);
    CGFloat h = oriH - offset;
    NSLog(@"h=======%f",h);
    if (h <= 64 ) {
        h  = 64;
    }
//    self.heightconst.constant = h;
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
    }];
    
    
    [self.headerView updateConstraintsIfNeeded];
    [self.headerView layoutIfNeeded];
    
   
    
    /**!
     关于约束更新：
     
     约束更新内容简要写一些，不写详细代码了。
     
     约束更新的内容需要写入mas_updateConstraints中，如果需要立即更新的话需要两个步骤1、updateConstraintsIfNeeded 2、layoutIfNeeded
     
     如果需要产生动画效果的话，将layoutIfNeeded这个方法在[UIView animateWithDuration]中调用即可。
     
     两个方法都是在父视图中使用的。
     */

    
    //最大值.
    CGFloat alpha = offset * 1 / 136.0;
    if (alpha >= 1) {
        alpha = 0.99;
    }
    
    UILabel *titlL = (UILabel *)self.navigationItem.titleView;
    titlL.textColor = [UIColor colorWithWhite:0 alpha:alpha];
    
    UIColor *color = [UIColor colorWithWhite:1 alpha:alpha];
    //根据颜色生成一张图片
    UIImage *image = [UIImage imageWithColor:color];
    //要设置导航条的背景图片
    //如果没有指定图片(nil),会自动设置一张半透明图片
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
    
}





@end
