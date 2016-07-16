//
//  CLAudioPlayTool.h
//  Mook
//
//  Created by 陈林 on 16/6/23.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVAudioPlayer;

@interface CLAudioPlayTool : NSObject

+ (void)playAudioFromCurrentController:(UIViewController *)controller audioPath:(NSString *)audioPath;

+ (void)playAudioFromCurrentController:(UIViewController *)controller audioPath:(NSString *)audioPath audioPlayer:(AVAudioPlayer *)audioPlayer;

@end
