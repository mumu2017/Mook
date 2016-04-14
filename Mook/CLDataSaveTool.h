//
//  CLDataSaveTool.h
//  Mook
//
//  Created by 陈林 on 16/3/22.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLRoutineModel, CLShowModel, CLIdeaObjModel, CLSleightObjModel, CLPropObjModel, CLLinesObjModel, CLEffectModel;

@interface CLDataSaveTool : NSObject

#pragma mark - 数据方法
+ (NSMutableArray *)allItems;
+ (NSMutableArray <CLShowModel*>*)allShows;
+ (NSMutableArray <CLRoutineModel*>*)allRoutines;
+ (NSMutableArray <CLIdeaObjModel*>*)allIdeas;
+ (NSMutableArray <CLSleightObjModel*>*)allSleights;
+ (NSMutableArray <CLPropObjModel*>*)allProps;
+ (NSMutableArray <CLLinesObjModel*>*)allLines;

+ (CLShowModel *)showByName:(NSString *)name;
+ (CLRoutineModel *)routineByName:(NSString *)name;
+ (CLIdeaObjModel *)ideaByName:(NSString *)name;
+ (CLSleightObjModel *)sleightByName:(NSString *)name;
+ (CLPropObjModel *)propByName:(NSString *)name;
+ (CLLinesObjModel *)linesByName:(NSString *)name;

+ (BOOL)updateRoutine:(CLRoutineModel *)routineModel;
+ (BOOL)deleteRoutine:(CLRoutineModel *)routineModel;

+ (BOOL)updateShow:(CLShowModel *)showModel;
+ (BOOL)deleteShow:(CLShowModel *)showModel;

+ (BOOL)updateIdea:(CLIdeaObjModel *)ideaObjModel;
+ (BOOL)deleteIdea:(CLIdeaObjModel *)ideaObjModel;

+ (BOOL)updateSleight:(CLSleightObjModel *)sleightObjModel;
+ (BOOL)deleteSleight:(CLSleightObjModel *)sleightObjModel;

+ (BOOL)updateProp:(CLPropObjModel *)propObjModel;
+ (BOOL)deleteProp:(CLPropObjModel *)propObjModel;

+ (BOOL)updateLines:(CLLinesObjModel *)linesObjModel;
+ (BOOL)deleteLines:(CLLinesObjModel *)linesObjModel;

#pragma mark - 标签方法
+ (NSMutableArray *)allTags;
+ (NSMutableArray *)allTagsShow;
+ (NSMutableArray *)allTagsIdea;
+ (NSMutableArray *)allTagsRoutine;
+ (NSMutableArray *)allTagsSleight;
+ (NSMutableArray *)allTagsProp;
+ (NSMutableArray *)allTagsLines;

+ (void)addTag:(NSString *)tag type:(NSString *)type;
+ (void)deleteTag:(NSString *)tag type:(NSString *)type;

#pragma mark - 多媒体方法
+ (NSMutableArray *)allMedia;
+ (NSMutableArray *)allVideos;
+ (NSMutableArray *)allImages;

+ (NSData *)videoByName:(NSString *)name;
+ (UIImage *)imageByName:(NSString *)name;

// timaStamp是多媒体所在模型的timaStamp, 这样可以建立模型与多媒体之间的联系
+ (void)addVideoByName:(NSString *)name timesStamp:(NSString *)timeStamp content:(NSString *)content type:(NSString *)type;
+ (void)addImageByName:(NSString *)name timesStamp:(NSString *)timeStamp content:(NSString *)content type:(NSString *)type;

+ (void)updateVideoByName:(NSString *)name withContent:(NSString *)content;
+ (void)updateImageByName:(NSString *)name withContent:(NSString *)content;

+ (void)deleteMediaByName:(NSString *)name;

+ (void)deleteMediaInEffectModel:(CLEffectModel *)effectModel prepModelList:(NSMutableArray *)prepModelList performModelList:(NSMutableArray *)performModelList;
//+ (void)deleteVideoByName:(NSString *)name;
//+ (void)deleteImageByName:(NSString *)name;

@end
