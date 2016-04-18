//
//  NSString+Tools.m
//  新浪微博页面
//
//  Created by 陈林 on 15/10/21.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "NSString+Tools.h"
#import <AVFoundation/AVFoundation.h>
#import "NSDate+MJ.h"
#import "UIImage+WaterMark.h"
#import "CLDataSaveTool.h"

@implementation NSString (Tools)

// self就是调用当前成员方法的NSString对象
- (CGRect)textRectWithSize:(CGSize)size attributes:(NSDictionary *)attributes
{
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}

// 设定文本段落格式
- (NSAttributedString *)styledString {

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:6];
    [style setParagraphSpacing:12];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, self.length)];
    
    return attrString;
}

// 获取日期时间+effect的content内容(显示在ListCell中)
- (NSAttributedString *)contentStringWithDate:(NSString *)date {
    NSMutableAttributedString * datePart = [[NSMutableAttributedString alloc] initWithString:date];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:kFontSys13,NSForegroundColorAttributeName:[UIColor flatSkyBlueColorDark],};
    [datePart setAttributes:firstAttributes range:NSMakeRange(0,datePart.length)];
    NSMutableAttributedString * contentPart = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary * secondAttributes = @{NSFontAttributeName:kFontSys13,NSForegroundColorAttributeName:[UIColor darkGrayColor],};
    [contentPart setAttributes:secondAttributes range:NSMakeRange(0,contentPart.length)];
    [datePart appendAttributedString:contentPart];
    
    return datePart;
}

// 将两个文本组合在一起,并各自定义字体和颜色
+ (NSAttributedString *)attributedStringWithFirstPart:(NSString *)part1 secondPart:(NSString *)part2 firstPartFont:(UIFont *)font1 firstPartColor:(UIColor *)color1 secondPardFont:(UIFont *)font2 secondPartColor:(UIColor *)color2 {
    
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:part1];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:font1,NSForegroundColorAttributeName:color1,};
    [firstPart setAttributes:firstAttributes range:NSMakeRange(0,firstPart.length)];
    
    NSMutableAttributedString * secondPart = [[NSMutableAttributedString alloc] initWithString:part2];
    NSDictionary * secondAttributes = @{NSFontAttributeName:font2,NSForegroundColorAttributeName:color2,};
    [secondPart setAttributes:secondAttributes range:NSMakeRange(0,secondPart.length)];
    
    [firstPart appendAttributedString:secondPart];
    
    return firstPart;
}

// 获取ContentVC中的标题文本格式
+ (NSAttributedString *)titleString:(NSString *)title withDate:(NSDate *)dateInfo tags:(NSArray *)tags {
    title = [NSString stringWithFormat:@"\n%@", title];
    NSString *dateString = [self getDateString:dateInfo];
    NSMutableAttributedString * datePart = [[NSMutableAttributedString alloc] initWithString:dateString];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:kFontSys12,NSForegroundColorAttributeName:[UIColor darkGrayColor],};
    [datePart setAttributes:firstAttributes range:NSMakeRange(0,datePart.length)];
    
    NSMutableAttributedString * contentPart = [[NSMutableAttributedString alloc] initWithString:title];
    NSDictionary * secondAttributes = @{NSFontAttributeName:kBoldFontSys24,NSForegroundColorAttributeName:[UIColor blackColor],};
    [contentPart setAttributes:secondAttributes range:NSMakeRange(0,contentPart.length)];
    [datePart appendAttributedString:contentPart];
    
    NSString *tagString;

    if (tags.count == 0) {
        tagString = NSLocalizedString(@"\n无标签", nil);
    } else {
        tagString = NSLocalizedString(@"\n标签:", nil);
        for (NSString *tag in tags) {
            tagString = [tagString stringByAppendingString:[NSString stringWithFormat:@" %@", tag]];
        }
    }
    
    NSMutableAttributedString * tagPart = [[NSMutableAttributedString alloc] initWithString:tagString];
    NSDictionary * tagAttributes = @{NSFontAttributeName:kFontSys12,NSForegroundColorAttributeName:[UIColor darkGrayColor],};
    [tagPart setAttributes:tagAttributes range:NSMakeRange(0,tagPart.length)];
    [datePart appendAttributedString:tagPart];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8];

    [datePart addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, datePart.length)];
    
    return datePart;
}

