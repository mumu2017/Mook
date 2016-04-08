//
//  CLSettingVC.h
//  Mook
//
//  Created by 陈林 on 15/11/20.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/iflyMSC.h"

@class CLSettingVC;

@protocol CLSettingVCDelegate <NSObject>

@optional
//- (void)settingVCDidClickDoneButton:(CLSettingVC *)settingVC;

@end

@interface CLSettingVC : UITableViewController

@property (nonatomic, copy) NSString *password;
@property (nonatomic, weak) id<CLSettingVCDelegate> delegate;
@end
