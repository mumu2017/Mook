//
//  CLVideoView.h
//  Mook
//
//  Created by 陈林 on 15/11/28.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayer, AVPlayerItem;

@interface CLMediaView : UIView

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic) AVPlayer *player;

@property (nonatomic, strong) UIButton *mediaButton;
@property (nonatomic, assign) BOOL isEditing;

+ (instancetype)mediaView;


- (void)setPlayer:(AVPlayer *)player;

- (void)setVideoWithName:(NSString *)videoName;
- (void)setImageWithName:(NSString *)imageName;


@end
