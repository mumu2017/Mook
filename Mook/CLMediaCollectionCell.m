//
//  CLMediaCollectionCell.m
//  Mook
//
//  Created by 陈林 on 16/4/3.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLMediaCollectionCell.h"

@implementation CLMediaCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.iconView];
}

- (void)setName:(NSString *)name {
    _name = name;
    
    if ([name containsString:@"mp4"]) {
        
        self.imageView.image = [name getNamedVideoFrame];
        self.iconView.image = [UIImage imageNamed:@"PlayButtonOverlayLarge"];
        
    } else if ([name containsString:@"jpg"]) {
        self.imageView.image = [name getNamedImage];
        self.iconView.image = nil;
    }
    
    self.titleLabel.text = @"流程";
    self.contentLabel.text = @"2016/04/03";
    
}

@end