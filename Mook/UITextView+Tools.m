//
//  UITextView+Tools.m
//  Deck
//
//  Created by 陈林 on 15/11/5.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "UITextView+Tools.h"
#import "MASonry.h"

#define kPlaceholderTag     98


@implementation UITextView (Tools)

//- (void)showShadow {
//    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
//}

- (void)placeCursorAtEnd {
    NSUInteger length = self.text.length;
    
    self.selectedRange = NSMakeRange(length, 0);
}


- (void) addPlaceHolderWithText:(NSString *)text andFont:(UIFont *)font {
    
    // make a placeholder label
//    CGFloat placeholderW = self.frame.size.width - 10;
//    CGRect placeholderFrame = CGRectMake(5, 10, placeholderW, self.frame.size.height-20);
//    UILabel *placeholder = [[UILabel alloc] initWithFrame:placeholderFrame];
    
    UILabel *placeholder = [[UILabel alloc] init];
    
    placeholder.numberOfLines = 0;
    // set the text attributes
    placeholder.backgroundColor = [UIColor clearColor];
    placeholder.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    placeholder.textAlignment = NSTextAlignmentLeft;
    placeholder.text = text;
    placeholder.font = font;
    // set placeholder tag
    placeholder.tag = kPlaceholderTag;
    // set visible
    placeholder.hidden = NO;
    // add placeholder into textview
    [self addSubview:placeholder];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 5, 10, 5);
    [placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(padding);
    }];
}

- (void)setPlaceHolderText:(NSString *)text {
    for (UILabel *placeholder in self.subviews) {
        if (placeholder.tag == kPlaceholderTag) {
            placeholder.text = text;
        }
    }
}

// set placeholder visible
- (void) showPlaceHolder {
    for (UIView *view in self.subviews) {
        if (view.tag == kPlaceholderTag) {
            view.hidden = NO;
        }
    }
}

// hide placeholder
- (void) hidePlaceHolder {
    for (UIView *view in self.subviews) {
        if (view.tag == kPlaceholderTag) {
            view.hidden = YES;
        }
    }
}

// 用sizeThatFits的方法,获取固定大小textView中文字的最佳大小
+ (CGSize) sizeThatFits:(CGSize)size forText:(NSString *)text withFont:(UIFont *)font {
    
    UITextView *textView = [[self alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    textView.text = text;
    textView.font = font;
    return [textView sizeThatFits:size];
}

@end
