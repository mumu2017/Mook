//
//  CLRoutineTextCell.m
//  Mook
//
//  Created by 陈林 on 16/3/31.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLRoutineTextCell.h"

@implementation CLRoutineTextCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = kCellBgColor;
    self.infoButton.tintColor = kMenuBackgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
