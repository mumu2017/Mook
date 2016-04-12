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
    
    self.navigationBar.barTintColor = [UIColor flatSkyBlueColor];
    // Do any additional setup after loading the view.
    UIViewController *rootViewController = [[self viewControllers] firstObject];
    
    if ([rootViewController isKindOfClass:[CLImportContentVC class]]) {
        
        CLImportContentVC *vc  = (CLImportContentVC *)rootViewController;
        
        vc.contentType = self.contentType;
        
        vc.routineModel = self.routineModel;
        vc.ideaObjModel = self.ideaObjModel;
        vc.sleightObjModel = self.sleightObjModel;
        vc.propObjModel = self.propObjModel;
        vc.linesObjModel = self.linesObjModel;
        vc.date = self.date;
        
    }

}


@end