// 获取NSDate数据的实时时间文本
+ (NSString *)getDateString:(NSDate *)date
{
    // Tue Mar 10 17:32:22 +0800 2015
    // 字符串转换NSDate
    //    _created_at = @"Tue Mar 11 17:48:24 +0800 2015";
    
    NSString *_created_at;
    // 日期格式字符串
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM d HH:mm:ss Z yyyy";
    
    // 设置格式本地化,日期格式字符串需要知道是哪个国家的日期，才知道怎么转换
    fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en_us"];
    
    if ([date isThisYear]) { // 今年
        
        if ([date isToday]) { // 今天
            
            // 计算跟当前时间差距
            NSDateComponents *cmp = [date deltaWithNow];
            
            if (cmp.hour >= 1) {
                return [NSString stringWithFormat:NSLocalizedString(@"%ld小时之前", nil),cmp.hour];
            }else if (cmp.minute > 1){
                return [NSString stringWithFormat:NSLocalizedString(@"%ld分钟之前", nil),cmp.minute];
            }else{
                return NSLocalizedString(@"刚刚", nil);
            }
            
        }else if ([date isYesterday]){ // 昨天
            fmt.dateFormat = NSLocalizedString(@"昨天 HH:mm", nil);
            return  [fmt stringFromDate:date];
            
        }else{ // 前天
            fmt.dateFormat = @"MM-dd HH:mm";
            return  [fmt stringFromDate:date];
        }
        
        
        
    }else{ // 不是今年
        
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        
        return [fmt stringFromDate:date];
        
    }
    
    return _created_at;
}

#pragma mark - 分享单个模型时压缩相关数据存放的临时文件路径

+ (NSString *)tempUnzipPath {
    NSError *error;
    NSString *tempUnzipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/mookShare"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:tempUnzipPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:tempUnzipPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    return tempUnzipPath;
}

+ (NSString *)tempSharePath {

    NSString *tempSharePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"mookShare.data"];

    return tempSharePath;
}

+ (NSString *)tempZipPath {
    
    NSString *tempZipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"share.mook"];
    
    return tempZipPath;
}

#pragma mark - 获取多媒体文件路径

+ (NSString *)backUpPath { // 备份文件路径
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString *backUpPath = [documentsDirectory stringByAppendingPathComponent:@"backup.mook"];
    
    return backUpPath;
}

