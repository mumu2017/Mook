//
//  UIButton+HitTest.m
//  Categories
//
//  Created by Ye Xiaodong on 12-11-1.
//  Copyright (c) 2012年 CDCKT. All rights reserved.
//

#import "UIButton+HitTest.h"
#import <objc/runtime.h>

@implementation UIButton (HitTest)

@dynamic hitTestEdgeInsets;

static char HIT_TEST_EDGE_INSETS_IDENTIFER;

- (void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &HIT_TEST_EDGE_INSETS_IDENTIFER, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &HIT_TEST_EDGE_INSETS_IDENTIFER);
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (value) {
         [value getValue:&edgeInsets];
    }
    return edgeInsets;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero)) {
        return [super hitTest:point withEvent:event];
    }
    // The point that is being tested is relative to self, so remove origin
    CGRect relativeFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    if(CGRectContainsPoint(hitFrame, point) && !self.hidden && self.enabled) {
        return self;
    }
    return nil;
}

@end
