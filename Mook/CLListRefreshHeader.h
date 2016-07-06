//
//  CLListRefreshHeader.h
//  Mook
//
//  Created by 陈林 on 16/7/6.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

// 改掉了MJRefreshConstant.h中的一下动画时长属性:
// const CGFloat MJRefreshFastAnimationDuration = 0.0;
// const CGFloat MJRefreshSlowAnimationDuration = 0.0;
#import <MJRefresh/MJRefresh.h>

@interface CLListRefreshHeader : MJRefreshStateHeader

@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */

@end
