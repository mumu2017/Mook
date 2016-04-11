//
//  CLHomeNavVC.m
//  Mook
//
//  Created by 陈林 on 16/3/26.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLHomeNavVC.h"
#import "CLListVC.h"

@interface CLHomeNavVC ()

@property (nonatomic, assign) BOOL isLaunched;

@end

@implementation CLHomeNavVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.barTintColor = [UIColor flatSkyBlueColorDark];
    
    // Do any additional setup after loading the view.
    UIViewController *rootViewController = [[self viewControllers] firstObject];
    
    if ([rootViewController isKindOfClass:[CLListVC class]]) {
        
        CLListVC *vc  = (CLListVC *)rootViewController;
        vc.listType = kListTypeAll;
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
