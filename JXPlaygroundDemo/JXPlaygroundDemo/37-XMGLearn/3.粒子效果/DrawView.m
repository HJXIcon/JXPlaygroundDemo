
#import "DrawView.h"

@interface DrawView()

@property (strong, nonatomic) UIBezierPath *path;
/** 红点*/
@property (nonatomic ,weak) CALayer *dotLayer;

@end

@implementation DrawView

+ (Class)layerClass {
    return [CAReplicatorLayer class];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    //创建粒子
    CALayer *dotLayer = [CALayer layer];
    dotLayer.backgroundColor = [UIColor redColor].CGColor;
    dotLayer.frame = CGRectMake(-20, 0, 20, 20);
    dotLayer.cornerRadius = 10;
    [self.layer addSublayer:dotLayer];
    self.dotLayer = dotLayer;
    
    //复制子层
    CAReplicatorLayer *repL = (CAReplicatorLayer *)self.layer;
    repL.instanceCount = 20;
    repL.instanceDelay = 0.5;
    
    //创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    self.path = path;
}


- (void)pan:(UIPanGestureRecognizer *)pan {
    
    //获取当前的手指的点
    CGPoint curP = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
     
        [self.path moveToPoint:curP];
        
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        //添加一根线到当前手指的点
        [self.path addLineToPoint:curP];
        //重绘
        [self setNeedsDisplay];
    }
}


//开始
- (void)start {
    
    //帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"position";
    anim.path = self.path.CGPath;
    anim.repeatCount = MAXFLOAT;
    anim.duration = 5;
    
    [self.dotLayer addAnimation:anim forKey:nil];
    

}
//绘制
- (void)redraw {

    //删除所有的动画
    [self.dotLayer removeAllAnimations];
    //清空路径上的所有的点
    [self.path removeAllPoints];
    //重绘
    [self setNeedsDisplay];
    
}


- (void)drawRect:(CGRect)rect {

    //画线
    [self.path stroke];
}



@end
