//
//  JXBanTangViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/1.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXBanTangViewController.h"
#import "UIView+Extension.h"
#import "JXBanTangHeaderView.h"
#import "JXBanTangRefreshHeader.h"
#import "JXBanTangTableViewController.h"
#import "UIButton+Size.h"



#define CATEGORY  @[@"推荐",@"原创",@"热门",@"美食",@"生活",@"设计感",@"家居",@"礼物",@"阅读",@"运动健身",@"旅行户外"]

#define NAVBARHEIGHT 64.0f

#define FONTMAX 15.0
#define FONTMIN 14.0
#define PADDING 15.0

/*! 偏移量 */
static CGFloat const kMaxOffset = 136;

@interface JXBanTangViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) JXBanTangHeaderView *jqHeaderView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

///
//滑动事件相关
///
@property (nonatomic, strong) UIScrollView *segmentScrollView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;

@property (nonatomic, strong) UIImageView *currentSelectedItemImageView;

//存放button
@property(nonatomic,strong)NSMutableArray *titleButtons;
//记录上一个button
@property (nonatomic, strong) UIButton *previousButton;
//存放控制器
@property(nonatomic,strong)NSMutableArray *controlleres;

//存放TableView
@property(nonatomic,strong)NSMutableArray *tableViews;

//记录上一个偏移量
@property (nonatomic, assign) CGFloat lastTableViewOffsetY;

@property (nonatomic, strong) UITableView *currentTableView;

@end

@implementation JXBanTangViewController

#pragma mark - lazy loading

- (UIScrollView *)bottomScrollView {
    
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _bottomScrollView.delegate = self;
        _bottomScrollView.pagingEnabled = YES;
        
        
        NSArray *colors = @[[UIColor redColor],[UIColor blueColor],[UIColor grayColor],[UIColor greenColor],[UIColor purpleColor],[UIColor orangeColor],[UIColor whiteColor],[UIColor redColor],[UIColor blueColor],[UIColor grayColor],[UIColor greenColor]];
        
        for (int i = 0; i<CATEGORY.count; i++) {
            
            JXBanTangTableViewController *jsdTableViewController = [[JXBanTangTableViewController alloc] init];
            jsdTableViewController.view.frame = CGRectMake(kScreenW * i, 0, kScreenW, kScreenH);
            
            jsdTableViewController.view.backgroundColor = colors[i];
            [self.bottomScrollView addSubview:jsdTableViewController.view];
            
            [self.controlleres addObject:jsdTableViewController];
            
            ///保存所有的tableView
            [self.tableViews addObject:jsdTableViewController.tableView];
            
            //下拉刷新动画
            JXBanTangRefreshHeader *jqRefreshHeader  = [[JXBanTangRefreshHeader alloc] initWithFrame:CGRectMake(0, BTTableHeaderViewHeight - BTRefreshHeight, kScreenW, BTRefreshHeight)];
            jqRefreshHeader.backgroundColor = [UIColor whiteColor];
            /// 赋值tableView
            jqRefreshHeader.tableView = jsdTableViewController.tableView;
            /// 监听tableView
            [jsdTableViewController.tableView.tableHeaderView addSubview:jqRefreshHeader];
            
            
            NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
            [jsdTableViewController.tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
            
        }
        
        self.currentTableView = self.tableViews[0];
        self.bottomScrollView.contentSize = CGSizeMake(self.controlleres.count * kScreenW, 0);
        
    }
    return _bottomScrollView;
}

