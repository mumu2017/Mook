//
//  CLTextAudioCell.h
//  Mook
//
//  Created by 陈林 on 16/6/27.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FDWaveformView;

@interface CLTextAudioCell : UITableViewCell

typedef void (^PlayBlock)(NSString *audioName, FDWaveformView *waveformView);
typedef void (^AudioBlock)(NSString *audioName);

@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *audioButton;

@property (strong, nonatomic) UIButton *playButton;

@property (strong, nonatomic) FDWaveformView *waveformView;

@property (strong, nonatomic) NSString *audioName;

@property (nonatomic, assign) BOOL isWithAudio;

@property (strong, nonatomic) AudioBlock audioBlock;

@property (strong, nonatomic) PlayBlock playBlock;


- (void)setAttributedString:(NSAttributedString *)text audioName:(NSString *)audioName playBlock:(PlayBlock)playBlock audioBlock:(AudioBlock)audioBlock;


@end
