//
//  NSString+Media.h
//  Mook
//
//  Created by 陈林 on 16/6/23.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVPlayerItem;
// 使用分类,可以把常用的方法,不好记的方法都抽取出来,进行归纳总结

@interface NSString (Media)

+ (NSString *)tempSharePath;
+ (NSString *)tempZipPath;
+ (NSString *)tempUnzipPath;

+ (NSString *)backUpPath;

+ (NSString *)mookPath;
+ (NSString *)videoPath;
+ (NSString *)framePath; // 视频首帧图片缓存文件夹

+ (NSString *)imagePath;
+ (NSString *)thumbnailPath;

+ (NSString *)audioPath;

// 根据文件名,存储和删除image 和 video 到沙盒document文件夹中
- (void)deleteNamedVideoFromDocument;
- (void)deleteNamedImageFromDocument;
- (void)deleteNamedAudioFromDocument;

// 储存多媒体
- (void)saveNamedImageToDocument:(UIImage *)image;
- (void)saveNamedVideoToDocument:(NSURL *)videoURL;
- (void)saveNamedAudioToDocument:(NSString *)filePath;


// 存储多媒体缩略图到缓存文件夹
- (void)saveNamedImageThumbnailImageToCache;
- (void)saveNamedVideoThumbnailImageToCache;

// 根据文件名获取多媒体
- (UIImage *)getNamedImage;
- (NSString *)getNamedAudio;

- (UIImage *)getNamedImageThumbnail;
- (UIImage *)getNamedVideoThumbnail;

// 获取缓存中的第一帧图片
- (UIImage *)getNamedVideoFrame;
//- (UIImage *)getFirstFrameOfNamedVideo;
- (AVPlayerItem *)getNamedAVPlayerItem;

- (NSInteger)getDurationForNamedAudio;
- (NSInteger)getDurationForNamedVideo;



+ (void)clearTmpDirectory;


@end
