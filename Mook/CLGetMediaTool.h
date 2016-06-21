//
//  CLGetMediaTool.h
//  Mook
//
//  Created by 陈林 on 16/6/21.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLGetMediaTool : NSObject

@property (strong, nonatomic) UIViewController *controller;
@property (strong, nonatomic) UIImage *photo;

typedef void (^ImageBlock)(UIImage *photo);
typedef void (^VideoBlock)(NSURL *videoURL);

@property (strong, nonatomic) ImageBlock imageBlock;
@property (strong, nonatomic) VideoBlock videoBlock;

+ (instancetype)getInstance;

#pragma mark - 自己拍摄
- (void)takePhotoFromCurrentController:(UIViewController *)controller resultBlock:(ImageBlock)imageBlock;

- (void)recordVideoFromCurrentController:(UIViewController *)controller maximumDuration:(CGFloat)duration resultBlock:(VideoBlock)videoBlock;

#pragma mark - 相册挑选
- (void)pickAlbumPhotoFromCurrentController:(UIViewController *)controller resultBlock:(ImageBlock)imageBlock;


- (void)pickAlbumVideoFromCurrentController:(UIViewController *)controller maximumDuration:(CGFloat)duration resultBlock:(VideoBlock)videoBlock;

@end