- (UIScrollView *)segmentScrollView {
    
    if (!_segmentScrollView) {
        
        _segmentScrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, BTSDCycleScrollViewHeight, kScreenW, BTSegmentScrollViewHeight)];
        [_segmentScrollView addSubview:self.currentSelectedItemImageView];
        _segmentScrollView.showsHorizontalScrollIndicator = NO;
        _segmentScrollView.showsVerticalScrollIndicator = NO;
        _segmentScrollView.backgroundColor = [UIColor whiteColor];
        NSInteger btnoffset = 0;
        
        for (int i = 0; i<CATEGORY.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:CATEGORY[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:FONTMIN];
            CGSize size = [UIButton sizeOfLabelWithCustomMaxWidth:kScreenW systemFontSize:FONTMIN andFilledTextString:CATEGORY[i]];
            
            
            float originX =  i? PADDING*2+btnoffset:PADDING;
            
            btn.frame = CGRectMake(originX, 14, size.width, size.height);
            btnoffset = CGRectGetMaxX(btn.frame);
            
            
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [btn addTarget:self action:@selector(changeSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentScrollView addSubview:btn];
            
            [self.titleButtons addObject:btn];
            
            //contentSize 等于按钮长度叠加
            //默认选中第一个按钮
            if (i == 0) {
                
                btn.selected = YES;
                _previousButton = btn;
                
                _currentSelectedItemImageView.frame = CGRectMake(PADDING, self.segmentScrollView.frame.size.height - 2, btn.frame.size.width, 2);
            }
        }
        
        _segmentScrollView.contentSize = CGSizeMake(btnoffset+PADDING, 25);
    }
    
    return _segmentScrollView;
}

- (UIImageView *)currentSelectedItemImageView {
    if (!_currentSelectedItemImageView) {
        _currentSelectedItemImageView = [[UIImageView alloc] init];
        _currentSelectedItemImageView.image = [UIImage imageNamed:@"nar_bgbg"];
    }
    return _currentSelectedItemImageView;
}


- (SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        
        NSMutableArray *imageMutableArray = [NSMutableArray array];
        for (int i = 1; i<9; i++) {
            NSString *imageName = [NSString stringWithFormat:@"cycle_%02d.jpg",i];
            [imageMutableArray addObject:imageName];
        }
        
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, BTSDCycleScrollViewHeight) imageNamesGroup:imageMutableArray];
        
        
    }
    return _cycleScrollView;
}

- (JXBanTangHeaderView *)jqHeaderView {
    
    if (!_jqHeaderView) {
        
        _jqHeaderView = [[JXBanTangHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
        _jqHeaderView.backgroundColor = [UIColor clearColor];
        
    }
    return _jqHeaderView;
}





- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.titleButtons = [[NSMutableArray alloc] initWithCapacity:CATEGORY.count];
        self.controlleres = [[NSMutableArray alloc] initWithCapacity:CATEGORY.count];
        self.tableViews = [[NSMutableArray alloc] initWithCapacity:CATEGORY.count];
        
        [self.view addSubview:self.bottomScrollView];
        self.jqHeaderView.tableViews = [NSMutableArray arrayWithArray:self.tableViews];
        
        
        [self.view addSubview:self.cycleScrollView];
        [self.view addSubview:self.segmentScrollView];
        [self.view addSubview:self.jqHeaderView];
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"半塘首页";
}



- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

#pragma observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    
    UITableView *tableView = (UITableView *)object;
    
    
    if (!(self.currentTableView == tableView)) {
        return;
    }
    
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    
    CGFloat tableViewoffsetY = tableView.contentOffset.y;
    
    
    
    self.lastTableViewOffsetY = tableViewoffsetY;
    
    if ( tableViewoffsetY>=0 && tableViewoffsetY<=kMaxOffset) {
        
        self.segmentScrollView.frame = CGRectMake(0, BTSDCycleScrollViewHeight-tableViewoffsetY, kScreenW, BTSegmentScrollViewHeight);
        self.cycleScrollView.frame = CGRectMake(0, 0-tableViewoffsetY, kScreenW, BTSDCycleScrollViewHeight);
        
    }else if( tableViewoffsetY < 0){
        
        self.segmentScrollView.frame = CGRectMake(0, BTSDCycleScrollViewHeight, kScreenW, BTSegmentScrollViewHeight);
        self.cycleScrollView.frame = CGRectMake(0, 0, kScreenW, BTSDCycleScrollViewHeight);
        
    }else if (tableViewoffsetY > kMaxOffset){
        
        self.segmentScrollView.frame = CGRectMake(0, 64, kScreenW, BTSegmentScrollViewHeight);
        self.cycleScrollView.frame = CGRectMake(0, -kMaxOffset, kScreenW, BTSDCycleScrollViewHeight);
    }
}





