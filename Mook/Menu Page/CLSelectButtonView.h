//
//  CLSelectButtonView.h
//  Deck界面2
//
//  Created by 陈林 on 15/10/24.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLSelectButtonView;

@protocol CLSelectButtonViewDelegate <NSObject>

@optional
- (void)selectButtonView:(CLSelectButtonView *)buttonView didClickButton:(UIButton *)button;

@end


@interface CLSelectButtonView : UIToolbar

@property (weak, nonatomic) IBOutlet UIButton *ideaButton;
@property (weak, nonatomic) IBOutlet UIButton *sleightButton;
@property (weak, nonatomic) IBOutlet UIButton *propButton;
@property (weak, nonatomic) IBOutlet UIButton *linesButton;

@property (nonatomic, weak) id<CLSelectButtonViewDelegate> tbDelegate;

+ (instancetype)selectedButtonView;

@end
