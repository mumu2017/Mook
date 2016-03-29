//
//  CLDataSaveTool.h
//  Mook
//
//  Created by 陈林 on 16/3/22.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLRoutineModel, CLShowModel, CLIdeaObjModel, CLSleightObjModel, CLPropObjModel, CLLinesObjModel;

@interface CLDataSaveTool : NSObject

#pragma mark - 数据方法
+ (NSMutableArray *)allItems;
//+ (NSMutableArray <CLShowModel*>*)allShows;
+ (NSMutableArray <CLRoutineModel*>*)allRoutines;
+ (NSMutableArray <CLIdeaObjModel*>*)allIdeas;
+ (NSMutableArray <CLSleightObjModel*>*)allSleights;
+ (NSMutableArray <CLPropObjModel*>*)allProps;
+ (NSMutableArray <CLLinesObjModel*>*)allLines;

+ (void)updateRoutine:(CLRoutineModel *)routineModel;
+ (void)deleteRoutine:(CLRoutineModel *)routineModel;

//+ (void)updateShow:(CLShowModel *)showModel;
//+ (void)deleteShow:(CLShowModel *)showModel;

+ (void)updateIdea:(CLIdeaObjModel *)ideaObjModel;
+ (void)deleteIdea:(CLIdeaObjModel *)ideaObjModel;

+ (void)updateSleight:(CLSleightObjModel *)sleightObjModel;
+ (void)deleteSleight:(CLSleightObjModel *)sleightObjModel;

+ (void)updateProp:(CLPropObjModel *)propObjModel;
+ (void)deleteProp:(CLPropObjModel *)propObjModel;

+ (void)updateLines:(CLLinesObjModel *)linesObjModel;
+ (void)deleteLines:(CLLinesObjModel *)linesObjModel;

#pragma mark - 标签方法
+ (NSMutableArray *)allTags;
+ (NSMutableArray *)allTagsIdea;
+ (NSMutableArray *)allTagsRoutine;
+ (NSMutableArray *)allTagsSleight;
+ (NSMutableArray *)allTagsProp;
+ (NSMutableArray *)allTagsLines;

+ (void)addTag:(NSString *)tag type:(NSString *)type;
+ (void)deleteTag:(NSString *)tag type:(NSString *)type;

#pragma mark - 多媒体方法
+ (NSMutableArray *)allVideos;
+ (NSMutableArray *)allImages;

+ (NSData *)videoByName:(NSString *)name;
+ (UIImage *)imageByName:(NSString *)name;

// timaStamp是多媒体所在模型的timaStamp, 这样可以建立模型与多媒体之间的联系
+ (void)addVideoByName:(NSString *)name timesStamp:(NSString *)timeStamp;
+ (void)addImageByName:(NSString *)name timesStamp:(NSString *)timeStamp;

+ (void)deleteVideoByName:(NSString *)name;
+ (void)deleteImageByName:(NSString *)name;

@end
