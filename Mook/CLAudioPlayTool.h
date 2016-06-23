//
//  CLAudioPlayTool.h
//  Mook
//
//  Created by 陈林 on 16/6/23.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLAudioPlayTool : NSObject

+ (void)playAudioFromCurrentController:(UIViewController *)controller audioPath:(NSString *)audioPath;

@end
