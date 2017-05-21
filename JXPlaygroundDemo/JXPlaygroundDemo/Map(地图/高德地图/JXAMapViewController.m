//
//  JXAMapViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXAMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "JXCustomAnnotationViewController.h"
#import "JXPOISearchViewController.h"

@interface JXAMapViewController ()<MAMapViewDelegate>
@property(nonatomic, strong)MAMapView *mapView;

@end

@implementation JXAMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"AMap";
    
    
    [self setupAMapView];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"自定义气泡" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction1)];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"POI" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction2)];
    
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
}

- (void)rightAction2{
    [self.navigationController pushViewController:[[JXPOISearchViewController alloc]init] animated:YES];
}


- (void)rightAction1{
    [self.navigationController pushViewController:[[JXCustomAnnotationViewController alloc]init] animated:YES];
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
    
    /// 自定义定位小蓝点
    [self setupDot];
    
    // 指南针控件
    [self setupCompass];
    
    /// 比例尺控件
    [self setupScale];
    
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


/// 比例尺控件
- (void)setupScale{
    _mapView.showsScale = YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 100);  //设置比例尺位置
}

// 指南针控件
- (void)setupCompass{
    _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 100); //设置指南针位置
}

/// 自定义定位小蓝点
- (void)setupDot{
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;///精度圈是否显示，默认YES
    r.showsHeadingIndicator = NO;///是否显示方向指示(MAUserTrackingModeFollowWithHeading模式开启)。默认为YES
    r.fillColor = [UIColor redColor];///精度圈 填充颜色, 默认 kAccuracyCircleDefaultColor
    r.strokeColor = [UIColor blueColor];///精度圈 边线颜色, 默认 kAccuracyCircleDefaultColor
    r.lineWidth = 2;///精度圈 边线宽度，默认0
    r.enablePulseAnnimation = NO;///内部蓝色圆点是否使用律动效果, 默认YES
    r.locationDotBgColor = [UIColor greenColor];///定位点背景色，不设置默认白色
    r.locationDotFillColor = [UIColor grayColor];///定位点蓝色圆点颜色，不设置默认蓝色
//    r.image = [UIImage imageNamed:@"1"]; ///定位图标, 与蓝色原点互斥
    
    [self.mapView updateUserLocationRepresentation:r];
}

/*!
 实现 <MAMapViewDelegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式。 如下所示：
 */
#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout = YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        /*! 自定义标注图标: */
        annotationView.image = [UIImage imageNamed:@"11"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        
        return annotationView;
    }
    return nil;
}


/*!
 自定义标注图标:
 （1） 添加标注数据对象，可参考大头针标注的步骤（1）。
 （2） 导入标记图片文件到工程中。这里我们导入一个名为 restauant.png 的图片文件。
 （3） 在 <MAMapViewDelegate>协议的回调函数mapView:viewForAnnotation:中修改 MAAnnotationView 对应的标注图片
 
 */


@end
