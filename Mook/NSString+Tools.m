//
//  NSString+Tools.m
//  新浪微博页面
//
//  Created by 陈林 on 15/10/21.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "NSString+Tools.h"
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
    
    UIColor *color = kAppThemeColor;
    if (color == nil) {
        color = [UIColor flatBlueColorDark];
    }
    NSDictionary * firstAttributes = @{ NSFontAttributeName:kFontSys13,NSForegroundColorAttributeName:color,};
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


@end
