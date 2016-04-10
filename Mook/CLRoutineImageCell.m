//
//  CLRoutineImageCell.m
//  Mook
//
//  Created by 陈林 on 16/3/31.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLRoutineImageCell.h"

@implementation CLRoutineImageCell

- (void)setImageWithName:(NSString *)imageName {
    
    UIImage *image = [imageName getNamedImage];
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.image = image;
}

- (void)setImageWithVideoName:(NSString *)videoName {
    
    UIImage *image = [videoName getNamedVideoFrame];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.image = image;
    
    [self.iconButton setImage:[UIImage imageNamed:@"PlayButtonOverlayLarge"] forState:UIControlStateNormal];
    [self.iconButton setImage:[UIImage imageNamed:@"PlayButtonOverlayLargeTap"] forState:UIControlStateHighlighted];
}

- (void)awakeFromNib {
    
    self.backgroundColor = kCellBgColor;
    self.iconView.clipsToBounds = YES;
    self.infoButton.tintColor = kMenuBackgroundColor;

}

@end
