//
//  UIImage+Tools.h
//  Mook
//
//  Created by 陈林 on 15/11/18.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToNewSize:(CGSize)newSize;
// 将图片的白色部分变为透明
+ (UIImage*) processImage :(UIImage*) image;
- (UIImage *)removeWhite;
- (UIImage *)removeBlack;

+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL
                             atTime:(NSTimeInterval)time;

- (UIImage *) getScaledToSize:(CGSize)size;

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByCroppingImageToSize:(CGSize)size;
//- (UIImage *)squareImageScaledToSize:(CGFloat)newSize;
@end
