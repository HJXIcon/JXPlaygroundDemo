//
//  JXLocationTool.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/8/1.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXLocationTool.h"
#import "JXLocationHelper.h"


@interface JXLocationTool ()<CLLocationManagerDelegate>{
    
    CLLocationManager * locationManager;
    void (^sucBlock)(JXLocationModel *model);
    void (^errorBlock)(NSError *error);
    
    //判断是否需要IP定位
    BOOL isIP;
    
    NSString *IP; // ip地址
    NSString *AK;
}


@end
@implementation JXLocationTool

+ (JXLocationTool *)shareInstance{
    static JXLocationTool *tool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[JXLocationTool alloc]init];
    });
    return tool;
}

/**
 GPS定位获取当前位置，若失败可调用IP定位获取位置,位置字典key为lat(纬度)和long(经度);
 */
- (void)getCurrentLocations:(void(^)(JXLocationModel *model))success isIPOrientation:(BOOL)orientation error:(void(^)(NSError  *error))errors{
    isIP = orientation;
    
    locationManager = [[CLLocationManager alloc]init];
    
    //定位精度(默认最好)
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if (self.distance ) {
        locationManager.desiredAccuracy = [self getDesiredAccuracy];
    }
    
    //定位更新频率(默认距离最大)
    [locationManager setDistanceFilter:CLLocationDistanceMax];
    if (self.distanceFilter) {
        [locationManager setDistanceFilter:self.distanceFilter];
    }
    
    //必须添加此判断，否则在iOS7上会crash
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
#ifdef __IPHONE_8_0
        [locationManager requestWhenInUseAuthorization];
#endif
    }
    
    locationManager.delegate = self;
    
    //成功
    sucBlock = ^(JXLocationModel *model){
        success(model);
    };
    
    //失败
    errorBlock = ^(NSError *error){
        errors(error);
    };
    
    //开启定位
    [locationManager startUpdatingLocation];
    
}



- (CLLocationAccuracy)getDesiredAccuracy{
    CLLocationAccuracy distanceAccuracy;
    switch (self.distance) {
        case JXLocationAccuracyBest:
            distanceAccuracy = kCLLocationAccuracyBest;
            break;
        case JXLocationAccuracyHundredMeters:
            distanceAccuracy = kCLLocationAccuracyHundredMeters;
            break;
        case JXLocationAccuracyKilometer:
            distanceAccuracy = kCLLocationAccuracyKilometer;
            break;
        case JXLocationAccuracyThreeKilometers:
            distanceAccuracy = kCLLocationAccuracyThreeKilometers;
            break;
        case JXLocationAccuracyNearestTenMeters:
            distanceAccuracy = kCLLocationAccuracyNearestTenMeters;
            break;
        default:
            break;
    }
    return distanceAccuracy;
}

- (void)setIPAddress:(NSString *)ip withAK:(NSString *)ak{
    if (ip != nil && ak != nil) {
        IP = ip;
        AK = ak;
    }
}


/**
 根据IP地址获取位置，ip地址为空则自动获取当前网络IP地址
 
 @param successLoc 成功
 @param ipAdr ip地址
 @param errorLoc 失败
 */
- (void)getLocations:(void(^)(JXLocationModel *model))successLoc withIPAdress:(NSString *)ipAdr error:(void(^)(NSError *error))errorLoc{
    if (![ipAdr isEqualToString:IP]) {
        IP = ipAdr;
    }
    
    if (AK.length > 0) {
    
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSMutableDictionary *paremdic = [@{@"ip":IP,
                                           @"ak":AK,
                                           @"coor":@"bd09ll"
                                           }mutableCopy];
        
        [manager GET:@"http://api.map.baidu.com/location/ip" parameters:paremdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            JXLocationModel *model = [[JXLocationModel alloc]init];
            model.latitude = [[[[appData  objectForKey:@"content"]objectForKey:@"point"] objectForKey:@"y"] doubleValue];
            model.longitude = [[[[appData  objectForKey:@"content"]objectForKey:@"point"] objectForKey:@"x"] doubleValue];
            
            successLoc(model);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            errorLoc(error);
        }];
        
        
    }else{
        @throw [NSException exceptionWithName:@"JXLoactionError" reason:@" 开启IP定位前必须传入百度AK" userInfo:nil];
        
    }
    
}


//关闭定位
- (void)stopUpdatingLocation{
    [locationManager stopUpdatingLocation];
}

#pragma mark <获取坐标位置>

