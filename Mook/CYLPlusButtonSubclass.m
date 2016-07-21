//
//  CYLPlusButtonSubclass.m
//  DWCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 ( http://weibo.com/luohanchenyilong/ ) on 15/10/24.
//  Copyright (c) 2015年 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLPlusButtonSubclass.h"
#import "CYLTabBarController.h"
#import "CLNewEntryTool.h"

#import "CLHomeNavVC.h"
#import "CLMediaNavVC.h"
#import "CLDiscoverNavVC.h"
#import "CLSettingNavVC.h"

#import "CLAllItemsListVC.h"
#import "CLMediaVC.h"
#import "CLWebVC.h"
#import "CLSettingVC.h"

@interface CYLPlusButtonSubclass ()<UIActionSheetDelegate> {
    
    CGFloat _buttonImageHeight;
}

@end

@implementation CYLPlusButtonSubclass

#pragma mark -
#pragma mark - Life Cycle

+ (void)load {
    [super registerPlusButton];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

//上下结构的 button
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    // 控件大小,间距大小
//    // 注意：一定要根据项目中的图片去调整下面的0.7和0.9，Demo之所以这么设置，因为demo中的 plusButton 的 icon 不是正方形。
//    CGFloat const imageViewEdgeWidth   = self.bounds.size.width * 0.7;
//    CGFloat const imageViewEdgeHeight  = imageViewEdgeWidth * 0.9;
//    
//    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
//    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
//    CGFloat const verticalMarginT = self.bounds.size.height - labelLineHeight - imageViewEdgeWidth;
//    CGFloat const verticalMargin  = verticalMarginT / 2;
//    
//    // imageView 和 titleLabel 中心的 Y 值
//    CGFloat const centerOfImageView  = verticalMargin + imageViewEdgeWidth * 0.5;
//    CGFloat const centerOfTitleLabel = imageViewEdgeWidth  + verticalMargin * 2 + labelLineHeight * 0.5 + 5;
//    
//    //imageView position 位置
//    self.imageView.bounds = CGRectMake(0, 0, imageViewEdgeWidth, imageViewEdgeHeight);
//    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
//    
//    //title position 位置
//    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
//    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
//}

#pragma mark -
#pragma mark - CYLPlusButtonSubclassing Methods

/*
 *
 Create a custom UIButton with title and add it to the center of our tab bar
 *
 */
//+ (id)plusButton {
//    
//    CYLPlusButtonSubclass *button = [[CYLPlusButtonSubclass alloc] init];
//    UIImage *buttonImage = [UIImage imageNamed:@"post_normal"];
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    [button setTitle:@"发布" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    
//    [button setTitle:@"选中" forState:UIControlStateSelected];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
//
//    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
//    [button sizeToFit]; // or set frame in this way `button.frame = CGRectMake(0.0, 0.0, 250, 100);`
////    button.frame = CGRectMake(0.0, 0.0, 250, 100);
////    button.backgroundColor = [UIColor redColor];
//    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
/*
 *
 Create a custom UIButton without title and add it to the center of our tab bar
 *
 */
+ (id)plusButton
{

//    UIImage *buttonImage = [UIImage imageWithColor:[UIColor blackColor] size:CGSizeMake(kScreenW/5, 40)];
//    UIImage *highlightImage = [UIImage imageWithColor:[UIColor blackColor] size:CGSizeMake(kScreenW/5, 40)];
    
    
    
    UIImage *iconImage = [[UIImage imageNamed:@"addMedia"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *highlightIconImage = [[UIImage imageNamed:@"addMedia"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    CYLPlusButtonSubclass *button = [CYLPlusButtonSubclass buttonWithType:UIButtonTypeCustom];
    
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, kScreenW/5, 44);
    button.tintColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor blackColor];
    

    [button setImage:iconImage forState:UIControlStateNormal];
    [button setImage:highlightIconImage forState:UIControlStateHighlighted];
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];

    
//    UIImage *buttonImage = [UIImage imageNamed:@"post_normal"];
//    UIImage *highlightImage = [UIImage imageNamed:@"post_normal"];
//
//    CYLPlusButtonSubclass* button = [CYLPlusButtonSubclass buttonWithType:UIButtonTypeCustom];
//
//    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
//    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

#pragma mark -
#pragma mark - Event Response

- (void)clickPublish {
    
    CYLTabBarController *tabBarController = [self cyl_tabBarController];
    UIViewController *viewController = tabBarController.selectedViewController;
    
    if ([viewController isKindOfClass:[CLHomeNavVC class]]) {
        
        CLHomeNavVC *navVC = (CLHomeNavVC *)viewController;
        CLAllItemsListVC *vc = (CLAllItemsListVC *)navVC.viewControllers.firstObject;
        
        [CLNewEntryTool addNewEntryWithEntryMode:kNewEntryModeText inViewController:vc listType:vc.listType];
        
    } else if ([viewController isKindOfClass:[CLMediaNavVC class]]) {
        
        CLMediaNavVC *navVC = (CLMediaNavVC *)viewController;
        CLMediaVC *vc = (CLMediaVC *)navVC.viewControllers.firstObject;
        
        [CLNewEntryTool addNewEntryWithEntryMode:kNewEntryModeMedia inViewController:vc listType:kListTypeAll];
        
    } else if ([viewController isKindOfClass:[CLDiscoverNavVC class]]) {
        
        CLDiscoverNavVC *navVC = (CLDiscoverNavVC *)viewController;
        CLWebVC *vc = (CLWebVC *)navVC.viewControllers.firstObject;

        [vc addWebSite];

    } else if ([viewController isKindOfClass:[CLSettingNavVC class]]) {
        
        CLSettingNavVC *navVC = (CLSettingNavVC *)viewController;
        CLSettingVC *vc = (CLSettingVC *)navVC.viewControllers.firstObject;
        
        [CLNewEntryTool addNewEntryWithEntryMode:kNewEntryModeText inViewController:vc listType:kListTypeAll];

    }
    
    
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex = %@", @(buttonIndex));
}

#pragma mark - CYLPlusButtonSubclassing

//+ (UIViewController *)plusChildViewController {
//    UIViewController *plusChildViewController = [[UIViewController alloc] init];
//    plusChildViewController.view.backgroundColor = [UIColor redColor];
//    plusChildViewController.navigationItem.title = @"PlusChildViewController";
//    UIViewController *plusChildNavigationController = [[UINavigationController alloc]
//                                                   initWithRootViewController:plusChildViewController];
//    return plusChildNavigationController;
//}


//+ (NSUInteger)indexOfPlusButtonInTabBar {
//    return 4;
//}

//+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
//    return  0.3;
//}
//
//+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight {
//    return  -10;
//}

@end
