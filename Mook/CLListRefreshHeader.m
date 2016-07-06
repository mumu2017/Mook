//
//  CLListRefreshHeader.m
//  Mook
//
//  Created by 陈林 on 16/7/6.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLListRefreshHeader.h"

@interface CLListRefreshHeader()
{
    __unsafe_unretained UIImageView *_arrowView;
}

@end

@implementation CLListRefreshHeader
#pragma mark - 懒加载子控件
- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[NSBundle mj_arrowImage]];
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        CGFloat stateWidth = self.stateLabel.mj_textWith;
        CGFloat timeWidth = 0.0;
        if (!self.lastUpdatedTimeLabel.hidden) {
            timeWidth = self.lastUpdatedTimeLabel.mj_textWith;
        }
        CGFloat textWidth = MAX(stateWidth, timeWidth);
        arrowCenterX -= textWidth / 2 + self.labelLeftInset;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    
    self.arrowView.tintColor = self.stateLabel.textColor;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState

    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            if (self.state != MJRefreshStateIdle) return;

        } else {

            self.arrowView.hidden = NO;
            self.arrowView.transform = CGAffineTransformIdentity;

        }
    } else if (state == MJRefreshStatePulling) {

        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {

        self.arrowView.hidden = YES;
    }
}

@end
