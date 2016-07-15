//
//  CLAudioView.m
//  Mook
//
//  Created by 陈林 on 16/7/15.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLAudioView.h"
#import "FDWaveformView.h"

@implementation CLAudioView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];

        [self audioButton];
        [self waveformView];
        
        self.audioPlayMode = kAudioPlayModeReady;
        
    }
    return self;
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor blackColor];
        

        [self audioButton];
        [self waveformView];
        
        self.audioPlayMode = kAudioPlayModeReady;
    }
    return self;
}

- (void)initSubviews {
    
    
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_playButton];
        [_playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.bottom.equalTo(self);
            make.width.equalTo(@44);
        }];
    }
    
    _playButton.titleLabel.font = kFontSys14;
    
    _playButton.backgroundColor = [UIColor clearColor];
    _playButton.tintColor = [UIColor whiteColor];
    
    [_playButton addTarget:self action:@selector(quickPlay) forControlEvents:UIControlEventTouchUpInside];

    return _playButton;
}

- (FDWaveformView *)waveformView {
    if (!_waveformView) {
        _waveformView = [[FDWaveformView alloc] init];
        [self addSubview:_waveformView];
        
        [_waveformView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
            make.right.equalTo(self);
            make.left.equalTo(self.playButton.mas_right);
        }];
        
        _waveformView.wavesColor = [UIColor whiteColor];
        _waveformView.backgroundColor = [UIColor clearColor];
        _waveformView.doesAllowScroll = NO;
        _waveformView.doesAllowScrubbing = NO;
        _waveformView.doesAllowStretch = NO;
        _waveformView.layer.cornerRadius = 1.0;
        _waveformView.progressColor = [UIColor blackColor];
        
    }
    return _waveformView;
}

- (UIButton *)audioButton {
    if (!_audioButton) {
        _audioButton = [[UIButton alloc] init];
        [self.waveformView addSubview:_audioButton];
        [_audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self.waveformView);
            
        }];
    }
    
    _audioButton.titleLabel.font = kFontSys14;
    
    [_audioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _audioButton.backgroundColor = [UIColor clearColor];
    
    [_audioButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
    
    return _audioButton;
}

- (void)setAudioPlayMode:(AudioPlayMode)audioPlayMode {
    
    _audioPlayMode = audioPlayMode;
    
    UIImage *image;
    
    if (audioPlayMode == kAudioPlayModeReady) {
        
        image = [[UIImage imageNamed:@"playAudio"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.waveformView.progressSamples = 0;
        
    } else if (audioPlayMode == kAudioPlayModePlaying) {
        
        image = [[UIImage imageNamed:@"pauseAudio"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
    } else if (audioPlayMode == kAudioPlayModePause) {
        
        image = [[UIImage imageNamed:@"playAudio"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    [self.playButton setImage:image forState:UIControlStateNormal];
}

- (void)setAudioName:(NSString *)audioName {
    
    _audioName = audioName;
    
    self.waveformView.audioURL = [NSURL fileURLWithPath:[audioName getNamedAudio]];

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
