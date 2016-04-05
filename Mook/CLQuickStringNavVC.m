//
//  CLQuickStringNavVC.m
//  Mook
//
//  Created by 陈林 on 16/4/5.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLQuickStringNavVC.h"
#import "CLQuickStringVC.h"

@interface CLQuickStringNavVC()<CLQuickStringVCDelegate>

@end

@implementation CLQuickStringNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = kMenuBackgroundColor;
    
    // Do any additional setup after loading the view.
    UIViewController *rootViewController = [[self viewControllers] firstObject];
    
    if ([rootViewController isKindOfClass:[CLQuickStringVC class]]) {
        
        CLQuickStringVC *vc  = (CLQuickStringVC *)rootViewController;
        vc.isPicking = YES;
        vc.delegate = self;
    }
}

- (void)quickStringVC:(CLQuickStringVC *)quickStringVC didSelectQuickString:(NSString *)quickString {
    
    if ([self.navDelegate respondsToSelector:@selector(quickStringNavVC:didSelectQuickString:)]) {
        [self.navDelegate quickStringNavVC:self didSelectQuickString:quickString];
    }
}

@end
