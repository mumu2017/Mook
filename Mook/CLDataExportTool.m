//
//  CLDataExportTool.m
//  Mook
//
//  Created by 陈林 on 16/4/11.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLDataExportTool.h"

#import "NSObject+MJKeyValue.h"
#import "ZipArchive.h"

#import "CLShowModel.h"
#import "CLIdeaObjModel.h"
#import "CLRoutineModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"

#import "CLInfoModel.h"
#import "CLEffectModel.h"
#import "CLPropModel.h"
#import "CLPrepModel.h"
#import "CLPerformModel.h"
#import "CLNotesModel.h"

@implementation CLDataExportTool

+ (NSString *)makeDataPackageWithRoutine:(CLRoutineModel *)routineModel  passWord:(NSString *)passWord {
    
    if (passWord == nil) {
        passWord = @"";
    }
    NSDictionary *modelDict = [routineModel keyValues];
    NSDictionary *dict = @{@"type":kTypeRoutine, @"model":modelDict, @"passWord":passWord};
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [data writeToFile:[NSString tempSharePath] atomically:YES];
    
    NSMutableArray *pathArrM = [NSMutableArray array];
    [pathArrM addObject:[NSString tempSharePath]]; // 加入模型data路径
    
    NSString *mediaPath;
    
    if (routineModel.effectModel.isWithImage) {
        mediaPath = [[NSString imagePath] stringByAppendingPathComponent:routineModel.effectModel.image];
        if (mediaPath != nil) [pathArrM addObject:mediaPath];
        
    } else if (routineModel.effectModel.isWithVideo) {
        
        mediaPath = [[NSString videoPath] stringByAppendingPathComponent:routineModel.effectModel.video];
        if (mediaPath != nil) [pathArrM addObject:mediaPath];
        
    }
    
    for (CLPerformModel *model in routineModel.performModelList) {
        if (model.isWithImage) {
            mediaPath = [[NSString imagePath] stringByAppendingPathComponent:model.image];
            if (mediaPath != nil) [pathArrM addObject:mediaPath];
            
        } else if (model.isWithVideo) {
            mediaPath = [[NSString videoPath] stringByAppendingPathComponent:model.video];
            if (mediaPath != nil) [pathArrM addObject:mediaPath];
            
        }
    }
    
    for (CLPrepModel *model in routineModel.prepModelList) {
        if (model.isWithImage) {
            mediaPath = [[NSString imagePath] stringByAppendingPathComponent:model.image];
            if (mediaPath != nil) [pathArrM addObject:mediaPath];
            
        } else if (model.isWithVideo) {
            mediaPath = [[NSString videoPath] stringByAppendingPathComponent:model.video];
            if (mediaPath != nil) [pathArrM addObject:mediaPath];
            
        }
    }
    
    NSString *title = [NSString stringWithFormat:@"%@.mook", [routineModel getTitle]];
    NSString *zipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:title];
    BOOL success = [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:pathArrM withPassword:kZipPassword];
    if (success) {
        return zipPath;
    }
    
    return nil;
}

+ (NSString *)makeDataPackageWithIdea:(CLIdeaObjModel *)ideaObjModel passWord:(NSString *)passWord {
    
    if (passWord == nil) {
        passWord = @"";
    }
    NSDictionary *modelDict = [ideaObjModel keyValues];  // 模型转字典
    NSDictionary *dict = @{@"type":kTypeIdea, @"model":modelDict, @"passWord":passWord};   // 加入模型类型标识

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [data writeToFile:[NSString tempSharePath] atomically:YES];
    
    NSMutableArray *pathArrM = [NSMutableArray array];
    [pathArrM addObject:[NSString tempSharePath]]; // 加入模型data路径
    
    NSString *mediaPath;
    
    if (ideaObjModel.effectModel.isWithImage) {
        mediaPath = [[NSString imagePath] stringByAppendingPathComponent:ideaObjModel.effectModel.image];
        if (mediaPath != nil) [pathArrM addObject:mediaPath];   // 获取图片路径
        
    } else if (ideaObjModel.effectModel.isWithVideo) {
        
        mediaPath = [[NSString videoPath] stringByAppendingPathComponent:ideaObjModel.effectModel.video];
        if (mediaPath != nil) [pathArrM addObject:mediaPath];   // 获取视频路径
        
    }

    
    for (CLPrepModel *model in ideaObjModel.prepModelList) {
        if (model.isWithImage) {
            mediaPath = [[NSString imagePath] stringByAppendingPathComponent:model.image];
            if (mediaPath != nil) [pathArrM addObject:mediaPath];   // 获取图片路径
            
        } else if (model.isWithVideo) {
            mediaPath = [[NSString videoPath] stringByAppendingPathComponent:model.video];
            if (mediaPath != nil) [pathArrM addObject:mediaPath];   // 获取视频路径
            
        }
    }
    
    // 根据模型名称生成压缩文件路径
    NSString *title = [NSString stringWithFormat:@"%@.mook", [ideaObjModel getTitle]];
    NSString *zipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:title];
    // 压缩所有模型数据
    BOOL success = [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:pathArrM withPassword:kZipPassword];
    if (success) {  // 如果压缩成功, 返回压缩文件路径
        return zipPath;
    }
    
    return nil; // 如果压缩不成功, 返回nil
}

