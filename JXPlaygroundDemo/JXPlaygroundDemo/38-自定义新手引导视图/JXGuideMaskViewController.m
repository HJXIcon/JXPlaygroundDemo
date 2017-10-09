//
//  JXGuideMaskViewController.m
//  JXPlaygroundDemo
//
//  Created by 晓梦影 on 2017/10/9.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXGuideMaskViewController.h"
#import "XCGuideMaskView.h"

@interface JXGuideMaskViewController ()<XCGuideMaskViewDataSource, XCGuideMaskViewLayout>

@property (strong, nonatomic)  NSArray *collectionViews;

@end

@implementation JXGuideMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新手教程";
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.collectionViews = self.view.subviews;
    
}
- (IBAction)showAction:(id)sender {
    XCGuideMaskView *maskView = [[XCGuideMaskView alloc] initWithDatasource:self];
    maskView.layout = self;
    [maskView show];
}

#pragma mark - 📕 👀 XCGuideMaskViewDataSource 👀

- (NSInteger)numberOfItemsInGuideMaskView:(XCGuideMaskView *)guideMaskView
{
    return self.collectionViews.count;
}

- (UIView *)guideMaskView:(XCGuideMaskView *)guideMaskView viewForItemAtIndex:(NSInteger)index
{
    return self.collectionViews[index];
}

- (NSString *)guideMaskView:(XCGuideMaskView *)guideMaskView descriptionForItemAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"这是第 %zi 个视图的描述", index];
}

- (UIColor *)guideMaskView:(XCGuideMaskView *)guideMaskView colorForDescriptionAtIndex:(NSInteger)index
{
    return arc4random_uniform(2) ? [UIColor whiteColor] : [UIColor redColor];
}

- (UIFont *)guideMaskView:(XCGuideMaskView *)guideMaskView fontForDescriptionAtIndex:(NSInteger)index
{
    return arc4random_uniform(2) ? [UIFont systemFontOfSize:13] : [UIFont systemFontOfSize:15];
}

#pragma mark - 👀 XCGuideMaskViewLayout 👀 💤

- (CGFloat)guideMaskView:(XCGuideMaskView *)guideMaskView cornerRadiusForViewAtIndex:(NSInteger)index
{
    
    return 5;
}


@end
