//
//  CLQuickInputBar.h
//  Mook
//
//  Created by 陈林 on 15/12/14.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLQuickInputBar;

@protocol CLQuickInputBarDelegate <NSObject>

// 添加按钮代理方法
@optional
- (void)quickInputBar:(CLQuickInputBar *)quickInputBar didClickButton:(UIButton *)button;

@end

@interface CLQuickInputBar : UIView

@property (weak, nonatomic) IBOutlet UIToolbar *chooseView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;


@property (nonatomic, weak) id<CLQuickInputBarDelegate> delegate;

+ (instancetype)quickInputBar;

@end