+ (NSString *)makeDataPackageWithSleight:(CLSleightObjModel *)sleightObjModel  passWord:(NSString *)passWord {
    
    if (passWord == nil) {
        passWord = @"";
    }
    NSDictionary *modelDict = [sleightObjModel keyValues];  // 模型转字典
    NSDictionary *dict = @{@"type":kTypeSleight, @"model":modelDict, @"passWord":passWord};   // 加入模型类型标识

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [data writeToFile:[NSString tempSharePath] atomically:YES];
    
    NSMutableArray *pathArrM = [NSMutableArray array];
    [pathArrM addObject:[NSString tempSharePath]]; // 加入模型data路径
    
    NSString *mediaPath;
    
    if (sleightObjModel.effectModel.isWithImage) {
        mediaPath = [[NSString imagePath] stringByAppendingPathComponent:sleightObjModel.effectModel.image];
        if (mediaPath != nil) [pathArrM addObject:mediaPath];   // 获取图片路径
        
    } else if (sleightObjModel.effectModel.isWithVideo) {
        
        mediaPath = [[NSString videoPath] stringByAppendingPathComponent:sleightObjModel.effectModel.video];
        if (mediaPath != nil) [pathArrM addObject:mediaPath];   // 获取视频路径
        
    }
    
    
    for (CLPrepModel *model in sleightObjModel.prepModelList) {
        if (model.isWithImage) {
            mediaPath = [[NSString imagePath] stringByAppendingPathComponent:model.image];
            if (mediaPath != nil) [pathArrM addObject:mediaPath];   // 获取图片路径
            
        } else if (model.isWithVideo) {
            mediaPath = [[NSString videoPath] stringByAppendingPathComponent:model.video];
            if (mediaPath != nil) [pathArrM addObject:mediaPath];   // 获取视频路径
            
        }
    }
    
    // 根据模型名称生成压缩文件路径
    NSString *title = [NSString stringWithFormat:@"%@.mook", [sleightObjModel getTitle]];
    NSString *zipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:title];
    // 压缩所有模型数据
    BOOL success = [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:pathArrM withPassword:kZipPassword];
    if (success) {  // 如果压缩成功, 返回压缩文件路径
        return zipPath;
    }
    
    return nil; // 如果压缩不成功, 返回nil
}

+ (NSString *)makeDataPackageWithProp:(CLPropObjModel *)propObjModel  passWord:(NSString *)passWord {
    
    if (passWord == nil) {
        passWord = @"";
    }
    
    NSDictionary *modelDict = [propObjModel keyValues];  // 模型转字典
    NSDictionary *dict = @{@"type":kTypeProp, @"model":modelDict, @"passWord":passWord};   // 加入模型类型标识

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [data writeToFile:[NSString tempSharePath] atomically:YES];
    
    NSMutableArray *pathArrM = [NSMutableArray array];
    [pathArrM addObject:[NSString tempSharePath]]; // 加入模型data路径
    
    NSString *mediaPath;
    
    if (propObjModel.effectModel.isWithImage) {
        mediaPath = [[NSString imagePath] stringByAppendingPathComponent:propObjModel.effectModel.image];
        if (mediaPath != nil) [pathArrM addObject:mediaPath];   // 获取图片路径
        
    } else if (propObjModel.effectModel.isWithVideo) {
        
        mediaPath = [[NSString videoPath] stringByAppendingPathComponent:propObjModel.effectModel.video];
        if (mediaPath != nil) [pathArrM addObject:mediaPath];   // 获取视频路径
        
    }
    
    
    for (CLPrepModel *model in propObjModel.prepModelList) {
        if (model.isWithImage) {
            mediaPath = [[NSString imagePath] stringByAppendingPathComponent:model.image];
            if (mediaPath != nil) [pathArrM addObject:mediaPath];   // 获取图片路径
            
        } else if (model.isWithVideo) {
            mediaPath = [[NSString videoPath] stringByAppendingPathComponent:model.video];
            if (mediaPath != nil) [pathArrM addObject:mediaPath];   // 获取视频路径
            
        }
    }
    
    // 根据模型名称生成压缩文件路径
    NSString *title = [NSString stringWithFormat:@"%@.mook", [propObjModel getTitle]];
    NSString *zipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:title];
    // 压缩所有模型数据
    BOOL success = [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:pathArrM withPassword:kZipPassword];
    if (success) {  // 如果压缩成功, 返回压缩文件路径
        return zipPath;
    }
    
    return nil; // 如果压缩不成功, 返回nil
}

+ (NSString *)makeDataPackageWithLines:(CLLinesObjModel *)linesObjModel  passWord:(NSString *)passWord {
    
    if (passWord == nil) {
        passWord = @"";
    }
    
    NSDictionary *modelDict = [linesObjModel keyValues];  // 模型转字典
    NSDictionary *dict = @{@"type":kTypeLines, @"model":modelDict, @"passWord":passWord};   // 加入模型类型标识

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    [data writeToFile:[NSString tempSharePath] atomically:YES];
    
    NSMutableArray *pathArrM = [NSMutableArray array];
    [pathArrM addObject:[NSString tempSharePath]]; // 加入模型data路径
    
    // 根据模型名称生成压缩文件路径
    NSString *title = [NSString stringWithFormat:@"%@.mook", [linesObjModel getTitle]];
    NSString *zipPath = [NSTemporaryDirectory() stringByAppendingPathComponent:title];
    // 压缩所有模型数据
    BOOL success = [SSZipArchive createZipFileAtPath:zipPath withFilesAtPaths:pathArrM withPassword:kZipPassword];
    if (success) {  // 如果压缩成功, 返回压缩文件路径
        return zipPath;
    }
    
    return nil; // 如果压缩不成功, 返回nil
}

@end
