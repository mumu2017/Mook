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
    [self.contentView addSubview:self.durationLabel];
    [self.contentView addSubview:self.iconView];
        
}

- (void)setName:(NSString *)name {
    _name = name;
    
    if ([name containsString:@"mp4"]) {
        
        self.imageView.image = [name getNamedVideoFrame];
        self.iconView.image = [UIImage imageNamed:@"iconVideoCamera"];
        
        self.durationLabel.text = [name getDurationForNamedVideo];
        
    } else if ([name containsString:@"jpg"]) {
        self.imageView.image = [name getNamedImageThumbnail];
        self.iconView.image = nil;
        
        self.durationLabel.text = nil;

    }
}

@end
