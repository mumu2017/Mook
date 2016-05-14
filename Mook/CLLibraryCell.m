//
//  CLLibraryCell.m
//  Mook
//
//  Created by 陈林 on 16/4/4.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLLibraryCell.h"

@implementation CLLibraryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.coverView];

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    
    self.imageView.clipsToBounds = YES;
    self.coverView.alpha = 0.1;
}

@end
