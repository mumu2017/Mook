//
//  UIImage+Tools.m
//  Mook
//
//  Created by 陈林 on 15/11/18.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "UIImage+Tools.h"
//#import "UIImage+WaterMark.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (Tools)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*) processImage :(UIImage*) image
{
    const CGFloat colorMasking[6]={222,255,222,255,222,255};
    CGImageRef imageRef = CGImageCreateWithMaskingColors(image.CGImage, colorMasking);
    UIImage* imageB = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return imageB;
}

- (UIImage *)removeWhite
{
    const CGFloat colorMasking[6]={222,255,222,255,222,255};
    CGImageRef imageRef = CGImageCreateWithMaskingColors(self.CGImage, colorMasking);
    UIImage* imageB = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return imageB;
}

- (UIImage *)removeBlack
{
    const CGFloat colorMasking[6]={0,10,0,10,0,10};
    CGImageRef imageRef = CGImageCreateWithMaskingColors(self.CGImage, colorMasking);
    UIImage* imageB = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return imageB;
}

+ (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL
                             atTime:(NSTimeInterval)time
{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetIG =
    [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetIG.appliesPreferredTrackTransform = YES;
    assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *igError = nil;
    thumbnailImageRef =
    [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                    actualTime:NULL
                         error:&igError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", igError );
    
    UIImage *thumbnailImage = thumbnailImageRef
    ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]
    : nil;

    return thumbnailImage;
}

- (UIImage *) getScaledToSize:(CGSize)size {
    
    // Check which dimension (width or height) to pay respect to and
    // calculate the scale factor
    CGFloat imgRatio = self.size.width / self.size.height;
    CGFloat btnRatio = size.width / size.height;
    CGFloat scaleFactor = (imgRatio > btnRatio ? self.size.width / size.width : self.size.height / size.height);
                   
    // Create image using scale factor
    UIImage *scaledImg = [UIImage imageWithCGImage:[self CGImage] scale:scaleFactor orientation:UIImageOrientationUp];
    
    return scaledImg;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}

- (UIImage *)imageByCroppingImageToSize:(CGSize)size
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(self.CGImage);
    double refHeight = CGImageGetHeight(self.CGImage);
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    
    CGRect cropRect = CGRectMake(x, y, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return cropped;
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToNewSize:(CGSize)newSize
{
    // 只于是正方形的newSize;
    CGFloat originW = image.size.width;
    CGFloat originH = image.size.height;
    
    CGFloat newW = newSize.width;
    CGFloat newH = newSize.height;
    
    CGFloat originRatio;
    
    if (originW > originH) {
        originRatio = originH / originW;
        newW = newW / originRatio;

    } else if (originH > originW) {
        originRatio = originW / originH;
        newH = newW / originRatio;
    }
    CGSize modifiedSize = CGSizeMake(newW, newH);
    
    UIGraphicsBeginImageContext(modifiedSize);
    [image drawInRect:CGRectMake(0,0,newW,newH)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
