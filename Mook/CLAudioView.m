//
//  CLAudioView.m
//  Mook
//
//  Created by 陈林 on 16/7/15.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLAudioView.h"

@implementation CLAudioView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubviews];
        
    }
    return self;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self playButton];
    
    self.audioPlayMode = kAudioPlayModeNotLoaded; //初始化时, 出于未加载状态
}

- (UIButton *)playButton {
    
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_playButton];
        [_playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self);
            make.width.height.equalTo(@44);
        }];
    }
    
    _playButton.titleLabel.font = kFontSys14;
    
    _playButton.backgroundColor = [UIColor clearColor];
    _playButton.tintColor = [UIColor whiteColor];
    
    [_playButton addTarget:self action:@selector(quickPlay) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [[UIImage imageNamed:@"audioPlay"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_playButton setImage:image forState:UIControlStateNormal];


    return _playButton;
}

- (void)setAudioPlayMode:(AudioPlayMode)audioPlayMode {
    
    _audioPlayMode = audioPlayMode;
    
    
    if (audioPlayMode == kAudioPlayModeNotLoaded) {
        
        self.playButton.tintColor = [UIColor whiteColor];
        
    } else if (audioPlayMode == kAudioPlayModeLoaded) {
        
        self.playButton.tintColor = kAppThemeColor;

    }
    
}

- (void)setAudioName:(NSString *)audioName {
    
    _audioName = audioName;
    
}

- (void)setAudioBlock:(AudioBlock)audioBlock {
    
    _audioBlock = audioBlock;

}

- (void)setPlayBlock:(PlayBlock)playBlock {
    
    _playBlock = playBlock;

}

- (void)quickPlay {
    
    _playBlock(self);
}

- (void)playAudio {
    
    _audioBlock(_audioName);
}

- (BOOL)isWithAudio {
    if (self.audioName.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString audioPath] stringByAppendingPathComponent:self.audioName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}


@end
