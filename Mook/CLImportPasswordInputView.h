//
//  CLImportPasswordInputView.h
//  Mook
//
//  Created by 陈林 on 16/4/12.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLImportPasswordInputView, BFPaperButton;

@protocol CLImportPasswordInputViewDelegate <NSObject>

@optional
- (void) importPasswordInputViewdidClickUnlockButton:(CLImportPasswordInputView *)view;
//- (void) importPasswordInputViewdidClickCancelButton:(CLImportPasswordInputView *)view;

@end

@interface CLImportPasswordInputView : UIView

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *unlockButton;

@property (nonatomic, weak) id<CLImportPasswordInputViewDelegate> delegate;

+ (instancetype)importPasswordInputView;

@end
