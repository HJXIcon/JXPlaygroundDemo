//
//  NSString+CalculationAttrStrHeight.m
//  FishingWorld
//
//  Created by mac on 2017/3/3.
//  Copyright © 2017年 zhuya. All rights reserved.
//

#import "NSString+CalculationAttrStrHeight.h"

@implementation NSString (CalculationAttrStrHeight)
-(CGFloat)calculatAttrStrHeight:(NSString *)str andWith:(CGFloat)with{

    
//    NSMutableAttributedString *html_string =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
//    
//    [html_string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} range:NSMakeRange(0, str.length)];
//    
//    CGSize textSize = [html_string boundingRectWithSize:(CGSize){JXScreenW - 40, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    NSMutableAttributedString *html_string=  [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [html_string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, html_string.length)];
    //    (字体font是自定义的 要求和要显示的label设置的font一定要相同)
    CGSize textSize = [html_string boundingRectWithSize:CGSizeMake(kScreenW - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    
    if (textSize.height > 105) {
        textSize.height += 20;
    }
    return textSize.height;
}
-(CGFloat)calculatAttrStrHeight:(NSString *)str andWith:(CGFloat)with andFont:(UIFont *)font{
    return [str boundingRectWithSize:CGSizeMake(with, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
}
-(CGFloat)calculatAttrStrWith:(NSString *)str andHeight:(CGFloat)height andFont:(UIFont *)font{
    return [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
}
@end
