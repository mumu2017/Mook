//
//  CLOneLabelCell.m
//  Mook
//
//  Created by 陈林 on 15/12/9.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLOneLabelCell.h"

@implementation CLOneLabelCell

+ (instancetype)oneLabelCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"CLOneLabelCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    
//    self.backgroundColor = kDisplayBgColor;
    self.contentLabel.backgroundColor = kCellBgColor;

    self.colorView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.colorView.layer.borderWidth = 0.5;
//    self.colorView.layer.cornerRadius = 5.0;
    
    self.colorView.backgroundColor = kCellBgColor;
}

@end
