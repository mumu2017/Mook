//
//  CLAudioPlayVC.h
//  Mook
//
//  Created by 陈林 on 16/6/23.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FDWaveformView;

@interface CLAudioPlayVC : UIViewController

@property (strong, nonatomic) NSString * _Nonnull audioPath;

@property(nonatomic,assign) UIBarStyle barStyle;

/**
 normalTintColor is used for showing wave tintColor while not recording, it is also used for navigationBar and toolbar tintColor.
 */
@property (nullable, nonatomic, strong) UIColor *normalTintColor;

/**
 Highlighted tintColor is used when playing the recorded audio file or when recording the audio file.
 */
@property (nullable, nonatomic, strong) UIColor *highlightedTintColor;

@property(nonatomic, assign) BOOL blurrEnabled;

@end
