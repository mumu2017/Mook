//
//  CLOneLabelImageDisplayCell.m
//  Mook
//
//  Created by 陈林 on 15/12/12.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLOneLabelImageDisplayCell.h"
#define ZOOM_STEP 2.0

@interface CLOneLabelImageDisplayCell()<UIGestureRecognizerDelegate, UIScrollViewDelegate>

@end

@implementation CLOneLabelImageDisplayCell


- (void)setImageWithName:(NSString *)imageName {
    
    UIImage *image = [imageName getNamedImage];
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.image = image;
}

- (void)setImageWithVideoName:(NSString *)videoName {

    UIImage *image = [videoName getNamedVideoFrame];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.image = image;

    [self.imageButton setImage:[UIImage imageNamed:@"PlayButtonOverlayLarge"] forState:UIControlStateNormal];
    [self.imageButton setImage:[UIImage imageNamed:@"PlayButtonOverlayLargeTap"] forState:UIControlStateHighlighted];
}

- (void)awakeFromNib {

    self.iconView.clipsToBounds = YES;
}

@end
