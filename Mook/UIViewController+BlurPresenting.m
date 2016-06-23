//
//  UIViewController+BlurPresenting.m
//  Mook
//
//  Created by 陈林 on 16/6/23.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "UIViewController+BlurPresenting.h"
#import "CLAudioPlayVC.h"

@implementation UIViewController (BlurPresenting)

- (void)presentNavigationViewControllerAnimated:(nonnull UIViewController *)controller
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    navigationController.toolbarHidden = NO;
    navigationController.toolbar.translucent = YES;
    
    navigationController.navigationBar.translucent = YES;
    
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navigationController.toolbar.hidden = YES;

    [self presentViewController:navigationController animated:YES completion:^{
    }];
}

- (void)presentNavigationViewControllerAnimated:(nonnull UIViewController *)controller barStyle:(UIBarStyle)barStyle
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    navigationController.toolbarHidden = NO;
    navigationController.toolbar.translucent = YES;
    
    navigationController.navigationBar.translucent = YES;
    
    UIColor *normalTintColor;
    
    if (barStyle == UIBarStyleDefault)
    {
        normalTintColor = [UIColor colorWithRed:0 green:0.5 blue:1.0 alpha:1.0];
        
        navigationController.navigationBar.barStyle = UIBarStyleDefault;
        navigationController.toolbar.barStyle = UIBarStyleDefault;
        navigationController.navigationBar.tintColor = normalTintColor;        navigationController.toolbar.tintColor = normalTintColor;
    }
    else
    {
        normalTintColor = [UIColor whiteColor];

        navigationController.navigationBar.barStyle = UIBarStyleBlack;
        navigationController.toolbar.barStyle = UIBarStyleBlack;
        navigationController.navigationBar.tintColor = normalTintColor;
        navigationController.toolbar.tintColor = normalTintColor;

    }
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    controller.view.tintColor = normalTintColor;

//    controller.barStyle = controller.barStyle;        //This line is used to refresh UI of Audio Recorder View Controller
    [self presentViewController:navigationController animated:YES completion:^{
    }];
}

- (void)presentBlurredNavigationViewControllerAnimated:(nonnull UIViewController *)controller  barStyle:(UIBarStyle)barStyle
{

    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
    visualEffectView.frame = [UIScreen mainScreen].bounds;
    
    controller.view = visualEffectView;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    navigationController.toolbarHidden = NO;
    navigationController.toolbar.translucent = YES;
    [navigationController.toolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationController.toolbar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    
    navigationController.navigationBar.translucent = YES;
    [navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navigationController.navigationBar setShadowImage:[UIImage new]];
    
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    UIColor *normalTintColor;
    
    if (barStyle == UIBarStyleDefault)
    {
        normalTintColor = [UIColor colorWithRed:0 green:0.5 blue:1.0 alpha:1.0];
        
        navigationController.navigationBar.barStyle = UIBarStyleDefault;
        navigationController.toolbar.barStyle = UIBarStyleDefault;
        navigationController.navigationBar.tintColor = normalTintColor;        navigationController.toolbar.tintColor = normalTintColor;
    }
    else
    {
        normalTintColor = [UIColor whiteColor];
        
        navigationController.navigationBar.barStyle = UIBarStyleBlack;
        navigationController.toolbar.barStyle = UIBarStyleBlack;
        navigationController.navigationBar.tintColor = normalTintColor;
        navigationController.toolbar.tintColor = normalTintColor;
        
    }
    
    controller.view.tintColor = normalTintColor;
//    audioCropperViewController.barStyle = audioCropperViewController.barStyle;        //This line is used to refresh UI of Audio Recorder View Controller
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)presentAudioPlayViewControllerAnimated:(nonnull CLAudioPlayVC *)audioPlayVC
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:audioPlayVC];
    
    navigationController.toolbarHidden = NO;
    navigationController.toolbar.translucent = YES;
    
    navigationController.navigationBar.translucent = YES;
    
    audioPlayVC.barStyle = audioPlayVC.barStyle;        //This line is used to refresh UI of Audio Recorder View Controller
    [self presentViewController:navigationController animated:YES completion:^{
    }];
}

- (void)presentBlurredAudioPlayViewControllerAnimated:(nonnull CLAudioPlayVC *)audioPlayVC
{
    audioPlayVC.blurrEnabled = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:audioPlayVC];
    
    navigationController.toolbarHidden = NO;
    navigationController.toolbar.translucent = YES;
    [navigationController.toolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationController.toolbar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    
    navigationController.navigationBar.translucent = YES;
    [navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navigationController.navigationBar setShadowImage:[UIImage new]];
    
    navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    audioPlayVC.barStyle = audioPlayVC.barStyle;        //This line is used to refresh UI of Audio Recorder View Controller
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
