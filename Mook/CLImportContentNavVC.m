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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelf) name:@"dismissImportContentVC" object:nil];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dismissSelf {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
