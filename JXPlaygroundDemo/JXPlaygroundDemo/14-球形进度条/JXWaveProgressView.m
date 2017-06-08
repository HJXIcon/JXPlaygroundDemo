//
//  JXWaterProgressView.m
//  JXPlaygroundDemo
//
//  Created by mac on 17/6/7.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXWaveProgressView.h"


@interface JXWaveProgressView ()
@property(nonatomic, assign) CGRect fullRect;
@property(nonatomic, assign) CGRect scaleRect;
@property(nonatomic, assign) CGRect waveRect;
@property(nonatomic, assign) CGFloat currentLinePointY;
@property(nonatomic, assign) CGFloat targetLinePointY;
@property(nonatomic, assign) CGFloat amplitude;//振幅
@property(nonatomic, assign) CGFloat currentPercent;//但前百分比，用于保存第一次显示时的动画效果
@property(nonatomic, assign) CGFloat a;
@property(nonatomic, assign) CGFloat b;
@property(nonatomic, assign) BOOL increase;

@end
@implementation JXWaveProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _fullRect = frame;
        
        /// 初始化数据
        [self initialize];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawBackground:context];
    [self drawWave:context];
    [self drawLabel:context];
    [self drawScale:context];

    
}

/**
 *  画比例尺
 *
 *  @param context 全局context
 */
- (void)drawScale:(CGContextRef)context {
    
    CGContextSetLineWidth(context, _scaleDivisionsWidth);//线的宽度
    //======================= 矩阵操作 ============================
    CGContextTranslateCTM(context, _fullRect.size.width / 2, _fullRect.size.width / 2);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.655 green:0.710 blue:0.859 alpha:1.00].CGColor);//线框颜色
    // 2. 绘制一些图形
    //    for (int i = 0; i < _scaleCount; i++) {
    //        CGContextMoveToPoint(context, scaleRect.size.width/2 - _scaleDivisionsLength, 0);
    //        CGContextAddLineToPoint(context, scaleRect.size.width/2, 0);
    //        //    CGContextScaleCTM(ctx, 0.5, 0.5);
    //        // 3. 渲染
    //        CGContextStrokePath(context);
    //        CGContextRotateCTM(context, 2 * M_PI / _scaleCount);
    //    }
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.694 green:0.745 blue:0.867 alpha:1.00].CGColor);//线框颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:32/255.0 green:188/255.0 blue:238/255.0 alpha:1.00].CGColor);//线框颜色
    CGContextSetLineWidth(context, 0.5);
    CGContextAddArc (context, 0, 0, _scaleRect.size.width/2 - _scaleDivisionsLength - 3, 0, M_PI* 2 , 0);
    CGContextStrokePath(context);
    
    CGContextTranslateCTM(context, -_fullRect.size.width / 2, -_fullRect.size.width / 2);
}


/**
 画文字
 */
- (void)drawLabel:(CGContextRef)context {
    
    NSMutableAttributedString *attriButedText = [self formatBatteryLevel:_percent * 100];
    CGRect textSize = [attriButedText boundingRectWithSize:CGSizeMake(400, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    NSMutableAttributedString *attriLabelText = [self formatLabel:_title];
    CGRect labelSize = [attriLabelText boundingRectWithSize:CGSizeMake(400, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    CGPoint textPoint = CGPointMake(_fullRect.size.width / 2 - textSize.size.width / 2, _fullRect.size.height / 2 - textSize.size.height / 2 - labelSize.size.height / 2);
    CGPoint labelPoint = CGPointMake(_fullRect.size.width / 2 - labelSize.size.width / 2, textPoint.y + textSize.size.height);
    
    [attriButedText drawAtPoint:textPoint];
    [attriLabelText drawAtPoint:labelPoint];
    
    //推入
    CGContextSaveGState(context);
}

/**
 *  显示信息Label参数
 *
 *  @param text 显示的文字
 *
 *  @return 相关参数
 */
-(NSMutableAttributedString *) formatLabel:(NSString *)text
{
    UIColor *textColor = [UIColor whiteColor];
    NSMutableAttributedString *attrText;
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setAlignment:NSTextAlignmentCenter];
    
    UIFont *font = [UIFont systemFontOfSize:14];
    
    attrText=[[NSMutableAttributedString alloc] initWithString:text];
    [attrText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    [attrText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, text.length)];
    [attrText  addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, text.length)];
    
    return attrText;
}


/**
 *  格式化电量的Label的字体
 *
 *  @param percent 百分比
 *
 *  @return 电量百分比文字参数
 */
-(NSMutableAttributedString *) formatBatteryLevel:(NSInteger)percent
{
    UIColor *textColor = [UIColor whiteColor];
    NSMutableAttributedString *attrText;
    
    NSString *percentText = [NSString stringWithFormat:@"%ld%@",(long)percent,@"分"];
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setAlignment:NSTextAlignmentCenter];
    
    if (percent < 10) {
        attrText = [[NSMutableAttributedString alloc] initWithString:percentText];
        UIFont *capacityNumberFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:60];
        UIFont *capacityPercentFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
        [attrText addAttribute:NSFontAttributeName value:capacityNumberFont range:NSMakeRange(0, 1)];
        [attrText addAttribute:NSFontAttributeName value:capacityPercentFont range:NSMakeRange(1, 1)];
        [attrText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, 2)];
        [attrText  addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, 2)];
        
    } else {
        attrText = [[NSMutableAttributedString alloc] initWithString:percentText];
        UIFont *capacityNumberFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:60];
        UIFont *capacityPercentFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
        
        
        if (percent >= 100) {
            
            [attrText addAttribute:NSFontAttributeName value:capacityNumberFont range:NSMakeRange(0, 3)];
            [attrText addAttribute:NSFontAttributeName value:capacityPercentFont range:NSMakeRange(3, 1)];
            [attrText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, 4)];
            [attrText addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, 4)];
            
        } else {
            [attrText addAttribute:NSFontAttributeName value:capacityNumberFont range:NSMakeRange(0, 2)];
            [attrText addAttribute:NSFontAttributeName value:capacityPercentFont range:NSMakeRange(2, 1)];
            [attrText addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, 3)];
            [attrText  addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, 3)];
        }
        
    }
    
    
    
    return attrText;
}




