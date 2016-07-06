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

+ (void)quickAddNewShowFromCurrentController:(UIViewController * _Nonnull)controller withVideo:(NSURL * _Nullable)videoURL orImage:(UIImage * _Nullable)image;

+ (void)quickAddNewIdeaFromCurrentController:(UIViewController * _Nonnull)controller withVideo:(NSURL * _Nullable)videoURL orImage:(UIImage * _Nullable)image;

+ (void)quickAddNewRoutineFromCurrentController:(UIViewController * _Nonnull)controller withVideo:(NSURL * _Nullable)videoURL orImage:(UIImage * _Nullable)image;

+ (void)quickAddNewSleightFromCurrentController:(UIViewController * _Nonnull)controller withVideo:(NSURL * _Nullable)videoURL orImage:(UIImage * _Nullable)image;

+ (void)quickAddNewPropFromCurrentController:(UIViewController * _Nonnull)controller withVideo:(NSURL * _Nullable)videoURL orImage:(UIImage * _Nullable)image;

+ (void)quickAddNewLinesFromCurrentController:(UIViewController * _Nonnull)controller withAudio:(NSString * _Nullable)filePath;

#pragma mark - 直接弹出NewEntryNavVC
+ (void)addNewShowFromCurrentController:(UIViewController * _Nonnull)controller withVideo:(NSURL * _Nullable)videoURL orImage:(UIImage * _Nullable)image;

+ (void)addNewIdeaFromCurrentController:(UIViewController * _Nonnull)controller withVideo:(NSURL * _Nullable)videoURL orImage:(UIImage * _Nullable)image;

+ (void)addNewRoutineFromCurrentController:(UIViewController * _Nonnull)controller withVideo:(NSURL * _Nullable)videoURL orImage:(UIImage * _Nullable)image;

+ (void)addNewSleightFromCurrentController:(UIViewController * _Nonnull)controller withVideo:(NSURL * _Nullable)videoURL orImage:(UIImage * _Nullable)image;

+ (void)addNewPropFromCurrentController:(UIViewController * _Nonnull)controller withVideo:(NSURL * _Nullable)videoURL orImage:(UIImage * _Nullable)image;

+ (void)addNewLinesFromCurrentController:(UIViewController * _Nonnull)controller;

+ (void)addNewLinesFromCurrentController:(UIViewController * _Nonnull)controller withAudio:(NSString * _Nullable)filePath;


+ (void)showAlertControllerWithTextFieldFromCurrentController:(UIViewController * _Nonnull)controller comfirmHandler:(void (^ __nullable)(NSString * __nullable title))comfirmHandler editMoreHandler:(void (^ __nullable)(NSString * __nullable title)) editMoreHandler;

@end
