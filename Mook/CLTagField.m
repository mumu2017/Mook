//
//  CLTagField.m
//  Mook
//
//  Created by 陈林 on 15/12/15.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLTagField.h"

@implementation CLTagField

+ (instancetype)tagField {
    return [[[NSBundle mainBundle] loadNibNamed:@"CLTagField" owner:nil options:nil] lastObject];
}


- (void)awakeFromNib {
    self.tintColor = kMenuBackgroundColor;
    self.backgroundColor = [UIColor clearColor];
//    self.seperatorView.backgroundColor = kMenuBackgroundColor;
}

- (void) setFrame:(CGRect)frame {
    frame.size.height = 55;
    [super setFrame:frame];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