+ (NSString *)mookPath {
    NSError *error;
    // 因为UIFileSharing的关系, 将Private的文件储存在Library中
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *libraryPath = [paths objectAtIndex:0];
    
    NSString *mookPath = [libraryPath stringByAppendingPathComponent:@"/Mook"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:mookPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:mookPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    return mookPath;
}

+ (NSString *)videoPath {
    NSError *error;
    NSString *mookPath = [NSString mookPath]; // Get documents folder
    NSString *videoPath = [mookPath stringByAppendingPathComponent:@"/Videos"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:videoPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:videoPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    return videoPath;
}

+ (NSString *)imagePath {
    NSError *error;
    NSString *mookPath = [NSString mookPath]; // Get documents folder
    NSString *imagePath = [mookPath stringByAppendingPathComponent:@"/Images"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:imagePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    return imagePath;
}

+ (NSString *)framePath {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *framePath = [documentsDirectory stringByAppendingPathComponent:@"/Frames"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:framePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:framePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    return framePath;
}



+ (NSString *)thumbnailPath {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *thumbnailPath = [documentsDirectory stringByAppendingPathComponent:@"/Thumbnails"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:thumbnailPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:thumbnailPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    return thumbnailPath;
}

#pragma mark - 储存多媒体
- (void)saveNamedVideoFrameToCache {
    
    NSString *framePath = [[NSString framePath] stringByAppendingPathComponent:self];
    
    NSString *videoPath = [[NSString videoPath] stringByAppendingPathComponent:self];
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    UIImage *videoFrame = [UIImage thumbnailImageForVideo:videoURL atTime:0];
    
    CGFloat longside;
    if (videoFrame.size.width > videoFrame.size.height) {
        longside = videoFrame.size.width;
    } else {
        longside = videoFrame.size.height;
    }
    
    if (longside > 480) { // 如果长边比480大, 那么久压缩图片尺寸
        UIImage *scaledImage = [UIImage imageWithImage:videoFrame scaledToNewSize:CGSizeMake(360, 360)]; // 360会是短边的距离,按照4:3的常规图像比例, 长边应该是360 / 3 * 4 = 480
        [UIImageJPEGRepresentation(scaledImage, 0.5) writeToFile:framePath atomically:YES];
        
    } else {
        [UIImageJPEGRepresentation(videoFrame, 0.5) writeToFile:framePath atomically:YES];
    }
}

- (void)saveNamedImageThumbnailImageToCache {
    // 存储缩略图文件
    NSString *thumbnailPath = [[NSString thumbnailPath] stringByAppendingPathComponent:self];
    UIImage *thumbnail0 = [UIImage imageWithImage:[self getNamedImage] scaledToNewSize:CGSizeMake(210, 210)];
    UIImage *thumbnail = [thumbnail0 imageByCroppingImageToSize:CGSizeMake(210, 210)];

    [UIImageJPEGRepresentation(thumbnail, 0.5) writeToFile:thumbnailPath atomically:YES];
}

- (void)saveNamedVideoThumbnailImageToCache {
    
    // 存储缩略图文件
    NSString *thumbnailPath = [[NSString thumbnailPath] stringByAppendingPathComponent:self];
    UIImage *thumbnail0 = [UIImage imageWithImage:[self getNamedVideoFrame] scaledToNewSize:CGSizeMake(210, 210)];
    UIImage *baseImage = [thumbnail0 imageByCroppingImageToSize:CGSizeMake(210, 210)];
    UIImage *thumbnail = [baseImage imageWaterMarkWithImage:[UIImage imageNamed:@"iconVideoCamera"] imageRect:CGRectMake(20, 156, 44, 44) alpha:1]; // 146 = 210 - 44 - 10 也就是水印距离底部20pix
    [UIImageJPEGRepresentation(thumbnail, 0.5) writeToFile:thumbnailPath atomically:YES];
}

- (void)saveNamedImageToDocument:(UIImage *)image {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 存储原图文件
        NSString *imagePath = [[NSString imagePath] stringByAppendingPathComponent:self];
        
        CGFloat longside;
        if (image.size.width > image.size.height) {
            longside = image.size.width;
        } else {
            longside = image.size.height;
        }
        
        if (longside > 1280) { // 如果长边比1280大, 那么久压缩图片尺寸
            UIImage *scaledImage = [UIImage imageWithImage:image scaledToNewSize:CGSizeMake(960, 960)]; // 960会是短边的距离,按照4:3的常规图像比例, 长边应该是960 / 3 * 4 = 1280
            [UIImageJPEGRepresentation(scaledImage, 0.5) writeToFile:imagePath atomically:YES];

        } else {
            [UIImageJPEGRepresentation(image, 0.5) writeToFile:imagePath atomically:YES];
        }
        
        // 存储缩略图文件
        NSString *thumbnailPath = [[NSString thumbnailPath] stringByAppendingPathComponent:self];
        UIImage *thumbnail0 = [UIImage imageWithImage:image scaledToNewSize:CGSizeMake(210, 210)];
        UIImage *thumbnail = [thumbnail0 imageByCroppingImageToSize:CGSizeMake(210, 210)];
        
        [UIImageJPEGRepresentation(thumbnail, 0.5) writeToFile:thumbnailPath atomically:YES];
    });
}

- (void)saveNamedVideoToDocument:(NSURL *)videoURL {
    
    // 储存视频文件
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
    NSString *path = [[NSString videoPath] stringByAppendingPathComponent:self];
    
    [videoData writeToFile:path atomically:NO];
    
    // 存储视频首帧图片到缓存
    NSString *framePath = [[NSString framePath] stringByAppendingPathComponent:self];
    UIImage *videoFrame = [UIImage thumbnailImageForVideo:videoURL atTime:0];
    
    CGFloat longside;
    if (videoFrame.size.width > videoFrame.size.height) {
        longside = videoFrame.size.width;
    } else {
        longside = videoFrame.size.height;
    }
    
    if (longside > 480) { // 如果长边比480大, 那么久压缩图片尺寸
        UIImage *scaledImage = [UIImage imageWithImage:videoFrame scaledToNewSize:CGSizeMake(360, 360)]; // 360会是短边的距离,按照4:3的常规图像比例, 长边应该是360 / 3 * 4 = 480
        [UIImageJPEGRepresentation(scaledImage, 0.5) writeToFile:framePath atomically:YES];
        
    } else {
        [UIImageJPEGRepresentation(videoFrame, 0.5) writeToFile:framePath atomically:YES];
    }
    
    // 存储缩略图文件到缓存
    NSString *thumbnailPath = [[NSString thumbnailPath] stringByAppendingPathComponent:self];
    UIImage *thumbnail0 = [UIImage imageWithImage:videoFrame scaledToNewSize:CGSizeMake(210, 210)];
    UIImage *baseImage = [thumbnail0 imageByCroppingImageToSize:CGSizeMake(210, 210)];
    UIImage *thumbnail = [baseImage imageWaterMarkWithImage:[UIImage imageNamed:@"iconVideoCamera"] imageRect:CGRectMake(20, 156, 44, 44) alpha:1]; // 146 = 210 - 44 - 10 也就是水印距离底部20pix
    [UIImageJPEGRepresentation(thumbnail, 0.5) writeToFile:thumbnailPath atomically:YES];

    // 清除掉tmp文件夹中的临时视频文件
    [NSString clearTmpDirectory];
}

#pragma 清除临时文件夹
+ (void)clearTmpDirectory
{
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}


#pragma mark - 删除多媒体文件
- (void)deleteNamedVideoFromDocument {
    
    // 从数据库媒体表中删除视频条目
    [CLDataSaveTool deleteMediaByName:self];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSFileManager* fileManager=[NSFileManager defaultManager];
        NSString *uniquePath = [[NSString videoPath] stringByAppendingPathComponent:self];
        
        // 判定视频是否存在
        BOOL fileExists=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (!fileExists) {
//            NSLog(@"file does not exist");
            return ;
        }else {
//            NSLog(@" file exists");
            BOOL fileDeleted= [fileManager removeItemAtPath:uniquePath error:nil];
            
            if (fileDeleted) {
                NSLog(@"video deleted");
                
                // 如果视频删除成功,则删除缩略图和首帧图
                NSString *thumbnailPath = [[NSString thumbnailPath] stringByAppendingPathComponent:self];
                
                // 判定图片是否存在
                BOOL fileExists=[[NSFileManager defaultManager] fileExistsAtPath:thumbnailPath];
                if (!fileExists) {
                    //            NSLog(@"file does not exist");
                    return ;
                }else {
                    //            NSLog(@" file exists");
                    BOOL fileDeleted= [fileManager removeItemAtPath:thumbnailPath error:nil];
                    if (fileDeleted) {
                        NSLog(@"thumbnail deleted");
                    }else {
                        NSLog(@"deleting thumbnail failed");
                    }
                }
                
                NSString *framePath = [[NSString framePath] stringByAppendingPathComponent:self];
                // 判定图片是否存在
                BOOL fileExists1=[[NSFileManager defaultManager] fileExistsAtPath:framePath];
                if (!fileExists1) {
                    //            NSLog(@"file does not exist");
                    return ;
                }else {
                    //            NSLog(@" file exists");
                    BOOL fileDeleted= [fileManager removeItemAtPath:framePath error:nil];
                    if (fileDeleted) {
                        NSLog(@"frame deleted");
                    }else {
                        NSLog(@"deleting frame failed");
                    }
                }
                
            }else {
                NSLog(@"deleting video failed");
            }
        }
    });

}

- (void)deleteNamedImageFromDocument {
    
    // 从数据库媒体表中删除图片条目
    [CLDataSaveTool deleteMediaByName:self];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSFileManager* fileManager=[NSFileManager defaultManager];
        NSString *uniquePath = [[NSString imagePath] stringByAppendingPathComponent:self];
        
        // 判定图片是否存在
        BOOL fileExists=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (!fileExists) {
            //            NSLog(@"file does not exist");
            return ;
        }else {
            //            NSLog(@" file exists");
            BOOL fileDeleted= [fileManager removeItemAtPath:uniquePath error:nil];
            if (fileDeleted) {
                NSLog(@"image deleted");
                
                // 如果视频删除成功,则删除缩略图
                NSString *thumbnailPath = [[NSString thumbnailPath] stringByAppendingPathComponent:self];
                // 判定图片是否存在
                BOOL fileExists=[[NSFileManager defaultManager] fileExistsAtPath:thumbnailPath];
                if (!fileExists) {
                    //            NSLog(@"file does not exist");
                    return ;
                }else {
                    //            NSLog(@" file exists");
                    BOOL fileDeleted= [fileManager removeItemAtPath:thumbnailPath error:nil];
                    if (fileDeleted) {
                        NSLog(@"thumbnail deleted");
                    }else {
                        NSLog(@"deleting thumbnail failed");
                    }
                }
            }else {
                NSLog(@"deleting image failed");
            }
        }
    });
}


