//
//  JXPlaceAroundTableView.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapView.h>
#import <AMapSearchKit/AMapSearchKit.h>

@protocol PlaceAroundTableViewDeleagate <NSObject>

/// 点击POI的位置点
- (void)didTableViewSelectedChanged:(AMapPOI *)selectedPoi;

/// 点击更多
- (void)didLoadMorePOIButtonTapped;

/// 点击位置
- (void)didPositionCellTapped;

@end


@interface JXPlaceAroundTableView : UIView<UITableViewDataSource, UITableViewDelegate, AMapSearchDelegate>

@property (nonatomic, weak) id<PlaceAroundTableViewDeleagate> delegate;

/// 当前格式化地址
@property (nonatomic, copy) NSString *currentAddress;

- (instancetype)initWithFrame:(CGRect)frame;

/// 获取当前选中的POI
- (AMapPOI *)selectedTableViewCellPoi;

@end
