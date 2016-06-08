//
//  CLVideoView.m
//  Mook
//
//  Created by 陈林 on 15/11/28.
//  Copyright © 2015年 ChenLin. All rights reserved.
//


#import "CLMediaView.h"
#import <AVFoundation/AVFoundation.h>

@interface CLMediaView()

@property (nonatomic, assign) BOOL isPlayingVideo;

@property (nonatomic, strong) UIView *originalSuperView;
@property (nonatomic, assign) CGRect originalFrame;
@end

@implementation CLMediaView

+ (instancetype)mediaView {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.frame = CGRectZero;
        self.backgroundColor = [UIColor blackColor];

        self.mediaButton.adjustsImageWhenHighlighted = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.player.currentItem];
        
        // 添加控制按钮
        
        [self.mediaButton addTarget:self action:@selector(controlPlay) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mediaButton addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchDownRepeat];
    }
    return self;
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (UIButton *)mediaButton {
    if (!_mediaButton) {
        _mediaButton = [[UIButton alloc]init];
        _mediaButton.backgroundColor = [UIColor clearColor];
        [self addSubview:_mediaButton];
        _mediaButton.frame = self.bounds;
    }
    
    return _mediaButton;
}

- (void)layoutSubviews {
    _mediaButton.frame = self.bounds;
}

- (void)setVideoWithName:(NSString *)videoName {
    
//    self.mediaButton.backgroundColor = [UIColor blackColor];
    [self.mediaButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //创建item
        AVPlayerItem *item = [videoName getNamedAVPlayerItem];
        self.player = [AVPlayer playerWithPlayerItem:item];;
        self.player.volume = 0.0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //创建player
//            self.mediaButton.backgroundColor = [UIColor clearColor];
            //设置音量
            
        });
    });
}


- (void)setImageWithName:(NSString *)imageName {
    
    UIImage *image = [imageName getNamedImage];
    
    [[self.mediaButton imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [self.mediaButton setImage:image forState:UIControlStateNormal];
    
}


- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    
//    self.mediaButton.backgroundColor = [UIColor clearColor];
    [self.mediaButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}

- (void)controlPlay {
    
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        
        if (self.player.rate == 1.0) { //rate == 1.0 表示正在播放
            [self.player pause];
       
//            self.mediaButton.backgroundColor = [UIColor blackColor];

            [self.mediaButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            
        } else if (self.player.rate == 0.0) { // rate == 0.0 表示正在暂停状态
            
            [self.player play];
//            self.mediaButton.backgroundColor = [UIColor clearColor];
            [self.mediaButton setImage:nil forState:UIControlStateNormal];
        }
    } else {
        return;
    }
    
}

// 由于mediaView在全屏时要从superView中移除,所以不能用弱指针引用
// 因此不可以直接在storyboard中直接使用mediaView
- (void)fullScreen {
    
    UIView *windowView = [UIApplication sharedApplication].keyWindow;
    
    if (self.isEditing == NO) {
        
        if (self.superview != windowView) {
            
            if (_originalSuperView == nil) {
                _originalSuperView = self.superview;
                _originalFrame = self.frame;
            }
            
            [self removeFromSuperview];
            [windowView addSubview:self];
            
            self.frame = windowView.bounds;
            
//            self.backgroundColor = [UIColor blackColor];
            
            [self.player play];
            [self.mediaButton setImage:nil forState:UIControlStateNormal];
            self.player.volume = 1.0;
            
        } else {
            [self removeFromSuperview];
            [self.originalSuperView addSubview:self];
            self.frame = self.originalFrame;
            
//            self.backgroundColor = [UIColor clearColor];
            
            self.player.volume = 0.0;
        }

    }
    
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
