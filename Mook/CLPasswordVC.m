//
//  CLPasswordVC.m
//  Mook
//
//  Created by 陈林 on 15/12/30.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLPasswordVC.h"
#import "WJTouchID.h"

typedef enum {
    kInputOldPasswordMode = 1,
    kInputNewPasswordFirstTimeMode,
    kInputNewPasswordSecondTimeMode
} CreatNewPasswordMode;

@interface CLPasswordVC ()<WJTouchIDDelegate>


@property (weak, nonatomic) IBOutlet UILabel *inputNoticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultNoticeLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *reminderButton;

@property (weak, nonatomic) IBOutlet UILabel *icon1;
@property (weak, nonatomic) IBOutlet UILabel *icon2;
@property (weak, nonatomic) IBOutlet UILabel *icon3;
@property (weak, nonatomic) IBOutlet UILabel *icon4;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIButton *btn8;
@property (weak, nonatomic) IBOutlet UIButton *btn9;
@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (nonatomic, assign) BOOL passwordMatched;
@property (nonatomic, assign) BOOL isUsingTouchID;

@property (nonatomic, copy) NSString *passwordReminder;

@property (nonatomic, assign) CreatNewPasswordMode creatNewPasswordMode;

@end

@implementation CLPasswordVC

@synthesize password = _password;

- (BOOL)isUsingTouchID {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTouchIDKey];
}

- (NSString *)password {
    if (!_password) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kPasswordKey] == nil) {
            _password = @"";
            [[NSUserDefaults standardUserDefaults] setObject:_password forKey:kPasswordKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            _password = [[NSUserDefaults standardUserDefaults] objectForKey:kPasswordKey];
        }
    }
    
    return _password;
}

- (NSString *)passwordReminder {
    if (!_passwordReminder) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kPasswordReminderKey] == nil) {
            _passwordReminder = @"";
            [[NSUserDefaults standardUserDefaults] setObject:_passwordReminder forKey:kPasswordReminderKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            _passwordReminder = [[NSUserDefaults standardUserDefaults] objectForKey:kPasswordReminderKey];
        }
    }
    
    return _passwordReminder;
}

- (void)setPassword:(NSString *)password {
    _password = password;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_password forKey:kPasswordKey];
}

- (void)setIsChangingPassword:(BOOL)isChangingPassword {
    _isChangingPassword = isChangingPassword;
    
    if (isChangingPassword) {
        self.creatNewPasswordMode = kInputOldPasswordMode;
    }
}

- (void)setIsCreatingNewPassword:(BOOL)isCreatingNewPassword {
    _isCreatingNewPassword = isCreatingNewPassword;
    
    if (isCreatingNewPassword) {
        self.creatNewPasswordMode = kInputNewPasswordFirstTimeMode;
    }
}

- (void)setCreatNewPasswordMode:(CreatNewPasswordMode)creatNewPasswordMode {
    _creatNewPasswordMode = creatNewPasswordMode;
    
    if (_creatNewPasswordMode == kInputOldPasswordMode) {
        
        self.inputNoticeLabel.text = @"请输入旧密码";
    } else if (_creatNewPasswordMode == kInputNewPasswordFirstTimeMode) {
        
        self.inputNoticeLabel.text = @"请输入新密码";

    } else if (_creatNewPasswordMode == kInputNewPasswordSecondTimeMode) {
        self.inputNoticeLabel.text = @"请再次输入新密码";

    }
    
}

@synthesize typedPassword = _typedPassword;
- (NSString *)typedPassword {
    if (_typedPassword == nil) {
        _typedPassword = @"";
    }
    
    return _typedPassword;
}

- (void)setTypedPassword:(NSString *)typedPassword {
    _typedPassword = typedPassword;
    
    switch (typedPassword.length) {
        case 0:
            self.icon1.textColor = [UIColor darkGrayColor];
            self.icon2.textColor = [UIColor darkGrayColor];
            self.icon3.textColor = [UIColor darkGrayColor];
            self.icon4.textColor = [UIColor darkGrayColor];
            break;
            
        case 1:
            self.icon1.textColor = kMenuBackgroundColor;
            self.icon2.textColor = [UIColor darkGrayColor];
            self.icon3.textColor = [UIColor darkGrayColor];
            self.icon4.textColor = [UIColor darkGrayColor];
            break;
            
        case 2:
            self.icon1.textColor = kMenuBackgroundColor;
            self.icon2.textColor = kMenuBackgroundColor;
            self.icon3.textColor = [UIColor darkGrayColor];
            self.icon4.textColor = [UIColor darkGrayColor];
            break;
            
        case 3:
            self.icon1.textColor = kMenuBackgroundColor;
            self.icon2.textColor = kMenuBackgroundColor;
            self.icon3.textColor = kMenuBackgroundColor;
            self.icon4.textColor = [UIColor darkGrayColor];
            break;
            
        case 4:
            self.icon1.textColor = kMenuBackgroundColor;
            self.icon2.textColor = kMenuBackgroundColor;
            self.icon3.textColor = kMenuBackgroundColor;
            self.icon4.textColor = kMenuBackgroundColor;
            break;
            
        default:
            break;
    }
}

