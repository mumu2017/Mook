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
//@property (strong, nonatomic) UIImage *photo;
//@property (strong, nonatomic) NSURL *videoURL;

//typedef void (^ImageBlock)(UIImage *photo);
//typedef void (^VideoBlock)(NSURL *videoURL);
typedef void (^CompletionBlock)(NSURL *videoURL, UIImage *photo);
typedef void (^AudioBlock)(NSString *filePath);

//@property (strong, nonatomic) ImageBlock imageBlock;
//@property (strong, nonatomic) VideoBlock videoBlock;
@property (strong, nonatomic) CompletionBlock completion;
@property (strong, nonatomic) AudioBlock audioBlock;

+ (instancetype)getInstance;

#pragma mark - 相机拍摄
//- (void)takePhotoFromCurrentController:(UIViewController *)controller resultBlock:(ImageBlock)imageBlock;

- (void)loadCameraFromCurrentViewController:(UIViewController *)controller maximumDuration:(CGFloat)duration completion:(CompletionBlock)completion;

#pragma mark - 相册挑选
//- (void)pickAlbumPhotoFromCurrentController:(UIViewController *)controller resultBlock:(ImageBlock)imageBlock;


- (void)pickAlbumMediaFromCurrentController:(UIViewController *)controller maximumDuration:(CGFloat)duration completion:(CompletionBlock)completion;

- (void)recordAudioFromCurrentController:(UIViewController *)controller audioBlock:(AudioBlock)audioBlock;

@end
