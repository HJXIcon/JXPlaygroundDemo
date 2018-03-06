//
//  JXSuspension.m
//  JXSuspension
//
//  Created by HJXICon on 2018/3/2.
//  Copyright © 2018年 HJXICon. All rights reserved.
//

#import "JXSuspension.h"
#import "JXCountDown.h"
#import "UIView+JXExtension.h"

@interface JXSuspensionWindow : UIWindow
@property (nonatomic, strong) JXSuspension *suspension;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, weak) UIButton *btn1;
@property (nonatomic, weak) UIButton *btn2;

@end

@implementation JXSuspensionWindow
#pragma mark - *** lazy load
- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1111"]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    _imageView = imageView;
    
    self.contentView.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame), 0, 120, self.jx_height);
    [self addSubview:self.contentView];
    
    self.btn1 = [self addBtn:@"btn1" frame:CGRectMake(0, 0, 60, self.jx_height)];
    self.btn2 = [self addBtn:@"btn2" frame:CGRectMake(60, 0, 60, self.jx_height)];
}

- (UIButton *)addBtn:(NSString *)title frame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    btn.frame = frame;
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    
    return btn;
}

- (void)btnAction{
    NSLog(@"btnAction -- ");
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *view  = [self getTargePoint:point event:event];
    if (view == self.btn1 || view == self.btn2) {
        return view;
    }
    return [super hitTest:point withEvent:event];
}


- (UIView *)getTargePoint:(CGPoint)point
                    event:(UIEvent *)event
{
    __block UIView *subView;
    
    [self.contentView.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //point 从view 转到 obj中
        CGPoint hitPoint = [obj convertPoint:point fromView:self];
        //        NSLog(@"%@ - %@",NSStringFromCGPoint(point),NSStringFromCGPoint(hitPoint));
        
        if([obj pointInside:hitPoint withEvent:event])//在当前视图范围内
        {
            subView = obj;
            *stop = YES;
        }
        else//不在当前视图范围内
        {
            subView = nil;
        }
        
    }];
    
    return subView;
}

@end


@interface JXSuspension()
@property (nonatomic, strong) JXSuspensionWindow *window;
/// 记录是不是点击过
@property (nonatomic, assign, getter=isTap) BOOL tap;
@property (nonatomic, assign, getter=isHiddenCotentView) BOOL hiddenCotentView;
@property (nonatomic, strong) JXCountDown *countDown;
@property (nonatomic, assign) NSInteger time;
/// 记录上一次的中心点
@property (nonatomic, assign) CGPoint lastCenter;
@end

@implementation JXSuspension
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupConfig];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

/**
 *  属性初始化构造
 */
- (void)setupConfig {
    
    self.inertiaAlpha = 0.6;
    self.stateDuration = 2.0;
    self.hangingOnMargin = 20;
    self.windowSize = CGSizeMake(40, 40);
    
    self.window = [[JXSuspensionWindow alloc] initWithFrame:CGRectMake(0, 0, self.windowSize.width, self.windowSize.height)];
    self.window.rootViewController = [[UIViewController alloc]init];
    self.window.suspension = self;//相互持有，避免被释放
    self.window.center = CGPointMake(self.window.bounds.size.height/3, 100);
    self.window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.window.windowLevel = UIWindowLevelAlert + 1;
    [self.window makeKeyAndVisible];
    
    UIApplication *app = [UIApplication sharedApplication];
    if (app.delegate && app.delegate.window) {
        [app.delegate.window makeKeyAndVisible];
    }
    
    // 手势
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.window addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.window addGestureRecognizer:pan];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardDidHideNotification object:nil];
    
    /// 靠边
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.stateDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dealWindowCenter:self.windowOriginCenter];
    });
}






#pragma mark - *** setter
- (void)setWindowOriginCenter:(CGPoint)windowOriginCenter{
    _windowOriginCenter = windowOriginCenter;
    self.window.center = windowOriginCenter;
    self.lastCenter = windowOriginCenter;
}
- (void)setWindowSize:(CGSize)windowSize{
    _windowSize = windowSize;
    CGRect tmp = self.window.frame;
    tmp.size = windowSize;
    self.window.frame = tmp;
}



#pragma mark - *** Actions

- (void)keyboardShow {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = (UIWindow *)[windows lastObject];
    self.window.windowLevel = lastWindow.windowLevel + 1;
}

- (void)keyboardHide {
    self.window.windowLevel = self.window.windowLevel - 1;
}

