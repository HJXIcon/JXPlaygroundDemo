//
//  GlobalDefine.h
//  JXPlaygroundDemo
//
//  Created by mac on 17/5/21.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h


#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height


/** 弱引用/强引用 */
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;


/**! Dubug相关*/
#ifdef DEBUG
#define JXLog(format,...)  NSLog((@"[函数名:%s]\n" "[行号:%d]\n" format),__FUNCTION__,__LINE__,##__VA_ARGS__)
#else
#define JXLog(...)
#endif


#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]




#endif /* GlobalDefine_h */