- (IBAction)buttonClicked:(UIButton *)button {
    NSInteger tag = button.tag;
    if (tag >= 0 && tag <= 9) {
        [self typedPasswordWithNumber:[NSString stringWithFormat:@"%d", (int)tag]];
    } else {
        [self deleteNumber];
    }
}

- (void)typedPasswordWithNumber:(NSString *)number {
    if (self.resultNoticeLabel.hidden == NO) {
        self.resultNoticeLabel.hidden = YES;
    }

    if (self.typedPassword.length < 4) {
        self.typedPassword = [self.typedPassword stringByAppendingString:number];
    }

    if (self.typedPassword.length == 4) {
        
        if (self.isChangingPassword) {
            
            if (self.creatNewPasswordMode == kInputOldPasswordMode) {
                [self checkOldPassword];
            } else if (self.creatNewPasswordMode == kInputNewPasswordFirstTimeMode) {
                [self createNewPassword];
            } else if (self.creatNewPasswordMode == kInputNewPasswordSecondTimeMode) {
                [self checkNewPassword];
            }
            
        } else if (self.isCreatingNewPassword) {
            
            if (self.creatNewPasswordMode == kInputNewPasswordFirstTimeMode) {
                [self createNewPassword];
            } else if (self.creatNewPasswordMode == kInputNewPasswordSecondTimeMode) {
                [self checkNewPassword];
            }
            
        } else {
            [self checkPasswordMatching];
        }
        
    }
}

- (void)checkOldPassword {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.passwordMatched) {
            self.typedPassword = @"";
            self.creatNewPasswordMode = kInputNewPasswordFirstTimeMode;
            
        } else {
            self.typedPassword = @"";
            self.resultNoticeLabel.hidden = NO;
            self.resultNoticeLabel.text = @"密码错误!";
        }
    });
}

- (void)createNewPassword {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.password = self.typedPassword;
        self.typedPassword = @"";
        self.creatNewPasswordMode = kInputNewPasswordSecondTimeMode;
    });
}

- (void)checkNewPassword {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.passwordMatched) {
            
            self.resultNoticeLabel.hidden = NO;
            self.resultNoticeLabel.text = @"密码设置成功!";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"newPasswordCreated" object:nil]];
            });
            
        } else {
            self.typedPassword = @"";
            self.resultNoticeLabel.hidden = NO;
            self.resultNoticeLabel.text = @"密码不匹配,请重新设置!";
            
            if (self.isCreatingNewPassword) {
                self.creatNewPasswordMode = kInputNewPasswordFirstTimeMode;

            } else if (self.isChangingPassword) {
                self.creatNewPasswordMode = kInputOldPasswordMode;

            }
        }
    });
}


- (void)checkPasswordMatching {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.passwordMatched) {
            
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"passwordMatch" object:nil]];
        } else {
            self.typedPassword = @"";
            self.resultNoticeLabel.hidden = NO;
            self.resultNoticeLabel.text = @"密码错误!";
        }
    });
}

- (void)deleteNumber {
    if (self.typedPassword.length > 0) {
        self.typedPassword = [self.typedPassword substringToIndex:[self.typedPassword length] - 1];
    }
    
}

