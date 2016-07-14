//
//  CLWebViewController.m
//  Mook
//
//  Created by 陈林 on 16/7/1.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLWebViewController.h"
#import "UIButton+HitTest.h"
#import "HTMLReader.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface CLWebViewController()

{
    UIBarButtonItem *_backItem;
    UIBarButtonItem *_closeItem;
    UIBarButtonItem *_negativeSpacer;
    UIBarButtonItem *_collectItem;
    NSInteger _scale;
}

@end

@implementation CLWebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _scale = 15;
    
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
    
    _collectItem = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(collectWebNote)];

    self.navigationItem.leftBarButtonItems = @[_negativeSpacer, _backItem];
    self.navigationItem.rightBarButtonItem = _collectItem;

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

#define DEFAULTWEBVIEWFONTSIZE 14

- (void)collectWebNote {
    

    NSString *link = [@"http://www.readability.com/m?url=" stringByAppendingString:self.URL.absoluteString];
    NSURL *newUrl = [NSURL URLWithString:link];
    NSURLRequest *request = [NSURLRequest requestWithURL:newUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60*24];

    [self.webView loadRequest:request];
    
    
//    NSString *jsForTextSize = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'", _scale*100/DEFAULTWEBVIEWFONTSIZE];
//    [self.webView evaluateJavaScript:jsForTextSize completionHandler:^(id _Nullable object, NSError * _Nullable error) {
//        _scale += 5;
//    }];
    
    
    // Load a web page.
//
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithURL:self.URL completionHandler:
//      ^(NSData *data, NSURLResponse *response, NSError *error) {
//          NSString *contentType = nil;
//          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
//              NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
//              contentType = headers[@"Content-Type"];
//          }
//          HTMLDocument *home = [HTMLDocument documentWithData:data
//                                            contentTypeHeader:contentType];
//          HTMLElement *div = [home firstNodeMatchingSelector:@".repository-meta-content"];
//          NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//          
//          NSString *string = [div.textContent stringByTrimmingCharactersInSet:whitespace];
//          
//          NSLog(@"webNote == %@", string);
//          // => A WHATWG-compliant HTML parser in Objective-C.
//      }] resume];
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
