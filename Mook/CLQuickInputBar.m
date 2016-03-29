//
//  CLQuickInputBar.m
//  Mook
//
//  Created by 陈林 on 15/12/14.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLQuickInputBar.h"

@implementation CLQuickInputBar

+ (instancetype)quickInputBar {
    return [[[NSBundle mainBundle] loadNibNamed:@"CLQuickInputBar" owner:nil options:nil] lastObject];
}

- (IBAction)buttonClicked:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(quickInputBar:didClickButton:)]) {
        [self.delegate quickInputBar:self didClickButton:button];
    }
}

- (void)awakeFromNib {
    
    self.layer.borderColor = kSeperatorBgColor.CGColor;
    self.layer.borderWidth = 0.5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
