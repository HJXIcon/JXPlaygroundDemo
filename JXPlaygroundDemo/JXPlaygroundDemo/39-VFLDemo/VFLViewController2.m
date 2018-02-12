//
//  number.m
//  JXPlaygroundDemo
//
//  Created by HJXICon on 2018/2/12.
//  Copyright © 2018年 Mr.Gao. All rights reserved.
//

#import "VFLViewController2.h"

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface VFLViewController2 ()
{
    NSDictionary *dic;
}
@property (nonatomic,strong) UIView *cyanView;
@property (nonatomic,strong) UIView *redView;
@property (nonatomic,strong) UIView *orangeView;
@property (nonatomic,strong) UIView *view1;
@property (nonatomic,strong) UIView *view2;
@property (nonatomic,strong) UIButton *button;
@end

@implementation VFLViewController2
@synthesize redView,cyanView,orangeView,view1,view2,button;
/*
 使用规则  -----VFL
 
 |: 表示父视图
 -:表示距离
 V:  :表示垂直
 H:  :表示水平
 >= :表示视图间距、宽度和高度必须大于或等于某个值
 <= :表示视图间距、宽度和高度必须小宇或等于某个值
 == :表示视图间距、宽度或者高度必须等于某个值
 @  :>=、<=、==  限制   最大为  1000
 
 1.|-[view]-|:  视图处在父视图的左右边缘内
 2.|-[view]  :   视图处在父视图的左边缘
 3.|[view]   :   视图和父视图左边对齐
 4.-[view]-  :  设置视图的宽度高度
 5.|-30.0-[view]-30.0-|:  表示离父视图 左右间距  30
 6.[view(200.0)] : 表示视图宽度为 200.0
 7.|-[view(view1)]-[view1]-| :表示视图宽度一样，并且在父视图左右边缘内
 8. V:|-[view(50.0)] : 视图高度为  50
 9: V:|-(==padding)-[imageView]->=0-[button]-(==padding)-| : 表示离父视图的距离
 为Padding,这两个视图间距必须大于或等于0并且距离底部父视图为 padding。
 10:  [wideView(>=60@700)]  :视图的宽度为至少为60 不能超过  700
 11: 如果没有声明方向默认为  水平
 
 功能　　　　　　　　表达式
 
 水平方向  　　　　　　  H:
 
 垂直方向  　　　　　　  V:
 
 Views　　　　　　　　 [view]
 
 SuperView　　　　　　|
 
 关系　　　　　　　　　>=,==,<=
 
 空间,间隙　　　　　　　-
 
 优先级　　　　　　　　@value
 ----------------------------------------
 NSLayoutFormatOptions
 NSLayoutFormatAlignAllLeft = (1 << NSLayoutAttributeLeft),
 NSLayoutFormatAlignAllRight = (1 << NSLayoutAttributeRight),
 NSLayoutFormatAlignAllTop = (1 << NSLayoutAttributeTop),
 NSLayoutFormatAlignAllBottom = (1 << NSLayoutAttributeBottom),
 NSLayoutFormatAlignAllLeading = (1 << NSLayoutAttributeLeading),
 NSLayoutFormatAlignAllTrailing = (1 << NSLayoutAttributeTrailing),
 NSLayoutFormatAlignAllCenterX = (1 << NSLayoutAttributeCenterX),
 NSLayoutFormatAlignAllCenterY = (1 << NSLayoutAttributeCenterY),
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"number == %d",self.number];
    [self setupViews];
    
    int index = self.number;
    switch (index) {
        case 0:{
            [self.view addSubview:cyanView];
            [self.view addSubview:redView];
            [self.view addSubview:orangeView];
            [self example_1];
        }break;
        case 1:{
            [self.view addSubview:cyanView];
            [cyanView addSubview:redView];
            [redView addSubview:orangeView];
            [redView addSubview:view1];
            [redView addSubview:button];
            [self example_2];
        }break;
        case 2:
            [self.view addSubview:cyanView];
            [self.view addSubview:redView];
            [self.view addSubview:orangeView];
            [self.view addSubview:button];
            [self.view addSubview:view1];
            [self example_3];
            break;
        case 3:
            [self.view addSubview:cyanView];
            [self.view addSubview:redView];
            [self.view addSubview:orangeView];
            [self.view addSubview:button];
            [self.view addSubview:view1];
            [self.view addSubview:view2];
            [self example_4];
            break;
        case 4:
            [self.view addSubview:cyanView];
            [cyanView addSubview:redView];
            [self example_5];
            break;
            
        default:
            break;
    }
    
}

- (void)setupViews {
    cyanView = [[UIView alloc] init];
    [cyanView setTranslatesAutoresizingMaskIntoConstraints:NO];
    cyanView.backgroundColor = [UIColor colorWithRed:168 / 255.0f green:217 / 255.0f blue:1 alpha:1];
    
    redView = [[UIView alloc] init];
    [redView setTranslatesAutoresizingMaskIntoConstraints:NO];
    redView.backgroundColor = [UIColor colorWithRed:1 green:189 / 255.0f blue:197 / 255.0f alpha:1];
    
    orangeView = [[UIView alloc] init];
    orangeView.translatesAutoresizingMaskIntoConstraints = NO;
    orangeView.backgroundColor = [UIColor colorWithRed:1 green:232 / 255.0f blue:197 / 255.0f alpha:1];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"back" forState:UIControlStateNormal];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor colorWithRed:178 / 255.0f green:243 / 255.0f blue:249 / 255.0f alpha:1];
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    view1 = [[UIView alloc] init];
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    view1.backgroundColor = [UIColor colorWithRed:203 / 255.0f green:1 blue:173 / 255.0f alpha:1];
    
    view2 = [[UIView alloc] init];
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    view2.backgroundColor = [UIColor colorWithRed:168 / 255.0f green:122 / 255.0f blue:173 / 255.0f alpha:1];
    
    
    //通过宏映射成[NSDictionary dictionaryWithObjectsAndKeys:v1, @"v1", v2, @"v2", nil];
    dic = NSDictionaryOfVariableBindings(cyanView,redView,orangeView,view1,view2,button);
    
}

- (void)example_1 {
    // redView在父视图的上边缘,距离15
    [self superView:self.view :@"V:|-15-[redView]" :0];
    // redView在父视图的左边缘,距离15,redView的右侧cyanView相距15，cyanView在父视图右边缘,距离15。一样的top约束
    [self superView:self.view :@"H:|-15-[redView]-15-[cyanView]-15-|" :NSLayoutFormatAlignAllTop];
    // cyanView的高度等于redView的高度
    [self superView:self.view :@"V:[cyanView(==redView)]" :0];
    // cyanView的宽度等于redView的宽度
    [self superView:self.view :@"H:[cyanView(==redView)]" :0];
    // redView和orange垂直距离为15
    [self superView:self.view :@"V:[redView]-15-[orangeView]" :0];
    // orangeView处在父视图的左右边缘内 距离15
    [self superView:self.view :@"H:|-15-[orangeView]-15-|" :0];
    // orangeView下边和父视图的距离为15
    [self superView:self.view :@"V:[orangeView]-15-|" :0];
    // orangeView宽度等于redView的宽度
    [self superView:self.view :@"V:[orangeView(==redView)]" :0];
}

- (void)example_2 {
    [self superView:self.view :@"H:|-20-[cyanView]-20-|" :0];
    [self superView:self.view :@"V:|-20-[cyanView]-20-|" :0];
    [self superView:cyanView  :@"H:|-20-[redView]-20-|" :0];
    [self superView:cyanView  :@"V:|-20-[redView]-20-|" :0];
    [self superView:redView   :@"H:|-20-[orangeView]-20-|" :0];
    [self superView:redView   :@"V:|-20-[orangeView]" :0];
    [self superView:redView   :@"H:[button(==orangeView)]" :0];
    [self superView:redView   :@"V:[button(==orangeView)]" :0];
    [self superView:redView   :@"H:[view1(orangeView)]" :0];
    [self superView:redView   :@"V:[view1(orangeView)]" :0];
    [self superView:redView   :@"V:[view1]-20-|" :0];
    // orangeView和button和View1之间间隔为20 并垂直齐平
    [self superView:redView   :@"V:[orangeView]-20-[button]-20-[view1]" :NSLayoutFormatAlignAllCenterX];
}

- (void)example_3 {
    [self superView:self.view :@"H:|-20-[cyanView]-20-|" :0];
    [self superView:self.view :@"H:[redView(cyanView)]" :0];
    [self superView:self.view :@"V:[redView(cyanView)]" :0];
    [self superView:self.view :@"H:[button(cyanView)]" :0];
    [self superView:self.view :@"V:[button(cyanView)]" :0];
    [self superView:self.view :@"H:[orangeView(cyanView)]" :0];
    [self superView:self.view :@"V:[orangeView(cyanView)]" :0];
    [self superView:self.view :@"H:[view1(cyanView)]" :0];
    [self superView:self.view :@"V:[view1(cyanView)]" :0];
    // cyanView和父视图左边缘的距离为20，其他之间的间隔为15 并垂直齐平
    [self superView:self.view :@"V:|-20-[cyanView]-15-[redView]-15-[button]-15-[orangeView]-15-[view1]-15-|" :NSLayoutFormatAlignAllCenterX];
}

- (void)example_4 {
    // cyanView和父视图左边缘的距离为20，与redView的间距为15，redView和父视图右边缘的距离为20 并水平齐平
    [self superView:self.view :@"H:|-20-[cyanView]-15-[redView]-20-|" :NSLayoutFormatAlignAllCenterY];
    [self superView:self.view :@"V:|-20-[cyanView]-15-[button]-15-[view1]-20-|" :NSLayoutFormatAlignAllCenterX];
    [self superView:self.view :@"V:|-20-[redView]-15-[orangeView]-15-[view2]-20-|" :NSLayoutFormatAlignAllCenterX];
    [self superView:self.view :@"H:[redView(cyanView)]" :0];
    [self superView:self.view :@"V:[redView(cyanView)]" :0];
    [self superView:self.view :@"H:[button(cyanView)]" :0];
    [self superView:self.view :@"V:[button(cyanView)]" :0];
    [self superView:self.view :@"H:[orangeView(cyanView)]" :0];
    [self superView:self.view :@"V:[orangeView(cyanView)]" :0];
    [self superView:self.view :@"H:[view1(cyanView)]" :0];
    [self superView:self.view :@"V:[view1(cyanView)]" :0];
    [self superView:self.view :@"H:[view2(cyanView)]" :0];
    [self superView:self.view :@"V:[view2(cyanView)]" :0];
}

- (void)example_5 {
    /*
     metrics 是一个字典 把字典放在Format字符串上 key 对应value
     */
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-interval-[cyanView]-interval-|"
                                                                      options:0
                                                                      metrics:@{@"interval":@0}
                                                                        views:dic]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-interval-[cyanView]-interval-|"
                                                                      options:0
                                                                      metrics:@{@"interval":@50}
                                                                        views:dic]];
    
    [cyanView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[redView(width)]"
                                                                     options:0
                                                                     metrics:@{@"width":[NSNumber numberWithFloat:ScreenWidth / 2]}
                                                                       views:dic]];
    [cyanView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[redView(height)]"
                                                                     options:0
                                                                     metrics:@{@"height":[NSNumber numberWithFloat:ScreenHeight / 4]}
                                                                       views:dic]];
#warning 美中不足的是VFL没有居中的代码   只能用下面的方法了
    [cyanView addConstraint:[NSLayoutConstraint constraintWithItem:cyanView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:redView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
    
    [cyanView addConstraint:[NSLayoutConstraint constraintWithItem:cyanView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:redView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
    
    
}

- (void)superView :(UIView *)superView :(NSString *)format :(NSLayoutFormatOptions)options {
    [superView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:format
                                             options:options
                                             metrics:nil
                                               views:dic]];
}

- (void)btnAction {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
