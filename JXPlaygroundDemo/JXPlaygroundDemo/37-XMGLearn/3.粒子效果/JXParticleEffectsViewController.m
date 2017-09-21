//
//  JXParticleEffectsViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/9/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXParticleEffectsViewController.h"
#import "DrawView.h"

@interface JXParticleEffectsViewController ()
@property (strong, nonatomic) IBOutlet DrawView *drawView;

@end

@implementation JXParticleEffectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)redraw:(UIButton *)sender {
    [self.drawView redraw];
}

- (IBAction)start:(UIButton *)sender {
    
    [self.drawView start];
}


@end
