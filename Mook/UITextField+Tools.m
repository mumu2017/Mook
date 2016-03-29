//
//  UITextField+Tools.m
//  Deck
//
//  Created by 陈林 on 15/11/5.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "UITextField+Tools.h"

@implementation UITextField (Tools)


- (void) adjustCursor {
    
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void) showBorder {
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth =1.0;
        self.layer.cornerRadius =5.0;
    }];
}

- (void) hideBorder {
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0.0;
        self.layer.cornerRadius = 0.0;
    }];
}

@end

