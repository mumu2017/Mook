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
@implementation NSString (Tools)

// self就是调用当前成员方法的NSString对象
- (CGRect)textRectWithSize:(CGSize)size attributes:(NSDictionary *)attributes
{
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}

// 设定文本段落格式
- (NSAttributedString *)styledString {

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4];
    [style setParagraphSpacing:8];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, self.length)];
    
    return attrString;
}

// 获取日期时间+effect的content内容(显示在ListCell中)
- (NSAttributedString *)contentStringWithDate:(NSString *)date {
    NSMutableAttributedString * datePart = [[NSMutableAttributedString alloc] initWithString:date];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:kFontSys12,NSForegroundColorAttributeName:kTintColor,};
    [datePart setAttributes:firstAttributes range:NSMakeRange(0,datePart.length)];
    NSMutableAttributedString * contentPart = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary * secondAttributes = @{NSFontAttributeName:kFontSys14,NSForegroundColorAttributeName:[UIColor darkGrayColor],};
    [contentPart setAttributes:secondAttributes range:NSMakeRange(0,contentPart.length)];
    [datePart appendAttributedString:contentPart];
    
    return datePart;
}

// 获取ContentVC中的标题文本格式
+ (NSAttributedString *)titleString:(NSString *)title withDate:(NSDate *)dateInfo {
    title = [NSString stringWithFormat:@"\n%@", title];
    NSString *dateString = [self getDateString:dateInfo];
    NSMutableAttributedString * datePart = [[NSMutableAttributedString alloc] initWithString:dateString];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:kFontSys12,NSForegroundColorAttributeName:[UIColor darkGrayColor],};
    [datePart setAttributes:firstAttributes range:NSMakeRange(0,datePart.length)];
    NSMutableAttributedString * contentPart = [[NSMutableAttributedString alloc] initWithString:title];
    NSDictionary * secondAttributes = @{NSFontAttributeName:kBoldFontSys24,NSForegroundColorAttributeName:[UIColor blackColor],};
    [contentPart setAttributes:secondAttributes range:NSMakeRange(0,contentPart.length)];
    [datePart appendAttributedString:contentPart];
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4];

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
                return [NSString stringWithFormat:@"%ld小时之前",cmp.hour];
            }else if (cmp.minute > 1){
                return [NSString stringWithFormat:@"%ld分钟之前",cmp.minute];
            }else{
                return @"刚刚";
            }
            
        }else if ([date isYesterday]){ // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
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

+ (NSString *)videoPath {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *videoPath = [documentsDirectory stringByAppendingPathComponent:@"/Videos"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:videoPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:videoPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    return videoPath;
}

+ (NSString *)imagePath {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"/Images"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:imagePath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    return imagePath;
}

- (void)saveNamedImageToDocument:(UIImage *)image {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *path = [[NSString imagePath] stringByAppendingPathComponent:self];
        
        [UIImageJPEGRepresentation(image, 0.5) writeToFile:path atomically:YES];
     
    });
}

- (void)saveNamedVideoToDocument:(NSURL *)videoURL {
    
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
    NSString *path = [[NSString videoPath] stringByAppendingPathComponent:self];
    
    [videoData writeToFile:path atomically:NO];
    
    // 清除掉tmp文件夹中的临时视频文件
    [NSString clearTmpDirectory];

}

+ (void)clearTmpDirectory
{
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in tmpDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}



- (void)deleteNamedVideoFromDocument {
    
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
            }else {
                NSLog(@"deleting video failed");
            }
        }
    });

}

- (void)deleteNamedImageFromDocument {
    
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
            }else {
                NSLog(@"deleting image failed");
            }
        }
    });
}


- (AVPlayerItem *)getNamedAVPlayerItem {
    NSString *path = [[NSString videoPath] stringByAppendingPathComponent:self];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    //创建item
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    
    return playerItem;
}

- (UIImage *)getFirstFrameOfNamedVideo {
    NSString *path = [[NSString videoPath] stringByAppendingPathComponent:self];
    
    NSURL *videoURL = [NSURL fileURLWithPath:path];
    
    UIImage *videoImage = [UIImage thumbnailImageForVideo:videoURL atTime:0];
    
    return videoImage;
}

- (UIImage *)getNamedImage {
    NSString *path = [[NSString imagePath] stringByAppendingPathComponent:self];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;    
}
                   
@end
