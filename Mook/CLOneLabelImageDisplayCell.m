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
    
    self.iconView.image = image;
//    
//    [self.imageButton setImage:image forState:UIControlStateNormal];
}

- (void)setImageWithVideoName:(NSString *)videoName {

    UIImage *image = [videoName getNamedVideoFrame];
    self.iconView.image = image;

    [self.imageButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];

}

- (void)awakeFromNib {

    self.imageButton.tintColor = [UIColor whiteColor];
    self.iconView.clipsToBounds = YES;
}

@end
