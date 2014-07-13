//
//  CoreImageHelper.m
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/05.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import "CoreImageHelper.h"

@implementation CoreImageHelper

+ (void)resizeAspectFitImageWithImage:(UIImage*)img atSize:(CGFloat)size completion:(void(^)(UIImage*))completion
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:img];
    // リサイズする倍率を求める
    CGFloat scale = img.size.width < img.size.height ? size/img.size.height : size/img.size.width;
    // CGAffineTransformでサイズ変更
    CIImage *filteredImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(scale,scale)];
    // UIImageに変換
    UIImage *newImg = [self uiImageFromCIImage:filteredImage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(newImg);
    });
}

+ (void)centerCroppingImageWithImage:(UIImage*)img atSize:(CGSize)size completion:(void(^)(UIImage*))completion
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:img];
    /* 画像のサイズ */
    CGSize imgSize = CGSizeMake(img.size.width /** img.scale*/,
                                img.size.height /** img.scale*/);
    /* 中央でトリミング */
    CIImage *filteredImage = [ciImage imageByCroppingToRect:CGRectMake(imgSize.width/2.f - size.width/2.f,
                                                                       imgSize.height/2.f - size.height/2.f,
                                                                       size.width,
                                                                       size.height)];
    /* UIImageに変換する */
    UIImage *newImg = [self uiImageFromCIImage:filteredImage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(newImg);
    });
}

+ (UIImage*)uiImageFromCIImage:(CIImage*)ciImage
{
    CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @NO }];
    CGImageRef imgRef = [ciContext createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage *newImg  = [UIImage imageWithCGImage:imgRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef);
    return newImg;
    
    /* iOS6.0以降だと以下が使用可能 */
    //  [[UIImage alloc] initWithCIImage:ciImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

@end
