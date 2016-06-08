//
//  CLSelectButtonView.m
//  Deck界面2
//
//  Created by 陈林 on 15/10/24.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLSelectButtonView.h"

@implementation CLSelectButtonView

+ (instancetype)selectedButtonView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CLSelectButtonView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    
    // 将toolBar的背景颜色设置为透明
    
    [self setBackgroundImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]
              forToolbarPosition:UIBarPositionAny];
}

//- (void)settingFrame {
//    self.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//}

- (IBAction)buttonClicked:(UIButton *)button {
    if ([self.tbDelegate respondsToSelector:@selector(selectButtonView: didClickButton:)]) {
        [self.tbDelegate selectButtonView:self didClickButton:button];
    }
}


@end
