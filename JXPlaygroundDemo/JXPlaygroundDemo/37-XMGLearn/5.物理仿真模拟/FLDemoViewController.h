//
//  FLDemoViewController.h
//  DynamicDemo
//
//  Created by Liu Feng on 13-12-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    FLDynamicTypeSnap = 0,
    FLDynamicTypePush,
    FLDynamicTypeAttachment,
    FLDynamicTypeSpring
    
}FLDynamicType;

@interface FLDemoViewController : UIViewController

@property (assign, nonatomic) FLDynamicType type;

@end
