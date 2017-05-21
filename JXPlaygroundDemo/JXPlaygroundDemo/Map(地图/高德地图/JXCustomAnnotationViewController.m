//
//  JXCustomAnnotationViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXCustomAnnotationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "JXCustomAnnotationView.h"


@interface JXCustomAnnotationViewController ()<MAMapViewDelegate>

@property(nonatomic, strong)MAMapView *mapView;

@end

@implementation JXCustomAnnotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"自定义气泡";
     [self setupAMapView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    /// 添加默认样式点标记
    [self addPointAnnotation];
}


/// 添加默认样式点标记
- (void)addPointAnnotation{
    
    /*!
     提供的大头针标注MAPinAnnotationView，通过它可以设置大头针颜色、是否显示动画、是否支持长按后拖拽大头针改变坐标等。在地图上添加大头针标注的步骤如下：
     （1） 修改ViewController.m文件，在viewDidAppear方法中添加如下所示代码添加标注数据对象
     
     （2） 实现 <MAMapViewDelegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式。 如下所示
     
     */
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(23.078312, 114.422679);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    
    [_mapView addAnnotation:pointAnnotation];
}


- (void)setupAMapView{
    
    //初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
}


#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"CustomAnnotationView";
        JXCustomAnnotationView *annotationView = (JXCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[JXCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"food"];
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}



@end
