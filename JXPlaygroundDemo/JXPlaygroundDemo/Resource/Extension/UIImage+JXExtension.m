//
//  UIImage+JXExtension.m
//  FishingWorld
//
//  Created by mac on 16/12/5.
//  Copyright © 2016年 zhuya. All rights reserved.
//

#import "UIImage+JXExtension.h"
#import <AVFoundation/AVFoundation.h>
#import <UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>


@implementation UIImage (JXExtension)


/**
 返回已经改变的图片

 @param image 图片
 @param size 所需图片尺寸
 @return 图片
 */
+ (UIImage *) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}


/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 
 */
+ (UIImage *) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height{
    CGRect r = CGRectMake(0.0f,0.0f,1.0f, height);UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();CGContextSetFillColorWithColor(context, [color CGColor]);CGContextFillRect(context, r);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();UIGraphicsEndImageContext();
    
    return img;
}

/**
 根据view生成图片
 
 @param view view
 @return image
 */
+ (UIImage *) createImageFromView:(UIView *)view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}




/**
 取出视频的每一帧图片

 @param videoURL 视频url
 @param time 时间
 @return 图片
 */
+ (UIImage *) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}



/**
 获取SDWebImage缓存图片

 @return 缓存的图片
 */
+ (UIImage*)imageFromSdcacheWithURLString:(NSString *)urlString{
    
    NSData *imageData = nil;
    
//    BOOL isExit = [[SDWebImageManager sharedManager]diskImageExistsForURL:[NSURL URLWithString:urlString]];
    
    __block BOOL isExit;
    [[SDWebImageManager sharedManager]diskImageExistsForURL:[NSURL URLWithString:urlString] completion:^(BOOL isInCache) {
        
        isExit = isInCache;
    }];
    
    if(isExit) {
        
        NSString *cacheImageKey = [[SDWebImageManager sharedManager]cacheKeyForURL:[NSURL URLWithString:urlString]];
        
        if(cacheImageKey.length) {
            
            NSString *cacheImagePath = [[SDImageCache sharedImageCache]defaultCachePathForKey:cacheImageKey];
            
            if(cacheImagePath.length) {
                
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
                
            }
            
        }
        
    }
    
    if(!imageData) {
        
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
    
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    
    //描述一个矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    //获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //使用color演示填充上下文
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    
    //渲染上下文
    CGContextFillRect(ctx, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}


/**
 *  修改图片size，按比例进行缩放
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */
+ (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}

//截取部分图像
+(UIImage *)getSubImageRect:(CGRect)rect andImage:(UIImage *)image
{
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

//将一张图片画在另一张上面合成一张图片
+(UIImage *)reDrawImage:(UIImage *)backImage andImage:(UIImage *)image{
    CGSize backImageSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, 55);
    UIGraphicsBeginImageContext(backImageSize);
    backImage = [backImage stretchableImageWithLeftCapWidth:4 topCapHeight:4];//图片中间部分拉伸
    [backImage drawInRect:CGRectMake(0, 0, backImageSize.width,backImageSize.height)];
    
    [image drawInRect:CGRectMake((backImageSize.width - image.size.width) / 2,10, image.size.width, image.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultingImage;
}

//设置图片透明度

+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image

{
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}







@end