- (BOOL)passwordMatched {
    
    return [self.typedPassword isEqualToString:self.password];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.typedPassword = @"";
    
    [self.cancelButton setTitleColor:kMenuBackgroundColor forState:UIControlStateNormal];
    [self.reminderButton setTitleColor:kMenuBackgroundColor forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:kMenuBackgroundColor forState:UIControlStateHighlighted];
    [self.reminderButton setTitleColor:kMenuBackgroundColor forState:UIControlStateHighlighted];
    
    if (self.isCreatingNewPassword  || self.isChangingPassword) {
        
        self.cancelButton.hidden = NO;
        
        if (self.creatNewPasswordMode == kInputOldPasswordMode) {
            
            self.inputNoticeLabel.text = @"请输入旧密码";
        } else if (self.creatNewPasswordMode == kInputNewPasswordFirstTimeMode) {
            
            self.inputNoticeLabel.text = @"请输入新密码";
            
        } else if (self.creatNewPasswordMode == kInputNewPasswordSecondTimeMode) {
            self.inputNoticeLabel.text = @"请再次输入新密码";
            
        }

        
        if (self.passwordReminder.length > 0) {
            [self.reminderButton setTitle:@"修改密码提示" forState:UIControlStateNormal];
            [self.reminderButton setTitle:@"修改密码提示" forState:UIControlStateHighlighted];
        } else {
            [self.reminderButton setTitle:@"添加密码提示" forState:UIControlStateNormal];
            [self.reminderButton setTitle:@"添加密码提示" forState:UIControlStateHighlighted];
        }
        
        [self.reminderButton addTarget:self action:@selector(addPasswordReminder) forControlEvents:UIControlEventTouchUpInside];
        
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateHighlighted];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        
        if (!self.isUsingTouchID) {
            self.cancelButton.hidden = YES;
        }
        
        self.inputNoticeLabel.text = @"请输入密码";
        
        [self.reminderButton setTitle:@"密码提示" forState:UIControlStateNormal];
        [self.reminderButton setTitle:@"密码提示" forState:UIControlStateHighlighted];
        [self.reminderButton addTarget:self action:@selector(showPasswordReminder) forControlEvents:UIControlEventTouchUpInside];
        
        [self.cancelButton setTitle:@"TouchID" forState:UIControlStateNormal];
        [self.cancelButton setTitle:@"TouchID" forState:UIControlStateHighlighted];
        [self.cancelButton addTarget:self action:@selector(StartWJTouchID) forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.isCreatingNewPassword && !self.isChangingPassword) {
        [self StartWJTouchID];
    }
}

- (void)showPasswordReminder {
    
    self.resultNoticeLabel.hidden = NO;
    self.resultNoticeLabel.text = [NSString stringWithFormat:@"密码提示\n%@",self.passwordReminder];
}

- (void)addPasswordReminder {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加密码提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"密码提示";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textField.text = self.passwordReminder;
        textField.font = kFontSys16;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *nameTF = alertController.textFields.firstObject;
        
        self.passwordReminder = nameTF.text;

        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.passwordReminder forKey:kPasswordReminderKey];
        [defaults synchronize];
        
        self.resultNoticeLabel.hidden = NO;
        self.resultNoticeLabel.text = @"密码提示设置成功";
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = NO;
    }];

}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    
    if (alertController) {
        UITextField *reminderTF = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = reminderTF.text.length > 0;
    }
}


- (void)cancelButtonClicked {
    if (self.isCreatingNewPassword) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"cancelPasswordCreation" object:nil]];
    } else if (self.isChangingPassword) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"cancelPasswordChange" object:nil]];

    }

}

- (void)StartWJTouchID {
    
    if (self.isUsingTouchID) {
        [[WJTouchID touchID] startWJTouchIDWithMessage:WJNotice(@"请核对指纹信息", @"Please check the fingerprint") fallbackTitle:WJNotice(@"输入密码", @"Input Password") delegate:self];
    }

}
/**
 *  TouchID验证成功
 *
 *  Authentication Successul  Authorize Success
 */
- (void) WJTouchIDAuthorizeSuccess {
    self.resultNoticeLabel.hidden = NO;
    self.resultNoticeLabel.text = WJNotice(@"TouchID验证成功", @"Authorize Success");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"passwordMatch" object:nil]];
    });

}

/**
 *  TouchID验证失败
 *
 *  Authentication Failure
 */
- (void) WJTouchIDAuthorizeFailure {
    self.resultNoticeLabel.hidden = NO;
    
    self.resultNoticeLabel.text = WJNotice(@"TouchID验证失败", @"Authorize Failure");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.resultNoticeLabel.hidden = YES;

    });
    
}
/**
 *  取消TouchID验证 (用户点击了取消)
 *
 *  Authentication was canceled by user (e.g. tapped Cancel button).
 */
- (void) WJTouchIDAuthorizeErrorUserCancel {
    
    self.resultNoticeLabel.hidden = NO;
    
    self.resultNoticeLabel.text = WJNotice(@"取消TouchID验证 (用户点击了取消)", @"Authorize Error User Cancel");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.resultNoticeLabel.hidden = YES;
        
    });
    
}

