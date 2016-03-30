//
//  CLPerformToolBar.m
//  Mook
//
//  Created by 陈林 on 15/11/16.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLToolBar.h"

@implementation CLToolBar

+ (instancetype)toolBar {
    return [[[NSBundle mainBundle] loadNibNamed:@"CLToolBar" owner:nil options:nil] lastObject];
}
// 按钮监听方法 - 调用代理方法
- (IBAction)buttonClicked:(UIButton *)button {
    
    if ([self.tbDelegate respondsToSelector:@selector(toolBar:didClickButton:)]) {
        [self.tbDelegate toolBar:self didClickButton:button];
    }
}

- (void)setButtonImage:(UIImage *)image {

    [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    if ([self isWithImage]) {
        [self setButtonImageWithImageName:imageName];
    } else {
        [self setButtonImage:nil];
    }
    
}

- (void)setVideoName:(NSString *)videoName {
    _videoName = videoName;
    
    if ([self isWithVideo]) {
        [self setButtonImageWithVideoName:videoName];
    } else {
        [self setButtonImage:nil];
    }
}

- (BOOL)isWithVideo {
    
    if (self.videoName.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString videoPath] stringByAppendingPathComponent:self.videoName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

- (BOOL)isWithImage {
    
    if (self.imageName.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString imagePath] stringByAppendingPathComponent:self.imageName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

- (void)setButtonImageWithImageName:(NSString *)imageName {
    
    UIImage *image = [imageName getNamedImageThumbnail];

    [self setButtonImage:image];

}

- (void)setButtonImageWithVideoName:(NSString *)videoName {
    
    UIImage *videoImage = [videoName getNamedVideoThumbnail];
    
    [self setButtonImage:videoImage];
}

- (void)awakeFromNib {
    
    // 设置图片按钮的图片显示模式
    [[self.imageButton imageView] setContentMode: UIViewContentModeScaleAspectFill];
    
    // 将toolBar的背景颜色设置为透明
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setBackgroundImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]
      forToolbarPosition:UIBarPositionAny];
    
    self.layer.borderColor = kSeperatorBgColor.CGColor;
    self.layer.borderWidth = 0.5;
 
}

@end
