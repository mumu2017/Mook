//
//  CLNewShowNavVc.m
//  Mook
//
//  Created by 陈林 on 16/3/31.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLNewShowNavVc.h"

@interface CLNewShowNavVC ()

@end

@implementation CLNewShowNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController *rootViewController = [[self viewControllers] firstObject];
    
    if ([rootViewController isKindOfClass:[CLNewShowVC class]]) {
        
        CLNewShowVC *vc  = (CLNewShowVC *)rootViewController;
        vc.showModel = self.showModel;
        vc.title = kNewShowInfoText;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelfWhenModallyPresented) name:kDismissNewShowNavVCNotification object:nil];
}


- (void)dismissSelfWhenModallyPresented {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
