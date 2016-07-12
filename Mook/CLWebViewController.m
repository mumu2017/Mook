//
//  CLWebViewController.m
//  Mook
//
//  Created by 陈林 on 16/7/1.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLWebViewController.h"
#import "UIButton+HitTest.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface CLWebViewController()

{
    UIBarButtonItem *_backItem;
    UIBarButtonItem *_closeItem;
    UIBarButtonItem *_negativeSpacer;
    
}

@end

@implementation CLWebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    // 自定义navigationBarItem
    UIImage *image = [[UIImage imageNamed:@"backArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton* customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setImage:image forState:UIControlStateNormal];
    [customButton setTitle:@" 返回" forState:UIControlStateNormal];
    customButton.titleLabel.font = kFontSys17;
    [customButton sizeToFit];

    customButton.hitTestEdgeInsets = kBackButtonHitTestEdgeInsets;

    [customButton addTarget:self action:@selector(goBackward) forControlEvents:UIControlEventTouchUpInside];
    
    _backItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];

    // 调整padding的item
    _negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    _negativeSpacer.width = -10;

    _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeWebVC)];
    
    self.navigationItem.leftBarButtonItems = @[_negativeSpacer, _backItem];

    // 设置webView的属性
    self.showPageTitleAndURL = NO;
    self.navigationItem.title = self.webView.title;
    self.supportedWebNavigationTools = DZNWebNavigationToolAll;
    self.supportedWebActions = DZNWebActionAll;
    self.showLoadingProgress = YES;
    self.allowHistory = YES;
    self.hideBarsWithGestures = YES;

    // 设置图标
    self.actionButtonImage = [[UIImage imageNamed:@"iconAction"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.backwardButtonImage = [[UIImage imageNamed:@"dzn_icn_toolbar_backward" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.forwardButtonImage = [[UIImage imageNamed:@"dzn_icn_toolbar_forward" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.reloadButtonImage = [[UIImage imageNamed:@"dzn_icn_toolbar_reload" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.stopButtonImage = [[UIImage imageNamed:@"dzn_icn_toolbar_stop" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationController.toolbar.tintColor = kAppThemeColor;
}

- (void)goBackward {
    
    if (self.webView.canGoBack) {
        
        [self.webView goBack];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)closeWebVC {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webView:(DZNWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [super webView:webView didFinishNavigation:navigation];
    self.navigationItem.title = webView.title;
    
    
    if (self.webView.canGoBack) {
        self.navigationItem.leftBarButtonItems = @[_negativeSpacer, _backItem, _closeItem];
        
        self.fd_interactivePopDisabled = YES;
        
    } else {
        
        self.navigationItem.leftBarButtonItems = @[_negativeSpacer, _backItem];
        self.fd_interactivePopDisabled = NO;
        
    }

    
}

@end
