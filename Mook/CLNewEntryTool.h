//
//  CLNewEntryTool.h
//  Mook
//
//  Created by 陈林 on 16/6/21.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLNewEntryTool : NSObject

+ (void)addNewShowFromCurrentController:(UIViewController *)controller;


+ (void)addNewIdeaFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL;


+ (void)addNewRoutineFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL;

+ (void)addNewSleightFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL;

+ (void)addNewPropFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL;

+ (void)addNewLinesFromCurrentController:(UIViewController *)controller ;

+ (void)addNewLinesWithAudio:(NSURL *)audioURL;


@end
