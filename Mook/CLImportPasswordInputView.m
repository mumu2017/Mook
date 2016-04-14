//
//  CLImportPasswordInputView.m
//  Mook
//
//  Created by 陈林 on 16/4/12.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLImportPasswordInputView.h"

@implementation CLImportPasswordInputView

+ (instancetype)importPasswordInputView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CLImportPasswordInputView" owner:nil options:nil] lastObject];
}

- (IBAction)unlockButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(importPasswordInputViewdidClickUnlockButton:)]) {
        [self.delegate importPasswordInputViewdidClickUnlockButton:self];
    }
}

//- (IBAction)cancelButtonClicked:(id)sender {
//    if ([self.delegate respondsToSelector:@selector(importPasswordInputViewdidClickCancelButton:)]) {
//        [self.delegate importPasswordInputViewdidClickCancelButton:self];
//    }
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.passwordTF.tintColor = kMenuBackgroundColor;
    [self.passwordTF adjustCursor];
    self.noticeLabel.text = @"当前笔记有密码锁定, 请输入密码解锁.";
    self.noticeLabel.font = kFontSys14;
    self.passwordTF.placeholder = NSLocalizedString(@"请输入笔记密码", nil);
    self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTF.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTF.font = kFontSys14;
}

@end
