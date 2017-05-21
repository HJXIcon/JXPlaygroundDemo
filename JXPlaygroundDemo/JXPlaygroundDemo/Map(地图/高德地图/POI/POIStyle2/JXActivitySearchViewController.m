//
//  JXActivitySearchViewController.m
//  FishingWorld
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 zhuya. All rights reserved.
//

#import "JXActivitySearchViewController.h"
#import "JXActivitySearchResultViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "JXPlaceAroundTableView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "JXActivitySearchViewController.h"


// 全局变量 头部视图高度
static CGFloat const kSearchbarHeight = 40;
@interface JXActivitySearchViewController ()<UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate,MAMapViewDelegate,PlaceAroundTableViewDeleagate>

/** 搜索*/
@property (strong, nonatomic) UISearchController *searchController;
@property(nonatomic, strong) JXActivitySearchResultViewController *resultVC;


@property (nonatomic, strong) MAMapView            *mapView;
@property (nonatomic, strong) AMapSearchAPI        *search;


@end

@implementation JXActivitySearchViewController
#pragma mark - lazy loading

//懒加载搜索控制器
- (UISearchController *)searchController {
    if (!_searchController) {
        
        _resultVC = [[JXActivitySearchResultViewController alloc]init];
        
        [_searchController.searchBar setBarTintColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        
        _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultVC];
        _searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, kSearchbarHeight);
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.searchBar.barTintColor = [UIColor blueColor];
        _searchController.searchBar.backgroundColor = [UIColor colorWithRed:250.0/255 green:250.0/255 blue:250.0/255 alpha:1];
        //设置代理，其遵循UISearchControllerDelegate协议
        _searchController.delegate = self;
        //设置搜索结果的更新者，其遵循UISearchResultsUpdating协议
        _searchController.searchResultsUpdater = self;
        
        _searchController.searchBar.delegate = self;
        
        
        //设置顶部搜索栏输入框的样式
        UITextField *searchField = [_searchController.searchBar valueForKey:@"_searchField"];
        searchField.layer.borderWidth = 0.5f;
        searchField.layer.borderColor = [HEXCOLOR(0xdfdfdf) CGColor];
        searchField.layer.cornerRadius = 5.f;
        
//        _searchController.searchBar.showsCancelButton = YES;
        // 修改取消按钮颜色
//        UIButton *canceLBtn = [_searchController.searchBar valueForKey:@"cancelButton"];
//        [canceLBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [canceLBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        

        /*!  将取消换为搜索  */
//        for(id sousuo in [_searchController.searchBar subviews])
//        {
//            
//            for (id zz in [sousuo subviews])
//            {
//                
//                if([zz isKindOfClass:[UIButton class]]){
//                    UIButton *btn = (UIButton *)zz;
//                    [btn setTitle:@"搜索" forState:UIControlStateNormal];
//                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                }
//                
//                
//            }
//        }
        
        
        
    }
    return _searchController;
}

#pragma mark - Life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"搜索";
    
    // 属性能决定UITabBar/UINavigationBar是否为半透明的效果
    self.navigationController.navigationBar.translucent = NO;
    [self initMapView];
    [self initSearch];

    
    [self.view addSubview:self.searchController.searchBar];
    self.searchController.searchResultsUpdater = self;
    self.definesPresentationContext = YES;

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.mapView.zoomLevel = 17;
    self.mapView.showsUserLocation = YES;
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}


#pragma mark - init
- (void)initSearch
{
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = _resultVC;
}

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.view.bounds.size.height/2)];
    self.mapView.delegate = self;
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.view addSubview:self.mapView];
    
    
}



#pragma mark - 私有方法

#pragma mark 加载关键词
- (void)loadProductsWithKeyword:(NSString *)keyWord{

    if ([keyWord isEqualToString:@" "] || keyWord.length == 0) {
        return;
    }
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
    request.keywords = keyWord;
    request.requireExtension = YES;
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
    
}


#pragma mark UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    JXLog(@"searchBar.text = %@",searchController.searchBar.text);

}


- (void)didPresentSearchController:(UISearchController *)searchController{
    
    if ([searchController.searchBar.text isEqualToString: @" "] || searchController.searchBar.text == 0) {
        return;
    }
    
    // 加载网络数据
//    [self loadProductsWithKeyword:searchController.searchBar.text];
    
}



#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    JXLog(@"end -- %@",searchBar.text);
    
    if ([searchBar.text isEqualToString:@" "] || searchBar.text.length == 0) {
        return;
    }

    
    [self loadProductsWithKeyword:searchBar.text];
}




@end
