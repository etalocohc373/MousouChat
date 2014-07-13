//
//  CoreImageHelper.h
//  SimpleChat
//
//  Created by Minami Sophia Aramaki on 2014/05/05.
//  Copyright (c) 2014年 Logan Wright. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

@interface CoreImageHelper : NSObject

/* アスペクトサイズを維持してリサイズ */
+ (void)resizeAspectFitImageWithImage:(UIImage*)img atSize:(CGFloat)size completion:(void(^)(UIImage*))completion;

/* 画像の中央からトリミング */
+ (void)centerCroppingImageWithImage:(UIImage*)img atSize:(CGSize)size completion:(void(^)(UIImage*))completion;

/* CIImageからUIImageを作成 */
+ (UIImage*)uiImageFromCIImage:(CIImage*)ciImage;

@end