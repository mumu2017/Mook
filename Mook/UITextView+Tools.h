//
//  UITextView+Tools.h
//  Deck
//
//  Created by 陈林 on 15/11/5.
//  Copyright © 2015年 ChenLin. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface UITextView (Tools)

- (void)placeCursorAtEnd;

- (void) addPlaceHolderWithText:(NSString *)text andFont:(UIFont *)font;
- (void) setPlaceHolderText:(NSString *)text;
- (void) showPlaceHolder;
- (void) hidePlaceHolder;

// 自动计算给定字体文本在给定绘制Size下的最佳尺寸
+ (CGSize) sizeThatFits:(CGSize)size forText:(NSString *)text withFont:(UIFont *)font;

@end
