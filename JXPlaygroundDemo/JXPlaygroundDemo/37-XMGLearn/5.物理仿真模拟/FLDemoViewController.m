//
//  FLDemoViewController.m
//  DynamicDemo
//
//  Created by Liu Feng on 13-12-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "FLDemoViewController.h"
#import "FLDemoView.h"
#import "FLSnapView.h"
#import "FLPushView.h"
#import "FLAttachmentView.h"
#import "FLSpringView.h"

@interface FLDemoViewController ()

@end

@implementation FLDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    FLDemoView *demoView = nil;
    
    switch (self.type) {
            
        case FLDynamicTypeSnap: // 吸附效果
            demoView = [[FLSnapView alloc] initWithFrame:self.view.bounds];
            break;
        
        case FLDynamicTypePush: // 推动效果
            demoView = [[FLPushView alloc] initWithFrame:self.view.bounds];
            break;
            
        case FLDynamicTypeAttachment: // 刚性附着效果
            demoView = [[FLAttachmentView alloc] initWithFrame:self.view.bounds];
            break;
            
        case FLDynamicTypeSpring: // 弹性附着效果
            demoView = [[FLSpringView alloc] initWithFrame:self.view.bounds];
            break;
            
        default:
            break;
    }
    
    [self.view addSubview:demoView];
}


@end
