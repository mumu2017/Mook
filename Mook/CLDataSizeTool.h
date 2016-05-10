//
//  CLDataSizeTool.h
//  Mook
//
//  Created by 陈林 on 16/4/14.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLRoutineModel, CLShowModel, CLIdeaObjModel, CLSleightObjModel, CLPropObjModel, CLLinesObjModel;

@interface CLDataSizeTool : NSObject

#pragma mark - 以后再添加文件尺寸功能.
+ (NSString *)totalSize;
+ (NSString *)sizeOfMook;
+ (NSString *)sizeOfCache;
+ (NSString *)sizeOfTemp;

+ (NSString *)sizeOfAllShows;
+ (NSString *)sizeOfAllRoutines;
+ (NSString *)sizeOfAllIdeas;
+ (NSString *)sizeOfAllSleights;
+ (NSString *)sizeOfAllProps;
+ (NSString *)sizeOfAllLines;

+ (NSNumber *)sizeOfShow:(CLShowModel *)showModel;
+ (NSNumber *)sizeOfRoutine:(CLRoutineModel *)routineModel;
+ (NSNumber *)sizeOfIdea:(CLIdeaObjModel *)ideaObjModel;
+ (NSNumber *)sizeOfSleight:(CLSleightObjModel *)sleightObjModel;
+ (NSNumber *)sizeOfProp:(CLPropObjModel *)propObjModel;
+ (NSNumber *)sizeOfLines:(CLLinesObjModel *)model;

+ (NSNumber *)textAverageSize;
+ (NSString *)sizeOfCacheAndTemporaryData;
+ (NSString *)sizeOfBackUp;

@end
