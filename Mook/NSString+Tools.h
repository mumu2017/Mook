//
//  NSString+Tools.h
//  新浪微博页面
//
//  Created by 陈林 on 15/10/21.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class AVPlayerItem;
// 使用分类,可以把常用的方法,不好记的方法都抽取出来,进行归纳总结
// 随着学习的深入,我们每个人都会建立一大套属于自己的分类库!
@interface NSString (Tools)

+ (NSString *)videoPath;
+ (NSString *)imagePath;
+ (NSString *)thumbnailPath;

// 计算当前字符串显示所需的实际frame,返回的值 x == 0, y == 0
- (CGRect)textRectWithSize:(CGSize)size attributes:(NSDictionary *)attributes;
- (NSAttributedString *)contentStringWithDate:(NSString *)date;

// 获取模型创建时间
+ (NSString *)getDateString:(NSDate *)date;

// 组建标题
+ (NSAttributedString *)titleString:(NSString *)title withDate:(NSDate *)date;

// 设置string的行间距
- (NSAttributedString *)styledString;

// 根据文件名,存储和删除image 和 video 到沙盒document文件夹中
- (void)deleteNamedVideoFromDocument;
- (void)deleteNamedImageFromDocument;

// 储存多媒体
- (void)saveNamedImageToDocument:(UIImage *)image;
- (void)saveNamedVideoToDocument:(NSURL *)videoURL;

// 存储多媒体缩略图到缓存文件夹
- (void)saveNamedImageThumbnailImageToCache;
- (void)saveNamedVideoThumbnailImageToCache;

// 根据文件名获取多媒体
- (UIImage *)getNamedImage;

- (UIImage *)getNamedThumbnail;

- (UIImage *)getFirstFrameOfNamedVideo;
- (AVPlayerItem *)getNamedAVPlayerItem;
+ (void)clearTmpDirectory;
@end
