//
//  CLDataExportTool.h
//  Mook
//
//  Created by 陈林 on 16/4/11.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLRoutineModel, CLIdeaObjModel, CLSleightObjModel, CLPropObjModel, CLLinesObjModel;

@interface CLDataExportTool : NSObject

// 生成压缩包,以便导出
+ (NSString *)makeDataPackageWithRoutine:(CLRoutineModel *)routineModel;
+ (NSString *)makeDataPackageWithIdea:(CLIdeaObjModel *)ideaObjModel;
+ (NSString *)makeDataPackageWithSleight:(CLSleightObjModel *)sleightObjModel;
+ (NSString *)makeDataPackageWithProp:(CLPropObjModel *)propObjModel;
+ (NSString *)makeDataPackageWithLines:(CLLinesObjModel *)linesObjModel;

@end
