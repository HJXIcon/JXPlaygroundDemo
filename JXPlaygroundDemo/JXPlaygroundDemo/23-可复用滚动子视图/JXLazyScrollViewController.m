//
//  JXLazyScrollViewController.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/16.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXLazyScrollViewController.h"
#import "TMMuiLazyScrollView.h"
#import "MPLazyImageViewCustomView.h"
#import "MPLazyLableViewCustomView.h"
#import "MPLazyTitleViewCustomView.h"

@interface JXLazyScrollViewController ()<TMMuiLazyScrollViewDelegate,TMMuiLazyScrollViewDataSource>

@property(nonatomic,strong)NSMutableArray * rectArray;

@end

@implementation JXLazyScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"23-可复用滚动子视图";
    
    self.rectArray  = [NSMutableArray array];
    
    TMMuiLazyScrollView *scrollview = [[TMMuiLazyScrollView alloc]init];
    scrollview.frame = self.view.bounds;
    
    scrollview.delegate = self;
    scrollview.dataSource = self;
    
    [self.view addSubview:scrollview];
    
    
    //Create a single column layout with 5 elements;
    for (int i = 0; i < 5 ; i++) {
        [self.rectArray addObject:[NSValue valueWithCGRect:CGRectMake(10, i *80 + 2 , self.view.bounds.size.width-20, 80-2)]];
    }
    //Create a double column layout with 10 elements;
    for (int i = 0; i < 10 ; i++) {
        [self.rectArray addObject:[NSValue valueWithCGRect:CGRectMake((i%2)*self.view.bounds.size.width/2 + 3, 410 + i/2 *80 + 2 , self.view.bounds.size.width/2 -3, 80 - 2)]];
    }
    //Create a trible column layout with 15 elements;
    for (int i = 0; i < 15 ; i++) {
        [self.rectArray addObject:[NSValue valueWithCGRect:CGRectMake((i%3)*self.view.bounds.size.width/3 + 1, 820 + i/3 *80 + 2 , self.view.bounds.size.width/3 -3, 80 - 2)]];
    }
    
    for(int i=0; i<12;i++)
    {
        [self.rectArray addObject:[NSValue valueWithCGRect:CGRectMake((i%2)*self.view.bounds.size.width/2 + 3, 1230+i/2 *100 + 2, self.view.bounds.size.width/2 -6, 100-2)]];
    }
    
    scrollview.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 1830);
    //STEP 3 reload LazyScrollView
    [scrollview reloadData];
}

#pragma mark - TMMuiLazyScrollViewDataSource
//STEP 2 implement datasource delegate.
- (NSUInteger)numberOfItemInScrollView:(TMMuiLazyScrollView *)scrollView
{
    return self.rectArray.count;
}

- (TMMuiRectModel *)scrollView:(TMMuiLazyScrollView *)scrollView rectModelAtIndex:(NSUInteger)index
{
    CGRect rect = [(NSValue *)[self.rectArray objectAtIndex:index]CGRectValue];
    TMMuiRectModel *rectModel = [[TMMuiRectModel alloc]init];
    rectModel.absoluteRect = rect;
    rectModel.muiID = [NSString stringWithFormat:@"%ld",index];
    return rectModel;
}



- (UIView *)scrollView:(TMMuiLazyScrollView *)scrollView itemByMuiID:(NSString *)muiID
{
    
    NSInteger index = [muiID integerValue];
    
    if (index < self.rectArray.count - 12) {
        //Find view that is reuseable first.
        MPLazyLableViewCustomView *label = (MPLazyLableViewCustomView *)[scrollView dequeueReusableItemWithIdentifier:@"testView"];
        
        if (!label)
        {
            label = [[MPLazyLableViewCustomView alloc]initWithFrame:[(NSValue *)[self.rectArray objectAtIndex:index]CGRectValue]];
            label.textAlignment = NSTextAlignmentCenter;
            label.reuseIdentifier = @"testView";
        }
        
        label.frame = [(NSValue *)[self.rectArray objectAtIndex:index]CGRectValue];
        label.text = [NSString stringWithFormat:@"%lu",(unsigned long)index];
        label.backgroundColor = kRandomColorKRGBColor;
        [scrollView addSubview:label];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)]];
        return label;
    }
    else
    {
        MPLazyImageViewCustomView *imageCustomView = (MPLazyImageViewCustomView *)[scrollView dequeueReusableItemWithIdentifier:@"imageView"];
        if(!imageCustomView)
        {
            imageCustomView = [[MPLazyImageViewCustomView alloc]initWithFrame:[(NSValue *)[self.rectArray objectAtIndex:index]CGRectValue]];
            imageCustomView.reuseIdentifier=@"imageView";
            
        }
        imageCustomView.backgroundColor = kRandomColorKRGBColor;
        imageCustomView.imageName = @"public_empty_loading";
        imageCustomView.frame = [(NSValue *)[self.rectArray objectAtIndex:index]CGRectValue];
        [scrollView addSubview:imageCustomView];
        
        return imageCustomView;
    }
}


#pragma mark - Actions
- (void)click:(UIGestureRecognizer *)recognizer
{
    MPLazyLableViewCustomView *label = (MPLazyLableViewCustomView *)recognizer.view;
    
    NSLog(@"Click - %@",label.muiID);
}

@end
