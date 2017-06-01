//
//  JXBTHomeRecomandModel.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/1.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXBTHomeRecomandModel : NSObject

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *views;
@property (nonatomic, copy) NSString *likes;

@end
