//
//  UIView+Tools.m
//  Deck
//
//  Created by 陈林 on 15/11/10.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "UIView+Tools.h"

#define kBottomLineTag      99

@implementation UIView (Tools)

- (void) showBorder {
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
}

- (void) showWhiteBorder {
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 5.0;
    self.layer.cornerRadius = 15.0;
    self.layer.masksToBounds = YES;
}

- (void) hideBorder {
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)highlightBorder {
//    self.layer.borderColor = kBarColor.CGColor;
//    self.layer.borderWidth = 1.5;
}

- (void)unhighlightBorder {
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.layer.borderWidth = 1.0;
}

- (void) showBottomLine {
    
    UIView *bottomLine;
    // 先检查是否已经有bottomLine
    for (UIView *view in self.subviews) {
        if (view.tag == kBottomLineTag) {
            bottomLine = view;
        }
    }
    // 如果没有,先添加bottomLine
    if (bottomLine == nil) {
        bottomLine = [[UIView alloc] initWithFrame:CGRectMake(5, self.frame.size.height-1, self.frame.size.width-10, 1)];
        
        [self addSubview:bottomLine];
        
        bottomLine.tag = kBottomLineTag;
        bottomLine.backgroundColor = [UIColor blackColor];
    }
    // 将bottomLine设为可见
    [UIView animateWithDuration:0.25 animations:^{
        bottomLine.hidden = NO;
    }];
    
}

- (void) hideBottomLine {
    UIView *bottomLine;
    // 先检查有没有bottomLine
    for (UIView *view in self.subviews) {
        if (view.tag == kBottomLineTag) {
            bottomLine = view;
        }
    }
    // 如果有,设为不可见
    if (bottomLine) {
        [UIView animateWithDuration:0.25 animations:^{
            bottomLine.hidden = YES;
        }];
    } else {
        return;
    }
    
}

- (void)setBottomLineTransform:(CGAffineTransform)transform {
    UIView *bottomLine;
    
    for (UIView *view in self.subviews) {
        if (view.tag == kBottomLineTag) {
            bottomLine = view;
        }
    }
    
    if (bottomLine) {
        
        [UIView animateWithDuration:0.25 animations:^{
            bottomLine.transform = transform;
        }];
        
    } else {
        return;
    }
    
}

- (UIView *) bottomLine {
    UIView *bottomLine;
    // 先检查有没有bottomLine
    for (UIView *view in self.subviews) {
        if (view.tag == kBottomLineTag) {
            bottomLine = view;
        }
    }
    return bottomLine;
}




@end
