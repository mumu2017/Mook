//
//  CLAudioPlayTool.m
//  Mook
//
//  Created by 陈林 on 16/6/23.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLAudioPlayTool.h"
#import "CLAudioPlayVC.h"
#import "UIViewController+BlurPresenting.h"

@implementation CLAudioPlayTool

+ (void)playAudioFromCurrentController:(UIViewController *)controller audioPath:(NSString *)audioPath {
    
    CLAudioPlayVC *vc = [[CLAudioPlayVC alloc] init];
    vc.audioPath = audioPath;
    vc.barStyle = UIBarStyleBlack;
    
    [controller presentBlurredAudioPlayViewControllerAnimated:vc];
    
//    [controller presentNavigationViewControllerAnimated:vc barStyle:UIBarStyleDefault];
//
//    [controller presentBlurredNavigationViewControllerAnimated:vc barStyle:UIBarStyleDefault];
}

+ (void)playAudioFromCurrentController:(UIViewController *)controller audioPath:(NSString *)audioPath audioPlayer:(AVAudioPlayer *)audioPlayer {
    
    CLAudioPlayVC *vc = [[CLAudioPlayVC alloc] init];
    vc.audioPath = audioPath;
    vc.barStyle = UIBarStyleBlack;
    vc.audioPlayer = audioPlayer;
    
    [controller presentBlurredAudioPlayViewControllerAnimated:vc];
    
    //    [controller presentNavigationViewControllerAnimated:vc barStyle:UIBarStyleDefault];
    //
    //    [controller presentBlurredNavigationViewControllerAnimated:vc barStyle:UIBarStyleDefault];
}

@end