- (void)tapAction:(UITapGestureRecognizer *)sender{
    self.window.contentView.alpha = 1;
    self.window.contentView.hidden = !self.isHiddenCotentView;
    self.hiddenCotentView = !self.isHiddenCotentView;
    
    if (self.tap == NO) {
        self.tap = YES;
        
        self.window.center = self.lastCenter;
        
        self.countDown = [[JXCountDown alloc]init];
        self.time = self.stateDuration;
        __weak typeof(self) weakSelf = self;
        [self.countDown countDownWithPER_SECBlock:^{
            weakSelf.time --;
            if (weakSelf.time < 0) {
                [weakSelf dealWindowCenter:weakSelf.lastCenter];
            }
            
        }];
        
    }
    else{
        self.tap = NO;
        self.time = self.stateDuration;
        
    }
    
    
}

/**
 *  窗体拖动事件
 *
 *  @param sender sender description
 */
- (void)panAction:(UIPanGestureRecognizer *)sender {
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [sender locationInView:appWindow];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.window.alpha = 1.0;
            
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            self.window.center = panPoint;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
        
            [self dealWindowCenter:panPoint];
        }break;
        default:
            break;
    }
    [sender setTranslation:CGPointMake(0, 0) inView:appWindow];
}

#pragma mark - *** Private Method
- (void)dealWindowCenter:(CGPoint)center{
    
    // 先不交互
    self.window.userInteractionEnabled = NO;
    
    // 记录是否是右边
    BOOL isRight = NO;
    
    
    CGFloat screenCenterX = [UIScreen mainScreen].bounds.size.width / 2;
    CGPoint endCenter;
    CGFloat centerY = 0;
    CGFloat leftCenterX = self.window.jx_width * 0.5 - self.hangingOnMargin;
    CGFloat rightCenterX = [UIScreen mainScreen].bounds.size.width - self.window.jx_width * 0.5 + self.hangingOnMargin;
    
    // 处理Y边界值
    if (center.y - self.window.jx_height * 0.5 > [UIScreen mainScreen].bounds.size.height - self.window.jx_height) {
        centerY = [UIScreen mainScreen].bounds.size.height - self.window.jx_height * 0.5 - 5;
    }
    else if(center.y - self.window.jx_height * 0.5 < self.hangingOnMargin){
        centerY = self.hangingOnMargin + self.window.jx_height * 0.5;
    }
    else{
        centerY = center.y;
    }
    
    
    
    
    if (MIN(self.window.jx_centerX, screenCenterX) == self.window.jx_centerX) { // 向左
        endCenter = CGPointMake(leftCenterX, centerY);
        
        // 修改
        self.lastCenter = CGPointMake(leftCenterX + self.hangingOnMargin, centerY);
    }
    else if(MIN(self.window.jx_centerX, screenCenterX) == screenCenterX){ // 向右
        isRight = YES;
        endCenter = CGPointMake(rightCenterX, centerY);
        
        // 修改
        self.lastCenter = CGPointMake(rightCenterX - self.hangingOnMargin, centerY);
    }
    else{ // 刚好正中间
        endCenter = CGPointMake(leftCenterX, centerY);
        
        // 修改
        self.lastCenter = CGPointMake(leftCenterX + self.hangingOnMargin, centerY);
    }
    
    
    
    
    [UIView animateWithDuration:self.stateDuration animations:^{
        self.window.alpha = self.inertiaAlpha;
        self.window.center = endCenter;
        self.window.contentView.alpha = 0;
        
        self.tap = NO;
        
        // 恢复交互
        self.window.userInteractionEnabled = YES;
        // 定时器
        if (self.countDown) {
            [self.countDown destoryTimer];
        }
        
    } completion:^(BOOL finished) {
        
        
        if (isRight) {
            self.window.contentView.transform = CGAffineTransformMakeTranslation(-self.window.contentView.jx_width - self.window.jx_width, 0);
        }
        else{
            self.window.contentView.transform = CGAffineTransformIdentity;
        }
        
        // hidden
        self.window.contentView.hidden = YES;
        self.hiddenCotentView = YES;
    }];
    
}

#pragma mark - *** Public Method
- (void)removeFromApplication {
    /*!
     对于一个UIWindow对象，之所以显示，是因为有一个对象强持有它，要销毁一个window，只需要将这个强持有去掉即可。但是,这种持有去掉之后，可能window可能不会立即消失，所以，为了确保能够立即将其不展现，最好按以下步骤：
     将window的hidden属性置为YES,将持有该window的那个对象对window的持有去掉
     */
    self.window.hidden = YES;
    self.window = nil;
    self.window.suspension = nil;
}

@end
