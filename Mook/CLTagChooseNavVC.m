//
//  CLTagChooseNavVC.m
//  Mook
//
//  Created by 陈林 on 16/1/2.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import "CLTagChooseNavVC.h"

@interface CLTagChooseNavVC ()<CLTagChooseVCDelegate>

@end

@implementation CLTagChooseNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *rootViewController = [[self viewControllers] firstObject];
    if ([rootViewController isKindOfClass:[CLTagChooseVC class]]) {
        CLTagChooseVC *vc = (CLTagChooseVC *)rootViewController;
        vc.delegate = self;
        vc.editingContentType = self.editingContentType;
    }
}

- (void)tagChooseVC:(CLTagChooseVC *)tagChooseVC didSelectTag:(NSString *)tag {
    if ([self.navDelegate respondsToSelector:@selector(tagChooseNavVC:didSelectTag:)]) {
        [self.navDelegate tagChooseNavVC:self didSelectTag:tag];
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
