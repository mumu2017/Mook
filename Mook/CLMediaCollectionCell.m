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
        
        self.iconView.image = [UIImage imageNamed:@"iconVideoCamera"];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UIImage *image = [name getNamedVideoFrame];
            NSString *duration = [name getDurationForNamedVideo];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.imageView.image = image;
                self.durationLabel.text = duration;
                
            });
        });
        
    } else if ([name containsString:@"jpg"]) {

        self.iconView.image = nil;
        self.durationLabel.text = nil;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UIImage *image = [name getNamedImageThumbnail];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.imageView.image = image;
                
            });
        });

    }
}

@end
