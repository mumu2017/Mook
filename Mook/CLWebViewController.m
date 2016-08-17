//
//  CLWebViewController.m
//  Mook
//
//  Created by 陈林 on 16/7/1.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLWebViewController.h"
#import "UIButton+HitTest.h"
#import "CLWebSiteModel.h"
#import "CLDataSaveTool.h"

#define kBackButtonHitTestEdgeInsets UIEdgeInsetsMake(-15, -15, -15, -15)

@interface CLWebViewController()

{
    UIBarButtonItem *_backItem;
    UIBarButtonItem *_closeItem;
    UIBarButtonItem *_negativeSpacer;
    UIBarButtonItem *_collectItem;
    
    NSInteger _scale;
}

@property (strong, nonatomic) CLWebSiteModel *matchModel;

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
    [customButton setTitle:NSLocalizedString(@" 返回", nil) forState:UIControlStateNormal];
    [customButton setTintColor:kTintColor];
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

    _closeItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"关闭", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeWebVC)];
    
    if (self.isAddingWebSite) {
        _collectItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"添加书签", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addWebSiteWithSearching)];

    } else {
        
        _collectItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"添加", nil) style:UIBarButtonItemStylePlain target:self action:@selector(collectWebNote)];

    }
    
    self.navigationItem.leftBarButtonItems = @[_negativeSpacer, _backItem];
    self.navigationItem.rightBarButtonItem = _collectItem;

    // 设置webView的属性
    self.showPageTitleAndURL = NO;
    self.navigationItem.title = self.webView.title;
    self.supportedWebNavigationTools = DZNWebNavigationToolAll;
    self.supportedWebActions = DZNWebActionAll;
    self.showLoadingProgress = YES;
    self.allowHistory = YES;
    self.hideBarsWithGestures = NO;

    // 设置图标
    self.actionButtonImage = [[UIImage imageNamed:@"iconAction"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.backwardButtonImage = [[UIImage imageNamed:@"dzn_icn_toolbar_backward" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.forwardButtonImage = [[UIImage imageNamed:@"dzn_icn_toolbar_forward" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.reloadButtonImage = [[UIImage imageNamed:@"dzn_icn_toolbar_reload" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.stopButtonImage = [[UIImage imageNamed:@"dzn_icn_toolbar_stop" inBundle:[NSBundle bundleForClass:[DZNWebViewController class]] compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationController.toolbar.tintColor = kAppThemeColor;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES];
}

#define DEFAULTWEBVIEWFONTSIZE 14

- (void)addWebSiteWithSearching {
    
    [self addWebSite:kWebSiteModeSite];

}

- (void)collectWebNote {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* addWebSite = [UIAlertAction actionWithTitle:NSLocalizedString(@"添加当前地址到书签", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self addWebSite:kWebSiteModeSite];
    }];
    
    UIAlertAction* addWebNote = [UIAlertAction actionWithTitle:NSLocalizedString(@"添加当前地址到收藏", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self addWebSite:kWebSiteModeNotes];

    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:addWebSite];
    [alert addAction:addWebNote];

    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)collectWebNote1 {
    
//    [self addWebSite:];

//    NSString *link = [@"http://www.readability.com/m?url=" stringByAppendingString:self.URL.absoluteString];
//    NSURL *newUrl = [NSURL URLWithString:link];
//    NSURLRequest *request = [NSURLRequest requestWithURL:newUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60*24];
//
//    [self.webView loadRequest:request];
//    
    
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

- (void)addWebSite:(WebSiteMode)mode {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"添加网站", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"网站标题", nil);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textField.font = kFontSys16;
        textField.text = self.webView.title;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"网站地址", nil);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = kFontSys16;
        textField.text = self.webView.URL.absoluteString;

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UITextField *nameTF = alertController.textFields.firstObject;
            UITextField *urlTF = alertController.textFields.lastObject;
            
            NSString *name = @"";
            name = nameTF.text;
            NSString *urlString = @"";
            urlString = urlTF.text;
            
            CLWebSiteModel *webSite = [CLWebSiteModel modelWithTitle:name withUrlString:urlString];
            BOOL flag;

            if (mode == kWebSiteModeSite) {
                
                if (_webSiteList) {
                    [self.webSiteList addObject:webSite];
                }
                flag = [CLDataSaveTool updateWebSite:webSite];

            } else if (mode == kWebSiteModeNotes) {
                
                if (_webNoteList) {
                    [self.webNoteList addObject:webSite];
                }
                flag = [CLDataSaveTool updateWebNote:webSite];
                
            }
            
            if (flag) {
                
                [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"添加成功!", nil) hideAfterDelay:0.5f];
            } else {
                [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"添加失败, 请稍后重试!", nil)hideAfterDelay:0.5f];

            }
            
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
            
        });
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        UIAlertAction *okAction = alertController.actions.firstObject;
        UITextField *nameTF = alertController.textFields.firstObject;
        UITextField *urlTF = alertController.textFields.lastObject;
        okAction.enabled = (nameTF.text.length > 0 &&urlTF.text.length > 0 );
    }];
}


- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *nameTF = alertController.textFields.firstObject;
        UITextField *urlTF = alertController.textFields.lastObject;
        
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = (nameTF.text.length > 0 &&urlTF.text.length > 0 );
    }
}


- (void)goBackward {
    
    if (self.webView.canGoBack) {
        
        [self.webView goBack];
        
    } else {
        
        [self closeWebVC];
        
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

//    if (self.matchModel) {
//        
//        _collectItem = [[UIBarButtonItem alloc] initWithTitle:@"已收藏" style:UIBarButtonItemStylePlain target:self action:@selector(collectWebNote)];
//        
//        self.navigationItem.rightBarButtonItem = _collectItem;
//
//    }

}

- (CLWebSiteModel *)matchModel {
    
    return [CLDataSaveTool webSiteByUrlString:self.webView.URL.absoluteString];
}

@end