#pragma mark - 获取多媒体文件
- (AVPlayerItem *)getNamedAVPlayerItem {
    NSString *path = [[NSString videoPath] stringByAppendingPathComponent:self];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    //创建item
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    
    return playerItem;
}

// 获取缓存中的首帧图片
- (UIImage *)getNamedVideoFrame {
    
    NSString *path = [[NSString framePath] stringByAppendingPathComponent:self];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    if (image == nil) {
        
        [self saveNamedVideoFrameToCache];
        image = [UIImage imageWithContentsOfFile:path];
    }
    return image;
}

- (UIImage *)getNamedImage {
    NSString *path = [[NSString imagePath] stringByAppendingPathComponent:self];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;    
}

- (UIImage *)getNamedVideoThumbnail { // 获取视频缩略图,如果没有就创建一份到缓存中
    NSString *path = [[NSString thumbnailPath] stringByAppendingPathComponent:self];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    if (image == nil) {
        
        [self saveNamedVideoThumbnailImageToCache];
        image = [UIImage imageWithContentsOfFile:path];
    }
    return image;
}

- (UIImage *)getNamedImageThumbnail { // 获取图片缩略图,如果没有就创建一份到缓存中
    NSString *path = [[NSString thumbnailPath] stringByAppendingPathComponent:self];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    if (image == nil) {
        
        [self saveNamedImageThumbnailImageToCache];
        image = [UIImage imageWithContentsOfFile:path];
    }
    
    return image;
}

@end