#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView !=self.bottomScrollView) {
        return ;
    }
    
    int index =  scrollView.contentOffset.x/scrollView.frame.size.width;
    
    UIButton *currentButton = self.titleButtons[index];
    //     for (UIButton *button in self.titleButtons) {
    //         button.selected = NO;
    //     }
    _previousButton.selected = NO;
    currentButton.selected = YES;
    _previousButton = currentButton;
    
    
    self.currentTableView  = self.tableViews[index];
    for (UITableView *tableView in self.tableViews) {
        
        if ( self.lastTableViewOffsetY>=0 &&  self.lastTableViewOffsetY<=kMaxOffset) {
            
            tableView.contentOffset = CGPointMake(0,  self.lastTableViewOffsetY);
            
        }else if(  self.lastTableViewOffsetY < 0){
            
            tableView.contentOffset = CGPointMake(0, 0);
            
        }else if ( self.lastTableViewOffsetY > kMaxOffset){
            
            tableView.contentOffset = CGPointMake(0, kMaxOffset);
        }
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        if (index == 0) {
            
            self.currentSelectedItemImageView.frame = CGRectMake(PADDING, self.segmentScrollView.frame.size.height - 2,currentButton.frame.size.width, 2);
            
        }else{
            
            
            UIButton *preButton = self.titleButtons[index - 1];
            
            float offsetX = CGRectGetMinX(preButton.frame)-PADDING*2;
            
            [self.segmentScrollView scrollRectToVisible:CGRectMake(offsetX, 0, self.segmentScrollView.frame.size.width, self.segmentScrollView.frame.size.height) animated:YES];
            
            self.currentSelectedItemImageView.frame = CGRectMake(CGRectGetMinX(currentButton.frame), self.segmentScrollView.frame.size.height-2, currentButton.frame.size.width, 2);
        }
        
    }];
    
    
}


#pragma  mark - 选项卡点击事件

-(void)changeSelectedItem:(UIButton *)currentButton{
    
    //     for (UIButton *button in self.titleButtons) {
    //         button.selected = NO;
    //     }
    
    _previousButton.selected = NO;
    currentButton.selected = YES;
    _previousButton = currentButton;
    
    NSInteger index = [self.titleButtons indexOfObject:currentButton];
    
    self.currentTableView  = self.tableViews[index];
    for (UITableView *tableView in self.tableViews) {
        
        if ( self.lastTableViewOffsetY>=0 &&  self.lastTableViewOffsetY<=kMaxOffset) {
            
            tableView.contentOffset = CGPointMake(0,  self.lastTableViewOffsetY);
            
        }else if(self.lastTableViewOffsetY < 0){
            
            tableView.contentOffset = CGPointMake(0, 0);
            
        }else if ( self.lastTableViewOffsetY > kMaxOffset){
            
            tableView.contentOffset = CGPointMake(0, kMaxOffset);
        }
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (index == 0) {
            
            self.currentSelectedItemImageView.frame = CGRectMake(PADDING, self.segmentScrollView.frame.size.height - 2,currentButton.frame.size.width, 2);
            
        }else{
            
            
            UIButton *preButton = self.titleButtons[index - 1];
            
            float offsetX = CGRectGetMinX(preButton.frame)-PADDING*2;
            
            [self.segmentScrollView scrollRectToVisible:CGRectMake(offsetX, 0, self.segmentScrollView.frame.size.width, self.segmentScrollView.frame.size.height) animated:YES];
            
            self.currentSelectedItemImageView.frame = CGRectMake(CGRectGetMinX(currentButton.frame), self.segmentScrollView.frame.size.height-2, currentButton.frame.size.width, 2);
        }
        self.bottomScrollView.contentOffset = CGPointMake(kScreenW *index, 0);
        
    }];
}


@end
