//
//  CLPasswordVC.m
//  Mook
//
//  Created by 陈林 on 15/12/30.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLPasswordVC.h"
typedef enum {
    kInputOldPasswordMode = 1,
    kInputNewPasswordFirstTimeMode,
    kInputNewPasswordSecondTimeMode
} CreatNewPasswordMode;

@interface CLPasswordVC ()


@property (weak, nonatomic) IBOutlet UILabel *inputNoticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultNoticeLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

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

@property (nonatomic, assign) CreatNewPasswordMode creatNewPasswordMode;

@end

@implementation CLPasswordVC

@synthesize password = _password;

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
            self.icon1.textColor = kTintColor;
            self.icon2.textColor = [UIColor darkGrayColor];
            self.icon3.textColor = [UIColor darkGrayColor];
            self.icon4.textColor = [UIColor darkGrayColor];
            break;
            
        case 2:
            self.icon1.textColor = [UIColor whiteColor];
            self.icon2.textColor = kTintColor;
            self.icon3.textColor = [UIColor darkGrayColor];
            self.icon4.textColor = [UIColor darkGrayColor];
            break;
            
        case 3:
            self.icon1.textColor = kTintColor;
            self.icon2.textColor = kTintColor;
            self.icon3.textColor = kTintColor;
            self.icon4.textColor = [UIColor darkGrayColor];
            break;
            
        case 4:
            self.icon1.textColor = kTintColor;
            self.icon2.textColor = kTintColor;
            self.icon3.textColor = kTintColor;
            self.icon4.textColor = kTintColor;
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
    
    if (self.isCreatingNewPassword || self.isChangingPassword) {

        self.cancelButton.hidden = NO;

        if (self.creatNewPasswordMode == kInputOldPasswordMode) {
            
            self.inputNoticeLabel.text = @"请输入旧密码";
        } else if (self.creatNewPasswordMode == kInputNewPasswordFirstTimeMode) {
            
            self.inputNoticeLabel.text = @"请输入新密码";
            
        } else if (self.creatNewPasswordMode == kInputNewPasswordSecondTimeMode) {
            self.inputNoticeLabel.text = @"请再次输入新密码";
            
        }
    } else {
 
        self.inputNoticeLabel.text = @"请输入密码";
        self.cancelButton.hidden = YES;
    }
}


- (IBAction)cancelButtonClicked:(id)sender {
    if (self.isCreatingNewPassword) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"cancelPasswordCreation" object:nil]];
    } else if (self.isChangingPassword) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"cancelPasswordChange" object:nil]];

    }

}
@end
