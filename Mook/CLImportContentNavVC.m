//
//  CLImportContentNavVC.m
//  Mook
//
//  Created by 陈林 on 16/4/11.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLImportContentNavVC.h"
#import "CLImportContentVC.h"

@interface CLImportContentNavVC ()

@end

@implementation CLImportContentNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    UIViewController *rootViewController = [[self viewControllers] firstObject];
    
    if ([rootViewController isKindOfClass:[CLImportContentVC class]]) {
        
        CLImportContentVC *vc  = (CLImportContentVC *)rootViewController;
        vc.importDict = self.importDict;
        
    }

}


@end
