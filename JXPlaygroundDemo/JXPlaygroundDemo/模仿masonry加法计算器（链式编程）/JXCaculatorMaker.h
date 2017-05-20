//
//  JXCaculatorMaker.h
//  模仿masonry加法计算器
//
//  Created by mac on 17/5/13.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

/*！
 链式编程思想：是将多个操作（多行代码）通过点号(.)链接在一起成为一句代码,使代码可读性好。a(1).b(2).c(3)
 链式编程特点：方法的返回值是block,block必须有返回值（本身对象），block参数（需要操作的值）
 
 代表：masonry框架。
 
 */

/*!
 响应式编程思想:不需要考虑调用顺序，只需要知道考虑结果，类似于蝴蝶效应，产生一个事件，会影响很多东西，这些事件像流一样的传播出去，然后影响结果，借用面向对象的一句话，万物皆是流
 代表：KVO运用。
 
 */

/*!
 函数式编程思想：是把操作尽量写成一系列嵌套的函数或者方法调用。
 
 函数式编程特点：每个方法必须有返回值（本身对象）,把函数或者Block当做参数,block参数（需要操作的值）block返回值（操作结果）
 
 代表：ReactiveCocoa
 
 
 */

@interface JXCaculatorMaker : NSObject

@property(nonatomic, assign) float result;


- (JXCaculatorMaker *(^)(float))add;
//- (JXCaculatorMaker *(^)(float))sub;
//- (JXCaculatorMaker *(^)(float))muilt;
//- (JXCaculatorMaker *(^)(float))divide;

@end
