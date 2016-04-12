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
    [self.contentView addSubview:self.iconView];
    
//    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
//        self.contentView.backgroundColor = [UIColor clearColor];
//        
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        blurEffectView.frame = self.contentView.bounds;
//        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        
//        [self.contentView addSubview:blurEffectView];
//    }
//    else {
//        self.contentView.backgroundColor = [UIColor blackColor];
//    }
}

- (void)setName:(NSString *)name {
    _name = name;
    
    if ([name containsString:@"mp4"]) {
        
        self.imageView.image = [name getNamedVideoFrame];
        self.iconView.image = [UIImage imageNamed:@"PlayButtonOverlayLarge"];
        
    } else if ([name containsString:@"jpg"]) {
        self.imageView.image = [name getNamedImageThumbnail];
        self.iconView.image = nil;
    }
}

@end
