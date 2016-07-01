//
//  CLWebViewController.m
//  Mook
//
//  Created by 陈林 on 16/7/1.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLWebViewController.h"

@interface CLWebViewController()

{
    UIBarButtonItem *_backItem;
    UIBarButtonItem *_closeItem;
    
}

@end

@implementation CLWebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    _backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBackward)];
    
    _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeWebVC)];
    
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    self.fd_interactivePopDisabled = YES;
    
    self.showPageTitleAndURL = YES;
    self.supportedWebNavigationTools = DZNWebNavigationToolAll;
    self.supportedWebActions = DZNWebActionAll;
    self.showLoadingProgress = YES;
    self.allowHistory = YES;
    self.hideBarsWithGestures = YES;
    self.showPageTitleAndURL = NO;
    self.actionButtonImage = [UIImage imageNamed:@"iconAction"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"canGoBack"]) {
        
        
        //        NSString *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
//        BOOL canGoBack = [change objectForKey:NSKeyValueChangeNewKey];
        
        if (self.webView.canGoBack) {
            self.navigationItem.leftBarButtonItems = @[_backItem, _closeItem];

        } else {

            self.navigationItem.leftBarButtonItems = @[_backItem];
            
        }
    }
}

- (void) dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
}

- (void)goBackward {
    
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", self.webView.frame.size.width];
//    [self.webView stringByEvaluatingJavaScriptFromString:meta];
    [self.webView evaluateJavaScript:meta completionHandler:^(id _Nullable what, NSError * _Nullable error) {
        [self.webView reload];
    }];
}

//    if (self.webView.canGoBack) {
//        
//        [self.webView goBack];
//        
//    } else {
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    }
//}

- (void)closeWebVC {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
