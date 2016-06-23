//
//  NSString+Tools.h
//  新浪微博页面
//
//  Created by 陈林 on 15/10/21.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Tools)


// 计算当前字符串显示所需的实际frame,返回的值 x == 0, y == 0
- (CGRect)textRectWithSize:(CGSize)size attributes:(NSDictionary *)attributes;
- (NSAttributedString *)contentStringWithDate:(NSString *)date;

// 获取模型创建时间
+ (NSString *)getDateString:(NSDate *)date;

+ (NSAttributedString *)attributedStringWithFirstPart:(NSString *)part1 secondPart:(NSString *)part2 firstPartFont:(UIFont *)font1 firstPartColor:(UIColor *)color1 secondPardFont:(UIFont *)font2 secondPartColor:(UIColor *)color2;
// 组建标题
//+ (NSAttributedString *)titleString:(NSString *)title withDate:(NSDate *)date;
+ (NSAttributedString *)titleString:(NSString *)title withDate:(NSDate *)dateInfo tags:(NSArray *)tags;
// 设置string的行间距
- (NSAttributedString *)styledString;

@end
