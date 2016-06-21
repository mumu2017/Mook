//
//  CLCameraRecorderVC.h
//  Mook
//
//  Created by 陈林 on 16/6/21.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLRecorderNavVC.h"

@interface CLCameraRecorderVC : UIViewController

+ (void)recordFromCurrentViewController:(UIViewController *)controller completion:(completionBlock)completion;


@end