//逆编码获取当前坐标信息
- (void)getCurrentAddress:(void(^)(JXLocationModel *model))address error:(void(^)(NSError *error))locError{
    //通过数据源拿到当前位置
    __weak typeof(self)weak_self = self;
    [self getCurrentLocations:^(JXLocationModel *model) {
        [weak_self getLocAddress:[NSString stringWithFormat:@"%f",model.latitude] withLon:[NSString stringWithFormat:@"%f",model.longitude] address:^(JXLocationModel *model) {
            address(model);
            
            [self stopUpdatingLocation];
        } error:^(NSError *error) {
            locError(error);
            [self stopUpdatingLocation];
        }];
        
    } isIPOrientation:NO error:^(NSError *error) {
        locError(error);
    }];
}


//逆编码获取坐标信息
- (void)getLocAddress:(NSString *)lat withLon:(NSString *)lon address:(void(^)(JXLocationModel *model))address error:(void(^)(NSError *error))getFail{
    //使用地理位置 逆向编码拿到位置信息
    if (lat != nil && lon != nil) {
        CLGeocoder * geocoder = [[CLGeocoder alloc]init];
        CLLocation * currentLoc = [[CLLocation alloc]initWithLatitude:[lat floatValue] longitude:[lon floatValue]];
        [geocoder reverseGeocodeLocation:currentLoc completionHandler:^(NSArray *placemarks, NSError *error) {
            
            //逆编码完毕以后调用此block
            if (!error) {
                CLPlacemark * placeMark = placemarks[0];
                NSDictionary *locDic = placeMark.addressDictionary;
                
                
                JXLocationModel *model = [[JXLocationModel alloc]init];
                model.latitude = [lat doubleValue];
                model.longitude = [lon doubleValue];
                model.country = [locDic objectForKey:@"Country"];
                model.city = [locDic objectForKey:@"City"];
                model.province = [locDic objectForKey:@"State"];
                model.subCity = [locDic objectForKey:@"SubLocality"];
                model.thoroughfare = [locDic objectForKey:@"Thoroughfare"];
                model.street = [locDic objectForKey:@"Street"];
                model.name = [locDic objectForKey:@"Name"];
                
                address(model);
                //获取当前地址城市名
            }else{
                NSLog(@"逆编码失败");
                
                getFail(error);
            }}];
    }
}

#pragma mark <获取位置坐标>
/**
 获取当前地点的具体坐标
 */
- (void)getCurrentCor:(NSString *)locName  block:(void(^)(JXLocationModel *model))coorDic error:(void(^)(NSError *error))fail{
    
    [self getLoc:locName success:^(JXLocationModel *model) {
        coorDic(model);
    }fail:^(NSError *error) {
        fail(error);
    }];
}

//逆编码获取位置坐标
- (void)getLoc:(NSString *)address  success:(void (^)(JXLocationModel *model))coordinate fail:(void(^)(NSError *error))fail {
    //使用地理位置 逆向编码拿到位置信息
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    //逆编码当前位置
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark * placeMark = placemarks[0];
            JXLocationModel *model = [[JXLocationModel alloc]init];
            model.latitude = placeMark.location.coordinate.latitude;
            model.longitude = placeMark.location.coordinate.longitude;
            coordinate(model);
            
        }else {
            fail(error);
        }}];
}




#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *currLocation = locations.firstObject;
    
    JXLocationModel *model = [[JXLocationModel alloc]init];
    
    // 是否在中国
    if (![JXLocationHelper isLocationOutOfChina:currLocation.coordinate]) {
        // 坐标校准(根据自己所用地图而定)
        CLLocationCoordinate2D coord_gcj = [JXLocationHelper wgs84ToGcj02:[currLocation coordinate]];
        CLLocationCoordinate2D coord_bd9 = [JXLocationHelper gcj02ToBd09:coord_gcj];
        
        model.latitude = coord_bd9.latitude;
        model.longitude = coord_bd9.longitude;
        sucBlock(model);
        
    }else{
        
        model.latitude = currLocation.coordinate.latitude;
        model.longitude = currLocation.coordinate.longitude;
        sucBlock(model);
        
    }
    
}

//定位失败，回调此方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if (isIP) {
        [self getLocations:^(JXLocationModel *model) {
            sucBlock(model);
            
        } withIPAdress:@"" error:^(NSError *error) {
            errorBlock(error);
        }];
        
    }else{
        
        errorBlock(error);
        if ([error code]==kCLErrorDenied) {
            NSLog(@"访问被拒绝");
        }
        if ([error code]==kCLErrorLocationUnknown) {
            NSLog(@"无法获取位置信息");
        }
    }
}

@end

@implementation JXLocationModel


@end
