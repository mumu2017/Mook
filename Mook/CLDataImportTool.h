//
//  CLDataImportTool.h
//  Mook
//
//  Created by 陈林 on 16/4/11.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLRoutineModel, CLIdeaObjModel, CLSleightObjModel, CLPropObjModel, CLLinesObjModel;

@interface CLDataImportTool : NSObject

+ (NSDictionary *)getDataFromURL:(NSURL *)url;

// 拷贝导入压缩包中的多媒体到library中的多媒体文件中, 为呈现信息做准备
+ (void)prepareDataWithRoutine:(CLRoutineModel *)routineModel;
+ (void)prepareDataWithIdea:(CLIdeaObjModel *)ideaObjModel;
+ (void)prepareDataWithSleight:(CLSleightObjModel *)sleightObjModel;
+ (void)prepareDataWithProp:(CLPropObjModel *)propObjModel;
+ (void)prepareDataWithLines:(CLLinesObjModel *)linesObjModel;

// 如果用户选择不导入文件, 那就删除掉多媒体
+ (void)cancelImportRoutine:(CLRoutineModel *)routineModel;
+ (void)cancelImportIdea:(CLIdeaObjModel *)ideaObjModel;
+ (void)cancelImportSleight:(CLSleightObjModel *)sleightObjModel;
+ (void)cancelImportProp:(CLPropObjModel *)propObjModel;
+ (void)cancelImportLines:(CLLinesObjModel *)linesObjModel;

// 导入文件
+ (BOOL)importRoutine:(CLRoutineModel *)routineModel;
+ (BOOL)importIdea:(CLIdeaObjModel *)ideaObjModel;
+ (BOOL)importSleight:(CLSleightObjModel *)sleightObjModel;
+ (BOOL)importProp:(CLPropObjModel *)propObjModel;
+ (BOOL)importLines:(CLLinesObjModel *)linesObjModel;

// 单项多媒体拷贝到library多媒体文件夹中和数据库Media表中
+ (NSString *)copyTempUnzipImageToMook:(NSString *)imageName modelTimeStamp:(NSString *)timeStamp content:(NSString *)content type:(NSString *)type;
+ (NSString *)copyTempUnzipVideoToMook:(NSString *)videoName modelTimeStamp:(NSString *)timeStamp content:(NSString *)content type:(NSString *)type;


@end
