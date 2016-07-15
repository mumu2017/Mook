//
//  CLAudioView.h
//  Mook
//
//  Created by 陈林 on 16/7/15.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//
// 单独管理音频控件的控件

typedef enum {
    kAudioPlayModeReady = 0, //未播放状态
    kAudioPlayModePlaying,  //播放状态
    kAudioPlayModePause     //暂停状态
} AudioPlayMode;

#import <UIKit/UIKit.h>
@class FDWaveformView;

@interface CLAudioView : UIView

typedef void (^PlayBlock)(CLAudioView *audioView);
typedef void (^AudioBlock)(NSString *audioName);

@property (strong, nonatomic) UIButton *audioButton;

@property (strong, nonatomic) UIButton *playButton;

@property (strong, nonatomic) FDWaveformView *waveformView;

@property (strong, nonatomic) NSString *audioName;

@property (nonatomic, assign) BOOL isWithAudio;

@property (assign, nonatomic) AudioPlayMode audioPlayMode;

@property (strong, nonatomic) AudioBlock audioBlock;

@property (strong, nonatomic) PlayBlock playBlock;

@end
