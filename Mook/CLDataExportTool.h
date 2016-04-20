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

// 生成压缩包,以便导出,返回值是压缩包的路径文本
+ (NSString *)makeDataPackageWithRoutine:(CLRoutineModel *)routineModel passWord:(NSString *)passWord;
+ (NSString *)makeDataPackageWithIdea:(CLIdeaObjModel *)ideaObjModel passWord:(NSString *)passWord;

+ (NSString *)makeDataPackageWithSleight:(CLSleightObjModel *)sleightObjModel passWord:(NSString *)passWord;

+ (NSString *)makeDataPackageWithProp:(CLPropObjModel *)propObjModel passWord:(NSString *)passWord;

+ (NSString *)makeDataPackageWithLines:(CLLinesObjModel *)linesObjModel passWord:(NSString *)passWord;


@end