/**
 *  画波浪
 *
 *  @param context 全局context
 */
- (void)drawWave:(CGContextRef)context {
    
    CGMutablePathRef frontPath = CGPathCreateMutable();
    CGMutablePathRef backPath = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_frontWaterColor CGColor]);
    
    CGFloat offset = _scaleMargin + _waveMargin + _scaleDivisionsWidth;
    
    float frontY = _currentLinePointY;
    float backY = _currentLinePointY;
    
    CGFloat radius = _waveRect.size.width / 2;
    
    CGPoint frontStartPoint = CGPointMake(offset, _currentLinePointY + offset);
    CGPoint frontEndPoint = CGPointMake(offset, _currentLinePointY + offset);
    
    CGPoint backStartPoint = CGPointMake(offset, _currentLinePointY + offset);
    CGPoint backEndPoint = CGPointMake(offset, _currentLinePointY + offset);
    
    for(float x = 0; x <= _waveRect.size.width; x++){
        
        //前浪绘制
        frontY = _a * sin( x / 180 * M_PI + 4 * _b / M_PI ) * _amplitude + _currentLinePointY;
        
        CGFloat frontCircleY = frontY;
        if (_currentLinePointY < radius) {
            frontCircleY = radius - sqrt(pow(radius, 2) - pow((radius - x), 2));
            if (frontY < frontCircleY) {
                frontY = frontCircleY;
            }
            
        } else if (_currentLinePointY > radius) {
            frontCircleY = radius + sqrt(pow(radius, 2) - pow((radius - x), 2));
            if (frontY > frontCircleY) {
                frontY = frontCircleY;
            }
        }
        
        if (fabs(0 - x) < 0.001) {
            frontStartPoint = CGPointMake(x + offset, frontY + offset);
            CGPathMoveToPoint(frontPath, NULL, frontStartPoint.x, frontStartPoint.y);
        }
        
        frontEndPoint = CGPointMake(x + offset, frontY + offset);
        CGPathAddLineToPoint(frontPath, nil, frontEndPoint.x, frontEndPoint.y);
        
        //后波浪绘制
        backY = _a * cos( x / 180 * M_PI + 3 * _b / M_PI ) * _amplitude + _currentLinePointY;
        CGFloat backCircleY = backY;
        if (_currentLinePointY < radius) {
            backCircleY = radius - sqrt(pow(radius, 2) - pow((radius - x), 2));
            if (backY < backCircleY) {
                backY = backCircleY;
            }
        } else if (_currentLinePointY > radius) {
            backCircleY = radius + sqrt(pow(radius, 2) - pow((radius - x), 2));
            if (backY > backCircleY) {
                backY = backCircleY;
            }
        }
        
        if (fabs(0 - x) < 0.001) {
            backStartPoint = CGPointMake(x + offset, backY + offset);
            CGPathMoveToPoint(backPath, NULL, backStartPoint.x, backStartPoint.y);
        }
        
        backEndPoint = CGPointMake(x + offset, backY + offset);
        CGPathAddLineToPoint(backPath, nil, backEndPoint.x, backEndPoint.y);
    }
    
    CGPoint centerPoint = CGPointMake(_fullRect.size.width / 2, _fullRect.size.height / 2);
    
    //绘制前浪圆弧
    CGFloat frontStart = [self calculateRotateDegree:centerPoint point:frontStartPoint];
    CGFloat frontEnd = [self calculateRotateDegree:centerPoint point:frontEndPoint];
    
    CGPathAddArc(frontPath, nil, centerPoint.x, centerPoint.y, _waveRect.size.width / 2, frontEnd, frontStart, 0);
    CGContextAddPath(context, frontPath);
    CGContextFillPath(context);
    //推入
    CGContextSaveGState(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(frontPath);
    
    
    //绘制后浪圆弧
    CGFloat backStart = [self calculateRotateDegree:centerPoint point:backStartPoint];
    CGFloat backEnd = [self calculateRotateDegree:centerPoint point:backEndPoint];
    
    CGPathAddArc(backPath, nil, centerPoint.x, centerPoint.y, _waveRect.size.width / 2, backEnd, backStart, 0);
    
    CGContextSetFillColorWithColor(context, [_backWaterColor CGColor]);
    CGContextAddPath(context, backPath);
    CGContextFillPath(context);
    //推入
    CGContextSaveGState(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(backPath);
    
}

/*!
**
*  根据圆心点和圆上一个点计算角度
*
*  @param centerPoint 圆心点
*  @param point       圆上的一个点
*
*  @return 角度
*/
- (CGFloat)calculateRotateDegree:(CGPoint)centerPoint point:(CGPoint)point {
    
    CGFloat rotateDegree = asin(fabs(point.y - centerPoint.y) / (sqrt(pow(point.x - centerPoint.x, 2) + pow(point.y - centerPoint.y, 2))));
    
    //如果point纵坐标大于原点centerPoint纵坐标(在第一和第二象限)
    if (point.y > centerPoint.y) {
        //第一象限
        if (point.x >= centerPoint.x) {
            rotateDegree = rotateDegree;
        }
        //第二象限
        else {
            rotateDegree = M_PI - rotateDegree;
        }
    } else //第三和第四象限
    {
        if (point.x <= centerPoint.x) //第三象限，不做任何处理
        {
            rotateDegree = M_PI + rotateDegree;
        }
        else //第四象限
        {
            rotateDegree = 2 * M_PI - rotateDegree;
        }
    }
    return rotateDegree;
}





/*!
*  画背景界面
*
*  @param context 全局context
*/
- (void)drawBackground:(CGContextRef)context {
    
    
    CGPoint centerPoint = CGPointMake(_fullRect.size.width / 2, _fullRect.size.height / 2);
    
    // 1.创建路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:_waveRect.size.width / 2 startAngle:0 endAngle:2 * M_PI clockwise:NO];
    
    path.lineWidth = 1;
    
    //3.添加路径到上下文
    CGContextAddPath(context, path.CGPath);
    
    //4.设置颜色
    [_waterBgColor setFill];
    [_waterBgColor setStroke];
    
    //5.显示上下文 显示一个实心圆
    CGContextFillPath(context);
    
    
    /*！
     方式二画圆：
    //画背景圆
     *****! 步骤：
     http://www.cnblogs.com/purple-sweet-pottoes/p/5109413.html
     ****
     
     //1.创建绘制区域,显示的区域可以用CGMUtablePathRef生成任意的形状
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_waterBgColor CGColor]);
    
    CGPoint centerPoint = CGPointMake(_fullRect.size.width / 2, _fullRect.size.height / 2);
    
    CGPathAddArc(path, nil, centerPoint.x, centerPoint.y, _waveRect.size.width / 2, 0, 2 * M_PI, 0);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
     */
    
    /**!
     CGContextRotateCTM的相关
     http://www.cnblogs.com/wendingding/p/3782551.html
     */
    
    if (_showBgLineView) {
        //绘制背景的线
        //======================= 矩阵操作 ============================
        /// 平移
        CGContextTranslateCTM(context, _fullRect.size.width / 2, _fullRect.size.width / 2);
        // 线框颜色
//        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.694 green:0.745 blue:0.867 alpha:1.00].CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
        
        CGContextSetLineWidth(context, 1);
        CGContextAddArc (context, 0, 0, _fullRect.size.width/2 - 4, -M_PI / 4, M_PI / 4, 0);
        CGContextStrokePath(context);
        
        /// 上下文旋转
        CGContextRotateCTM(context, M_PI / 4);
        CGContextMoveToPoint(context, _fullRect.size.width/2 - 10, 0);
        CGContextAddLineToPoint(context, _fullRect.size.width/2, 0);
        // 线框颜色
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        // 3. 渲染
        CGContextStrokePath(context);
        
        // 图片会以原点(左下角)为中心旋转45度
        CGContextRotateCTM(context, -M_PI / 4);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.694 green:0.745 blue:0.867 alpha:1.00].CGColor);//线框颜色
        // 线框颜色
        CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddArc (context, 0, 0, _fullRect.size.width/2 - 4, M_PI * 3 / 4, M_PI * 5 / 4, 0);
        CGContextStrokePath(context);
        
        
        CGContextRotateCTM(context, M_PI * 5 / 4);
        CGContextMoveToPoint(context, _fullRect.size.width/2 - 4, 0);
        CGContextAddLineToPoint(context, _fullRect.size.width/2, 0);
        // 线框颜色
        CGContextSetStrokeColorWithColor(context, [UIColor brownColor].CGColor);
        // 3. 渲染
        CGContextStrokePath(context);
        
        
        CGContextRotateCTM(context, -M_PI * 5 / 4);
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.694 green:0.745 blue:0.867 alpha:1.00].CGColor);//线框颜色
        // 线框颜色
        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        
        CGContextSetLineWidth(context, 6);
        CGContextAddArc (context, 0, 0, _fullRect.size.width/2 - _scaleMargin / 2, M_PI * 4 / 10, M_PI * 6 / 10, 0);
        CGContextStrokePath(context);
        
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.694 green:0.745 blue:0.867 alpha:1.00].CGColor);//线框颜色
        CGContextSetLineWidth(context, 6);
        CGContextAddArc (context, 0, 0, _fullRect.size.width/2 - _scaleMargin / 2, M_PI * 14 / 10, M_PI * 16 / 10, 0);
        CGContextStrokePath(context);
        
        
        CGContextTranslateCTM(context, -_fullRect.size.width / 2, -_fullRect.size.width / 2);
    }
}