/**
 *  在TouchID对话框中点击输入密码按钮
 *
 *  User tapped the fallback button
 */
- (void) WJTouchIDAuthorizeErrorUserFallback {
    
    self.resultNoticeLabel.hidden = NO;
    
    self.resultNoticeLabel.text = WJNotice(@"在TouchID对话框中点击输入密码按钮", @"Authorize Error User Fallback ");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.resultNoticeLabel.hidden = YES;
        
    });

}

/**
 *  在验证的TouchID的过程中被系统取消 例如突然来电话、按了Home键、锁屏...
 *
 *  Authentication was canceled by system (e.g. another application went to foreground).
 */
- (void) WJTouchIDAuthorizeErrorSystemCancel {
    
    self.resultNoticeLabel.hidden = NO;
    
    self.resultNoticeLabel.text = WJNotice(@"在验证的TouchID的过程中被系统取消 ", @"Authorize Error System Cancel");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.resultNoticeLabel.hidden = YES;
        
    });

}

/**
 *  无法启用TouchID,设备没有设置密码
 *
 *  Authentication could not start, because passcode is not set on the device.
 */
- (void) WJTouchIDAuthorizeErrorPasscodeNotSet {
    
    self.resultNoticeLabel.hidden = NO;
    
    self.resultNoticeLabel.text = WJNotice(@"无法启用TouchID,设备没有设置密码", @"Authorize Error Passcode Not Set");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.resultNoticeLabel.hidden = YES;
        
    });
    
}

/**
 *  设备没有录入TouchID,无法启用TouchID
 *
 *  Authentication could not start, because Touch ID has no enrolled fingers
 */
- (void) WJTouchIDAuthorizeErrorTouchIDNotEnrolled {
    
    self.resultNoticeLabel.hidden = NO;
    
    self.resultNoticeLabel.text = WJNotice(@"设备没有录入TouchID,无法启用TouchID", @"Authorize Error TouchID Not Enrolled");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.resultNoticeLabel.hidden = YES;
        
    });
}

/**
 *  该设备的TouchID无效
 *
 *  Authentication could not start, because Touch ID is not available on the device.
 */
- (void) WJTouchIDAuthorizeErrorTouchIDNotAvailable {
    
    self.resultNoticeLabel.hidden = NO;
    
    self.resultNoticeLabel.text = WJNotice(@"该设备的TouchID无效", @"Authorize Error TouchID Not Available");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.resultNoticeLabel.hidden = YES;
        
    });
}

/**
 *  多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁
 *
 *  Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite.
 *
 */
- (void) WJTouchIDAuthorizeLAErrorTouchIDLockout {
    
    self.resultNoticeLabel.hidden = NO;
    
    self.resultNoticeLabel.text = WJNotice(@"多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁", @"Authorize LAError TouchID Lockout");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.resultNoticeLabel.hidden = YES;
        
    });
}

/**
 *  当前软件被挂起取消了授权(如突然来了电话,应用进入前台)
 *
 *  Authentication was canceled by application (e.g. invalidate was called while authentication was inprogress).
 *
 */
- (void) WJTouchIDAuthorizeLAErrorAppCancel {
    
    self.resultNoticeLabel.hidden = NO;
    
    self.resultNoticeLabel.text = WJNotice(@"当前软件被挂起取消了授权", @"Authorize LAError AppCancel");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.resultNoticeLabel.hidden = YES;
        
    });
}

/**
 *  当前软件被挂起取消了授权 (授权过程中,LAContext对象被释)
 *
 *  LAContext passed to this call has been previously invalidated.
 */
- (void) WJTouchIDAuthorizeLAErrorInvalidContext {
    
    self.resultNoticeLabel.hidden = NO;
    
    self.resultNoticeLabel.text = WJNotice(@"当前软件被挂起取消了授权", @"Authorize LAError Invalid Context");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.resultNoticeLabel.hidden = YES;
        
    });
}
/**
 *  当前设备不支持指纹识别
 *
 *  The current device does not support fingerprint identification
 */
-(void)WJTouchIDIsNotSupport {
    
    self.resultNoticeLabel.hidden = NO;
    
    self.resultNoticeLabel.text = WJNotice(@"当前设备不支持指纹识别", @"The Current Device Does Not Support");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.resultNoticeLabel.hidden = YES;
        
    });
}
@end
