//
//  CLNewEntryNavVC.m
//  Mook
//
//  Created by 陈林 on 16/3/23.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLNewEntryNavVC.h"

@interface CLNewEntryNavVC ()

@end

@implementation CLNewEntryNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController *rootViewController = [[self viewControllers] firstObject];
    
    if ([rootViewController isKindOfClass:[CLNewEntryVC class]]) {

        CLNewEntryVC *vc  = (CLNewEntryVC *)rootViewController;

        vc.editingContentType = self.editingContentType;
    
        vc.routineModel = self.routineModel;
        vc.ideaObjModel = self.ideaObjModel;
        vc.sleightObjModel = self.sleightObjModel;
        vc.propObjModel = self.propObjModel;
        vc.linesObjModel = self.linesObjModel;
        
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                vc.title = kNewRoutineInfoText;
                break;
                
            case kEditingContentTypeIdea:
                vc.title = kNewIdeaInfoText;
                break;
                
            case kEditingContentTypeSleight:
                vc.title = kNewSleightInfoText;
                break;
                
            case kEditingContentTypeProp:
                vc.title = kNewPropInfoText;
                break;
                
            case kEditingContentTypeLines:
                vc.title = kNewLinesInfoText;
                break;
                
            default:
                break;
        }

    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSelfWhenModallyPresented) name:kDismissNewEntryNavVCNotification object:nil];
}


- (void)dismissSelfWhenModallyPresented {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
