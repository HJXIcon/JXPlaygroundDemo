//
//  JXCustomCalloutView.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
  自定义气泡类步骤：
 （1） 新建自定义气泡类 CustomCalloutView，继承 UIView。
 （2） 在 CustomCalloutView.h 中定义数据属性，包含：图片、商户名和商户地址。
  (3） 在CustomCalloutView.m中重写UIView的drawRect方法，绘制弹出气泡的背景。
 （4） 定义用于显示气泡内容的控件，并添加到SubView中
 
 
 以上就是自定义气泡的全部过程，但是为了在点击标注时，弹出自定义的气泡，还需要。步骤如下：
 （1） 新建类CustomAnnotationView，继承MAAnnotationView或MAPinAnnotationView。若继承MAAnnotationView，则需要设置标注图标；若继承MAPinAnnotationView，使用默认的大头针标注
 （2） 在CustomAnnotationView.h中定义自定义气泡属性
 
 （3） 在CustomAnnotationView.m中修改calloutView属性
 （4） 重写选中方法setSelected。选中时新建并添加calloutView，传入数据；非选中时删除calloutView。
 （5） 修改ViewController.m，在MAMapViewDelegate的回调方法mapView:viewForAnnotation中的修改annotationView的类型
 
 */

/**
 自定义气泡类
 */
@interface JXCustomCalloutView : UIView


@property (nonatomic, strong) UIImage *image; //商户图
@property (nonatomic, copy) NSString *title; //商户名
@property (nonatomic, copy) NSString *subtitle; //地址

@end
