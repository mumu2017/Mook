//
//  CLDataSaveTool.h
//  Mook
//
//  Created by 陈林 on 16/3/22.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLRoutineModel, CLShowModel, CLIdeaObjModel, CLSleightObjModel, CLPropObjModel, CLLinesObjModel, CLEffectModel, CLWebSiteModel;

@interface CLDataSaveTool : NSObject

#pragma mark - 数据方法
// 获取各类型数据
+ (NSMutableArray *)allItems;
+ (NSMutableArray <CLShowModel*>*)allShows;
+ (NSMutableArray <CLRoutineModel*>*)allRoutines;
+ (NSMutableArray <CLIdeaObjModel*>*)allIdeas;
+ (NSMutableArray <CLSleightObjModel*>*)allSleights;
+ (NSMutableArray <CLPropObjModel*>*)allProps;
+ (NSMutableArray <CLLinesObjModel*>*)allLines;

// 获取单个模型
+ (CLShowModel *)showByName:(NSString *)name;
+ (CLRoutineModel *)routineByName:(NSString *)name;
+ (CLIdeaObjModel *)ideaByName:(NSString *)name;
+ (CLSleightObjModel *)sleightByName:(NSString *)name;
+ (CLPropObjModel *)propByName:(NSString *)name;
+ (CLLinesObjModel *)linesByName:(NSString *)name;

// 更新数据
+ (BOOL)updateRoutine:(CLRoutineModel *)routineModel;
+ (void)deleteRoutine:(CLRoutineModel *)routineModel;

+ (BOOL)updateShow:(CLShowModel *)showModel;
+ (void)deleteShow:(CLShowModel *)showModel;

+ (BOOL)updateIdea:(CLIdeaObjModel *)ideaObjModel;
+ (void)deleteIdea:(CLIdeaObjModel *)ideaObjModel;

+ (BOOL)updateSleight:(CLSleightObjModel *)sleightObjModel;
+ (void)deleteSleight:(CLSleightObjModel *)sleightObjModel;

+ (BOOL)updateProp:(CLPropObjModel *)propObjModel;
+ (void)deleteProp:(CLPropObjModel *)propObjModel;

+ (BOOL)updateLines:(CLLinesObjModel *)linesObjModel;
+ (void)deleteLines:(CLLinesObjModel *)linesObjModel;

#pragma mark - 标签方法
//获取标签数据
+ (NSMutableArray *)allTags;
+ (NSMutableArray *)allTagsShow;
+ (NSMutableArray *)allTagsIdea;
+ (NSMutableArray *)allTagsRoutine;
+ (NSMutableArray *)allTagsSleight;
+ (NSMutableArray *)allTagsProp;
+ (NSMutableArray *)allTagsLines;

// 增删标签
+ (void)addTag:(NSString *)tag type:(NSString *)type;
+ (void)deleteTag:(NSString *)tag type:(NSString *)type;

#pragma mark - 多媒体方法
// 获取多媒体数据
+ (NSMutableArray *)allMedia;
+ (NSMutableArray *)allVideos;
+ (NSMutableArray *)allImages;
+ (NSMutableArray *)allAudios;

+ (NSData *)videoByName:(NSString *)name;
+ (UIImage *)imageByName:(NSString *)name;
+ (NSURL *)audioByName:(NSString *)name;

// timaStamp是多媒体所在模型的timaStamp, 这样可以建立模型与多媒体之间的联系
+ (void)addVideoByName:(NSString *)name timesStamp:(NSString *)timeStamp content:(NSString *)content type:(NSString *)type;
+ (void)addImageByName:(NSString *)name timesStamp:(NSString *)timeStamp content:(NSString *)content type:(NSString *)type;
+ (void)addAudioByName:(NSString *)name timesStamp:(NSString *)timeStamp content:(NSString *)content type:(NSString *)type;

+ (void)updateVideoByName:(NSString *)name withContent:(NSString *)content;
+ (void)updateImageByName:(NSString *)name withContent:(NSString *)content;
+ (void)updateAudioByName:(NSString *)name withContent:(NSString *)content;

+ (void)deleteMediaByName:(NSString *)name;

+ (void)deleteMediaInEffectModel:(CLEffectModel *)effectModel prepModelList:(NSMutableArray *)prepModelList performModelList:(NSMutableArray *)performModelList;
//+ (void)deleteVideoByName:(NSString *)name;
//+ (void)deleteImageByName:(NSString *)name;

#pragma mark - 网站部分

+ (NSMutableArray <CLWebSiteModel *>*)allWebSites;
+ (NSMutableArray <CLWebSiteModel *>*)allWebNotes;

// 获取单个模型
+ (CLWebSiteModel *)webSiteByName:(NSString *)name;
+ (CLWebSiteModel *)webSiteByUrlString:(NSString *)string;

+ (BOOL)updateWebSite:(CLWebSiteModel *)webSite;
+ (BOOL)updateWebNote:(CLWebSiteModel *)webSite;

+ (void)deleteWebSite:(CLWebSiteModel *)webSite;

@end