- (void)initialize{
    
    _scaleDivisionsLength = 10;
    _scaleDivisionsWidth = 2;
    _scaleCount = 100;
    
    _a = 1.5;
    _b = 0;
    _increase = NO;
    
    _frontWaterColor = [UIColor colorWithRed:0.325 green:0.392 blue:0.729 alpha:1.00];
    _backWaterColor = [UIColor colorWithRed:0.322 green:0.514 blue:0.831 alpha:1.00];
    _waterBgColor = [UIColor colorWithRed:0.259 green:0.329 blue:0.506 alpha:1.00];
    _percent = 0.45;
    
    _scaleMargin = 30;
    _waveMargin = 18;
    _showBgLineView = NO;
    
    [self initDrawingRects];
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
}



- (void)initDrawingRects{
    
    CGFloat offset = _scaleMargin;
    _scaleRect = CGRectMake(offset,
                           offset,
                           _fullRect.size.width - 2 * offset,
                           _fullRect.size.height - 2 * offset);
    
    offset = _scaleMargin + _waveMargin + _scaleDivisionsWidth;
    _waveRect = CGRectMake(offset,
                          offset,
                          _fullRect.size.width - 2 * offset,
                          _fullRect.size.height - 2 * offset);
    
    _currentLinePointY = _waveRect.size.height;
    _targetLinePointY = _waveRect.size.height * (1 - _percent);
    _amplitude = (_waveRect.size.height / 320.0) * 10;
    
    [self setNeedsDisplay];
}



#pragma mark - Actions
/**
 *  实时调用产生波浪的动画效果
 */
-(void)animateWave
{
    if (_targetLinePointY == self.frame.size.height ||
        _currentLinePointY == 0) {
        return;
    }
    
    if (_targetLinePointY < _currentLinePointY) {
        _currentLinePointY -= 1;
        _currentPercent = (_waveRect.size.height - _currentLinePointY) / _waveRect.size.height;
    }
    
    if (_targetLinePointY > _currentLinePointY) {
        _currentLinePointY += 1;
        _currentPercent = (_waveRect.size.height - _currentLinePointY) / _waveRect.size.height;
    }
    
    if (_increase) {
        _a += 0.01;
    } else {
        _a -= 0.01;
    }
    
    
    if (_a <= 1) {
        _increase = YES;
    }
    
    if (_a >= 1.5) {
        _increase = NO;
    }
    
    _b += 0.1;
    
    [self setNeedsDisplay];
}

@end
