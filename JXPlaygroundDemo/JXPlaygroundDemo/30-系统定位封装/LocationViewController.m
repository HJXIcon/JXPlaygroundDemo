//
//  LocationViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/8/1.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//
/**!
 定位使用要使用" CoreLocation "框架步骤:
 1.首先创建一个"强引用"的位置管理器CLLocationManager
 2.设置位置管理器的代理
 3.请求用户授权（iOS8后方法）
 
 >设置方法requestWhenInUseAuthorization    或requestAlwaysAuthorization
 
 >配置plist文件 NSLocationWhenInUseUsageDescription  或  NSLocationAlwaysUsageDescription
 
 >注意1对1对应
 
 4.开启定位
 
 startUpdatingLocation  对应的有停止定位stopUpdatingLocation
 5.实现didUpdateLocations代理方法
 
 >代理方法一直调用,会非常耗电。除非特殊需求（如导航）,可以使用stopUpdatingLocation停止定位，实现一次定位
 
 >除了停止定位，还可以设置管理器的distanceFilter,当用户改变位置一定值后才会调用。（如后面跟50，即改变50米后调用一次代理方法）-->持续定位
 
 >desiredAccuracy-->定位精度-->将周围一定值的范围看作一个地点
 
 比较两点之间的距离使用CLLocation的distanceFromLocation方法--  注意计算出来的是直线距离
 
 iOS9新特性-->后台定位-->allowsBackgroundLocationUpdates
 
 >当用户授权为使用期间时，可以设置这个属性为YES，在plist中添加"Required background modes"  在字典中添加值"App registers for location updates".
 
 链接：http://www.jianshu.com/p/217f041eeb24

 
 
 
 */

#import "LocationViewController.h"
#import "JXLocationTool.h"
@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"定位";
    
    [[JXLocationTool shareInstance]getCurrentCor:@"" block:^(JXLocationModel *model) {
        
        
    } error:^(NSError *error) {
        
    }];
    
    
    [[JXLocationTool shareInstance] getCurrentLocations:^(JXLocationModel *model) {
        
        NSLog(@"lat == %f, lon == %f", model.latitude,model.longitude);
        
    } isIPOrientation:NO error:^(NSError *error) {
        
    }];
    
   
    
    [[JXLocationTool shareInstance]getCurrentAddress:^(JXLocationModel *model) {
        NSLog(@"lat == %f, lon == %f", model.latitude,model.longitude);
        NSLog(@"country == %@",model.country);
        NSLog(@"city == %@",model.city);
        NSLog(@"name == %@",model.name);
        
    } error:^(NSError *error) {
        
    }];
    
    
    [[JXLocationTool shareInstance]getLocAddress:@"23.081483" withLon:@"114.434219" address:^(JXLocationModel *model) {
        
        NSLog(@"lat == %f, lon == %f", model.latitude,model.longitude);
        NSLog(@"country == %@",model.country);
        NSLog(@"city == %@",model.city);
        NSLog(@"name == %@",model.name);
        
    } error:^(NSError *error) {
        
    }];

}



@end
