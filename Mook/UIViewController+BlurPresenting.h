//
//  UIViewController+BlurPresenting.h
//  Mook
//
//  Created by 陈林 on 16/6/23.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLAudioPlayVC;

@interface UIViewController (BlurPresenting)

- (void)presentNavigationViewControllerAnimated:(nonnull UIViewController *)controller;

- (void)presentNavigationViewControllerAnimated:(nonnull UIViewController *)controller barStyle:(UIBarStyle)barStyle;

- (void)presentBlurredNavigationViewControllerAnimated:(nonnull UIViewController *)controller  barStyle:(UIBarStyle)barStyle;

- (void)presentAudioPlayViewControllerAnimated:(nonnull CLAudioPlayVC *)audioPlayVC;

- (void)presentBlurredAudioPlayViewControllerAnimated:(nonnull CLAudioPlayVC *)audioPlayVC;

@end
