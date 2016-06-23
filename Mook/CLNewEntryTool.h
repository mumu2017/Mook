//
//  CLNewEntryTool.h
//  Mook
//
//  Created by 陈林 on 16/6/21.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLNewEntryTool : NSObject

#pragma mark - 快速添加

+ (void)quickAddNewShowFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image;

+ (void)quickAddNewIdeaFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image;

+ (void)quickAddNewRoutineFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image;

+ (void)quickAddNewSleightFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image;

+ (void)quickAddNewPropFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image;

+ (void)quickAddNewLinesFromCurrentController:(UIViewController *)controller withAudio:(NSString *)filePath;

#pragma mark - 直接弹出NewEntryNavVC
+ (void)addNewShowFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image;

+ (void)addNewIdeaFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image;

+ (void)addNewRoutineFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image;

+ (void)addNewSleightFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image;

+ (void)addNewPropFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image;

+ (void)addNewLinesFromCurrentController:(UIViewController *)controller;

+ (void)addNewLinesFromCurrentController:(UIViewController *)controller withAudio:(NSString *)filePath;


+ (void)showAlertControllerWithTextFieldFromCurrentController:(UIViewController *)controller comfirmHandler:(void (^ __nullable)(NSString * __nullable title))comfirmHandler editMoreHandler:(void (^ __nullable)(NSString * __nullable title)) editMoreHandler;

@end
