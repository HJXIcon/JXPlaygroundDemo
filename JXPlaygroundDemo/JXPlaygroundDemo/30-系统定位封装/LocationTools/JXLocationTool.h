//
//  JXLocationTool.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/8/1.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JXLocationModel;
typedef NS_ENUM(NSInteger, JXLocationDistance) {
    JXLocationAccuracyBest = 0,
    JXLocationAccuracyNearestTenMeters,
    JXLocationAccuracyHundredMeters,
    JXLocationAccuracyKilometer,
    JXLocationAccuracyThreeKilometers
};


@interface JXLocationTool : NSObject


///默认精度最好
@property (nonatomic, assign)JXLocationDistance distance;
///默认最大距离更新坐标
@property (nonatomic, assign)CGFloat distanceFilter;

/**
 获取地理位置类
 */
+ (JXLocationTool *)shareInstance;


/**
 GPS定位获取当前位置，若失败可调用IP定位获取位置,位置字典key为lat(纬度)和long(经度);

 @param success  成功
 @param orientation 是否Ip定位
 @param errors 失败
 */
- (void)getCurrentLocations:(void(^)(JXLocationModel *model))success isIPOrientation:(BOOL)orientation error:(void(^)(NSError  *error))errors;

/**
 开启IP定位前必须传入百度AK,IP若为空则自动获取当前网络IP地址
 */
- (void)setIPAddress:(NSString *)ip withAK:(NSString *)ak;


/**
 根据IP地址获取位置，ip地址为空则自动获取当前网络IP地址

 @param successLoc 成功
 @param ipAdr ip地址
 @param errorLoc 失败
 */
- (void)getLocations:(void(^)(JXLocationModel *model))successLoc withIPAdress:(NSString *)ipAdr error:(void(^)(NSError *error))errorLoc;


/**
 获取当前坐标点的位置信息，字典包含lat(纬度)，long(经度)， country(国家)，State(省)，city(城市)，subLocality(城区)，thoroughfare(大道)，street(街道)
 */
- (void)getCurrentAddress:(void(^)(JXLocationModel *model))address error:(void(^)(NSError *error))locError;


/**
 获取坐标点的位置信息，字典包含lat(纬度)，long(经度)， Country(国家)，State(省)，City(城市)，SubLocality(城区)，Thoroughfare(大道)，SubThoroughfare(门牌号)  Street(街道)

 @param lat lat
 @param lon lon
 @param address 成功回调地址
 @param getFail 失败
 */
- (void)getLocAddress:(NSString *)lat withLon:(NSString *)lon address:(void(^)(JXLocationModel *model))address error:(void(^)(NSError *error))getFail;


/**
 获取当前地点的具体坐标
 */
- (void)getCurrentCor:(NSString *)locName  block:(void(^)(JXLocationModel *model))coorDic error:(void(^)(NSError *error))fail;


/**
 停止定位
 */
- (void)stopUpdatingLocation;

@end


@interface JXLocationModel : NSObject
@property (nonatomic, assign)CLLocationDegrees latitude;
@property (nonatomic, assign)CLLocationDegrees longitude;
@property (nonatomic, strong)NSString *country;
@property (nonatomic, strong)NSString *province;
// 市
@property (nonatomic, strong)NSString *city;
// 城区
@property (nonatomic, strong)NSString *subCity;
// 大道
@property (nonatomic, strong)NSString *thoroughfare;
// 街道
@property (nonatomic, strong)NSString *street;

// 地名
@property (nonatomic, strong)NSString *name;
@end


