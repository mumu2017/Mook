//
//  CLTextViewCell.m
//  Mook
//
//  Created by 陈林 on 16/1/2.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import "CLQuickStringCell.h"

@implementation CLQuickStringCell

- (void)awakeFromNib {
    self.backgroundColor = kCellBgColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
