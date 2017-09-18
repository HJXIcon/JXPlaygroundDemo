//
//  PreviewCell.h
//  IHK
//
//  Created by 郑文明 on 16/3/16.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewCell : UICollectionViewCell

@property (nonatomic, copy)NSIndexPath *currentIndexPath;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, retain)id model;
@property (nonatomic, copy) void (^singleTapGestureBlock)();

@end
