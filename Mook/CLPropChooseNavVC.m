//
//  CLPropChooseNavVC.m
//  Mook
//
//  Created by 陈林 on 16/1/2.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import "CLPropChooseNavVC.h"
#import "CLPropChooseVC.h"

@interface CLPropChooseNavVC ()<CLPropChooseVCDelegate>

@end

@implementation CLPropChooseNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *rootViewController = [[self viewControllers] firstObject];
    if ([rootViewController isKindOfClass:[CLPropChooseVC class]]) {
        CLPropChooseVC *vc = (CLPropChooseVC *)rootViewController;
        vc.delegate = self;
    }
}

- (void)propChooseVC:(CLPropChooseVC *)propChooseVC didSelectProp:(CLPropObjModel *)prop {
    
    if ([self.navDelegate respondsToSelector:@selector(propChooseNavVC:didSelectProp:)]) {
        [self.navDelegate propChooseNavVC:self didSelectProp:prop];
    }
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
