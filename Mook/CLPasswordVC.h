//
//  CLPasswordVC.h
//  Mook
//
//  Created by 陈林 on 15/12/30.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLPasswordVC : UIViewController

@property (nonatomic, copy) NSString *password;

@property (nonatomic, copy) NSString *typedPassword;

@property (nonatomic, assign) BOOL isCreatingNewPassword;
@property (nonatomic, assign) BOOL isChangingPassword;

@end
