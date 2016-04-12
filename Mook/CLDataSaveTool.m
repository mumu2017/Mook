//
//  CLRoutineSaveTool.m
//  Mook
//
//  Created by 陈林 on 16/3/22.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLDataSaveTool.h"
#import "FMDB.h"
#import "NSObject+MJKeyValue.h"

#import "CLRoutineModel.h"
#import "CLShowModel.h"
#import "CLIdeaObjModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"

#import "CLEffectModel.h"
#import "CLPropModel.h"
#import "CLPrepModel.h"
#import "CLPerformModel.h"
#import "CLNotesModel.h"

@implementation CLDataSaveTool

static FMDatabase *_db;
+ (void)initialize
{
    NSString *mookPath = [NSString mookPath];
    // 拼接文件名
    NSString *filePath = [mookPath stringByAppendingPathComponent:@"mook.sqlite"];
    // 创建了一个数据库实例
    _db = [FMDatabase databaseWithPath:filePath];
    
    // 打开数据库
    if ([_db open]) {
        NSLog(@"打开成功");
    }else{
        NSLog(@"打开失败");
    }
    
    // 创建Data表格
    BOOL flag1 = [_db executeUpdate:@"create table if not exists t_mook (id integer primary key autoincrement,type text,time_stamp text,dict blob);"];
    if (flag1) {
        NSLog(@"创建Data表成功");
    }else{
        NSLog(@"创建Data表失败");
    }
    
    // 创建标签表格
    BOOL flag2 = [_db executeUpdate:@"create table if not exists t_tag (id integer primary key autoincrement,type text,tag text);"];
    if (flag2) {
        NSLog(@"创建Tag表成功");
    }else{
        NSLog(@"创建Tag表失败");
    }
    
    // 创建Media表格
    BOOL flag3 = [_db executeUpdate:@"create table if not exists t_media (id integer primary key autoincrement,type text,name text,content text,model_time_stamp text,model_type text);"];
    if (flag3) {
        NSLog(@"创建Media索引表成功");
    }else{
        NSLog(@"创建Media索引表失败");
    }
}

+ (NSMutableArray *)allItems {
    // 进入程序第一次获取的查询语句
    FMResultSet *set = [_db executeQuery:@"select * from t_mook;"];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSString *type = [set stringForColumn:@"type"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if ([type isEqualToString:kTypeIdea]) {
            CLIdeaObjModel *model = [CLIdeaObjModel objectWithKeyValues:dict];
            [arrM insertObject:model atIndex:0];
        } else if ([type isEqualToString:kTypeShow]) {
            CLShowModel *model = [CLShowModel objectWithKeyValues:dict];
            [arrM insertObject:model atIndex:0];
        } else if ([type isEqualToString:kTypeRoutine]) {
            CLRoutineModel *model = [CLRoutineModel objectWithKeyValues:dict];
            [arrM insertObject:model atIndex:0];
        } else if ([type isEqualToString:kTypeSleight]) {
            CLSleightObjModel *model = [CLSleightObjModel objectWithKeyValues:dict];
            [arrM insertObject:model atIndex:0];
        } else if ([type isEqualToString:kTypeProp]) {
            CLPropObjModel *model = [CLPropObjModel objectWithKeyValues:dict];
            [arrM insertObject:model atIndex:0];
        } else if ([type isEqualToString:kTypeLines]) {
            CLLinesObjModel *model = [CLLinesObjModel objectWithKeyValues:dict];
            [arrM insertObject:model atIndex:0];
        }
    }
    
    return arrM;
}

+ (NSMutableArray<CLShowModel *> *)allShows {
    // 进入程序第一次获取的查询语句
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=?;", kTypeShow];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLShowModel *showModel = [CLShowModel objectWithKeyValues:dict];
        [arrM insertObject:showModel atIndex:0];
    }
    
    return arrM;
}

+ (NSMutableArray <CLRoutineModel*>*)allRoutines {
    // 进入程序第一次获取的查询语句
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=?;",kTypeRoutine];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLRoutineModel *routineModel = [CLRoutineModel objectWithKeyValues:dict];
//        [arrM addObject:routineModel];
        [arrM insertObject:routineModel atIndex:0];
    }

    return arrM;
}


+ (NSMutableArray <CLIdeaObjModel*>*)allIdeas {
    
    // 进入程序第一次获取的查询语句
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=?;",kTypeIdea];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLIdeaObjModel *ideaObjModel = [CLIdeaObjModel objectWithKeyValues:dict];
//        [arrM addObject:ideaObjModel];
        [arrM insertObject:ideaObjModel atIndex:0];

    }
    
    return arrM;
    
}

+ (NSMutableArray <CLSleightObjModel*>*)allSleights {
    
    // 进入程序第一次获取的查询语句
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=?;",kTypeSleight];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLSleightObjModel *sleightObjModel = [CLSleightObjModel objectWithKeyValues:dict];
//        [arrM addObject:sleightObjModel];
        [arrM insertObject:sleightObjModel atIndex:0];

    }
    
    return arrM;
}


+ (NSMutableArray <CLPropObjModel*>*)allProps {
    // 进入程序第一次获取的查询语句
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=?;",kTypeProp];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLPropObjModel *propObjModel = [CLPropObjModel objectWithKeyValues:dict];
//        [arrM addObject:propObjModel];
        [arrM insertObject:propObjModel atIndex:0];

    }
    
    return arrM;
}


+ (NSMutableArray <CLLinesObjModel*>*)allLines {
    // 进入程序第一次获取的查询语句
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=?;",kTypeLines];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLLinesObjModel *linesObjModel = [CLLinesObjModel objectWithKeyValues:dict];
//        [arrM addObject:linesObjModel];
        [arrM insertObject:linesObjModel atIndex:0];

    }
    
    return arrM;
}

+ (CLShowModel *)showByName:(NSString *)name {
    
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=? and time_stamp=?;",kTypeShow, name];
    
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLShowModel *model = [CLShowModel objectWithKeyValues:dict];
        return model;
    }
    
    return nil;
}

+ (CLRoutineModel *)routineByName:(NSString *)name {
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=? and time_stamp=?;",kTypeRoutine, name];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLRoutineModel *model = [CLRoutineModel objectWithKeyValues:dict];
        return model;
    }
    return nil;
}

+ (CLIdeaObjModel *)ideaByName:(NSString *)name {
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=? and time_stamp=?;",kTypeIdea, name];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLIdeaObjModel *model = [CLIdeaObjModel objectWithKeyValues:dict];
        return model;
    }
    return nil;
}

+ (CLSleightObjModel *)sleightByName:(NSString *)name {
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=? and time_stamp=?;",kTypeSleight, name];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLSleightObjModel *model = [CLSleightObjModel objectWithKeyValues:dict];
        return model;
    }
    return nil;
}

+ (CLPropObjModel *)propByName:(NSString *)name {
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=? and time_stamp=?;",kTypeProp, name];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLPropObjModel *model = [CLPropObjModel objectWithKeyValues:dict];
        return model;
    }
    return nil;
}

+ (CLLinesObjModel *)linesModelByName:(NSString *)name {
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=? and time_stamp=?;",kTypeLines, name];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"dict"];
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        CLLinesObjModel *model = [CLLinesObjModel objectWithKeyValues:dict];
        return model;
    }
    return nil;
}

+ (void)updateShow:(CLShowModel *)showModel;
{
    NSDictionary *dict = [showModel keyValues];
    NSString *timeStamp = showModel.timeStamp;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=? and time_stamp=?", kTypeShow, timeStamp];
    
    // 如果[set next]不为空,则表示查询到至少一个结果.所以更新数据.
    if ([set next]) {
        
        BOOL flag = [_db executeUpdate:@"update t_mook set dict=? where time_stamp=?", data, timeStamp];
        if (flag) {
            NSLog(@"更新Show成功");
        }else{
            NSLog(@"更新Show失败");
        }
        
    } else {    // 如果为空,则表示没有查询到任何符合条件的结果,所以插入数据.
        BOOL flag = [_db executeUpdate:@"insert into t_mook (type, time_stamp, dict) values(?,?,?)", kTypeShow, timeStamp, data];
        if (flag) {
            NSLog(@"插入Show成功");
        }else{
            NSLog(@"插入Show失败");
        }
    }
}

+ (void)deleteShow:(CLShowModel *)showModel {
    
    NSString *timeStamp = showModel.timeStamp;
    
    BOOL flag = [_db executeUpdate:@"delete from t_mook where type=? and time_stamp=?", kTypeShow, timeStamp];
    if (flag) {
        NSLog(@"删除Show成功");
    }else{
        NSLog(@"删除Show失败");
    }
}

#pragma mark - 存储数据
+ (void)updateRoutine:(CLRoutineModel *)routineModel {
    
    NSDictionary *dict = [routineModel keyValues];
    NSString *timeStamp = routineModel.timeStamp;
    NSString *type = routineModel.type;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    [self updateData:data withType:type timeStamp:timeStamp];
}

+ (void)updateIdea:(CLIdeaObjModel *)ideaObjModel {
    
    NSDictionary *dict = [ideaObjModel keyValues];
    NSString *timeStamp = ideaObjModel.timeStamp;
    NSString *type = ideaObjModel.type;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    [self updateData:data withType:type timeStamp:timeStamp];

}

+ (void)updateSleight:(CLSleightObjModel *)sleightObjModel {
    
    NSDictionary *dict = [sleightObjModel keyValues];
    NSString *timeStamp = sleightObjModel.timeStamp;
    NSString *type = sleightObjModel.type;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    [self updateData:data withType:type timeStamp:timeStamp];
    
}


+ (void)updateProp:(CLPropObjModel *)propObjModel {
    
    NSDictionary *dict = [propObjModel keyValues];
    NSString *timeStamp = propObjModel.timeStamp;
    NSString *type = propObjModel.type;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    [self updateData:data withType:type timeStamp:timeStamp];
    
}


+ (void)updateLines:(CLLinesObjModel *)linesObjModel {
    
    NSDictionary *dict = [linesObjModel keyValues];
    NSString *timeStamp = linesObjModel.timeStamp;
    NSString *type = linesObjModel.type;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    [self updateData:data withType:type timeStamp:timeStamp];
    
}



+ (void)updateData:(NSData *)data withType:(NSString *)type timeStamp:(NSString *)timeStamp {
    
    FMResultSet *set = [_db executeQuery:@"select * from t_mook where type=? and time_stamp=?", type, timeStamp];
    
    // 如果[set next]不为空,则表示查询到至少一个结果.所以更新数据.
    if ([set next]) {
        
        BOOL flag = [_db executeUpdate:@"update t_mook set dict=? where time_stamp=?", data, timeStamp];
        if (flag) {
            NSLog(@"更新成功");
        }else{
            NSLog(@"更新失败");
        }
        
    } else {    // 如果为空,则表示没有查询到任何符合条件的结果,所以插入数据.
        BOOL flag = [_db executeUpdate:@"insert into t_mook (type, time_stamp, dict) values(?,?,?)",type, timeStamp, data];
        if (flag) {
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
    }
}

#pragma mark - 删除数据

+ (void)deleteRoutine:(CLRoutineModel *)routineModel {
    
    NSString *timeStamp = routineModel.timeStamp;
    [self deleteDataWithStamp:timeStamp];
    [self deleteMediaInEffectModel:routineModel.effectModel prepModelList:routineModel.prepModelList performModelList:routineModel.performModelList];
    
}

+ (void)deleteIdea:(CLIdeaObjModel *)ideaObjModel {
    NSString *timeStamp = ideaObjModel.timeStamp;
    [self deleteDataWithStamp:timeStamp];
    
    [self deleteMediaInEffectModel:ideaObjModel.effectModel prepModelList:ideaObjModel.prepModelList performModelList:nil];
}

+ (void)deleteSleight:(CLSleightObjModel *)sleightObjModel {
    NSString *timeStamp = sleightObjModel.timeStamp;
    [self deleteDataWithStamp:timeStamp];
    
    [self deleteMediaInEffectModel:sleightObjModel.effectModel prepModelList:sleightObjModel.prepModelList performModelList:nil];
}

+ (void)deleteProp:(CLPropObjModel *)propObjModel {
    NSString *timeStamp = propObjModel.timeStamp;
    [self deleteDataWithStamp:timeStamp];
    
    [self deleteMediaInEffectModel:propObjModel.effectModel prepModelList:propObjModel.prepModelList performModelList:nil];
}

+ (void)deleteLines:(CLLinesObjModel *)linesObjModel {
    NSString *timeStamp = linesObjModel.timeStamp;
    [self deleteDataWithStamp:timeStamp];

}


+ (void)deleteDataWithStamp:(NSString *)timeStamp {
    BOOL flag = [_db executeUpdate:@"delete from t_mook where time_stamp=?", timeStamp];
    if (flag) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

#pragma mark - 删除多媒体数据
+ (void)deleteMediaInEffectModel:(CLEffectModel *)effectModel prepModelList:(NSMutableArray *)prepModelList performModelList:(NSMutableArray *)performModelList {
    
    [effectModel deleteMedia];
    
    for (CLPrepModel *prepModel in prepModelList) {
        [prepModel deleteMedia];
    }
    
    for (CLPerformModel *performModel in performModelList) {
        [performModel deleteMedia];
    }
}

#pragma mark - 标签方法

+ (NSMutableArray *)allTags {
    
    FMResultSet *set = [_db executeQuery:@"select * from t_tag;"];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSString *tag = [set stringForColumn:@"tag"];
        [arrM insertObject:tag atIndex:0];
    }
    
    return arrM;
}

+ (NSMutableArray *)allTagsShow {
    
    FMResultSet *set = [_db executeQuery:@"select * from t_tag where type=?;",kTypeShow];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSString *tag = [set stringForColumn:@"tag"];
        [arrM insertObject:tag atIndex:0];
    }
    NSLog(@"%@", arrM);
    return arrM;
}

+ (NSMutableArray *)allTagsIdea {
    
    FMResultSet *set = [_db executeQuery:@"select * from t_tag where type=?;",kTypeIdea];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSString *tag = [set stringForColumn:@"tag"];
        [arrM insertObject:tag atIndex:0];
    }
    NSLog(@"%@", arrM);
    return arrM;
}

+ (NSMutableArray *)allTagsRoutine {
    
    FMResultSet *set = [_db executeQuery:@"select * from t_tag where type=?;",kTypeRoutine];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSString *tag = [set stringForColumn:@"tag"];
        [arrM insertObject:tag atIndex:0];
    }
    
    return arrM;
}


+ (NSMutableArray *)allTagsSleight {
    
    FMResultSet *set = [_db executeQuery:@"select * from t_tag where type=?;",kTypeSleight];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSString *tag = [set stringForColumn:@"tag"];
        [arrM insertObject:tag atIndex:0];
    }
    
    return arrM;
}

+ (NSMutableArray *)allTagsProp {
    
    FMResultSet *set = [_db executeQuery:@"select * from t_tag where type=?;",kTypeProp];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSString *tag = [set stringForColumn:@"tag"];
        [arrM insertObject:tag atIndex:0];
    }
    
    return arrM;
}

+ (NSMutableArray *)allTagsLines {
    
    FMResultSet *set = [_db executeQuery:@"select * from t_tag where type=?;",kTypeLines];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSString *tag = [set stringForColumn:@"tag"];
        [arrM insertObject:tag atIndex:0];
    }
    
    return arrM;
}

+ (void)addTag:(NSString *)tag type:(NSString *)type {

    FMResultSet *set = [_db executeQuery:@"select * from t_tag where type=? and tag=?", type, tag];
    
    // 如果[set next]不为空,则表示查询到至少一个结果.所以更新数据.
    if ([set next]) {
        
        NSLog(@"tag alreadey exists");
        
    } else {    // 如果为空,则表示没有查询到任何符合条件的结果,所以插入数据.
        
        BOOL flag = [_db executeUpdate:@"insert into t_tag (tag, type) values(?,?)", tag, type];
        if (flag) {
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }

    }

}

+ (void)deleteTag:(NSString *)tag type:(NSString *)type {
    BOOL flag = [_db executeUpdate:@"delete from t_tag where type=? and tag=?", type, tag];
    if (flag) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

#pragma mark - 多媒体方法
+ (NSMutableArray *)allMedia { // 所有模型中包含的多媒体
    FMResultSet *set = [_db executeQuery:@"select * from t_media;"];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSString *modelName = [set stringForColumn:@"model_time_stamp"];
        
        // 先查询是否存在对应模型
        FMResultSet *set1 = [_db executeQuery:@"select * from t_mook where  time_stamp=?;", modelName];
        if ([set1 next]) {        // 如果[set next]不为空,则表示查询到至少一个结果.所以更新数据.

            NSString *type = [set stringForColumn:@"type"];
            NSString *name = [set stringForColumn:@"name"];
            NSString *content = [set stringForColumn:@"content"];
            if (content == nil) content = @" "; // content可能没有内容
            
            NSString *modelType = [set stringForColumn:@"model_type"];
            NSDictionary *dict = @{@"type":type, @"name":name, @"content":content, @"model_time_stamp":modelName, @"model_type":modelType};
            [arrM insertObject:dict atIndex:0];
            
        } else { // 如果在t_mook表中没有查询到对应模型条目, 则表示包含该多媒体的模型已经被删除, 所以在这里删除掉该条多媒体.
            
            NSString *type = [set stringForColumn:@"type"];
            NSString *name = [set stringForColumn:@"name"];
            
            if ([type isEqualToString:@"video"]) {
                [name deleteNamedVideoFromDocument];
            } else if ([type isEqualToString:@"image"]) {
                [name deleteNamedImageFromDocument];
            }
        }
    }
    
    return arrM;
}

+ (NSMutableArray *)allVideos {
    FMResultSet *set = [_db executeQuery:@"select * from t_media where type=?;",@"video"];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSString *name = [set stringForColumn:@"name"];
        [arrM insertObject:name atIndex:0];
    }
    
    return arrM;
}

+ (NSMutableArray *)allImages {
    FMResultSet *set = [_db executeQuery:@"select * from t_media where type=?;",@"image"];
    NSMutableArray *arrM = [NSMutableArray array];
    while ([set next]) {
        NSString *name = [set stringForColumn:@"name"];
        [arrM insertObject:name atIndex:0];
    }
    
    return arrM;
}

+ (NSData *)videoByName:(NSString *)name {
    return nil;
}

+ (UIImage *)imageByName:(NSString *)name {
    return nil;
}

// timaStamp是多媒体所在模型的timaStamp, 这样可以建立模型与多媒体之间的联系
+ (void)addVideoByName:(NSString *)name timesStamp:(NSString *)timeStamp content:(NSString *)content type:(NSString *)type{
    
    BOOL flag = [_db executeUpdate:@"insert into t_media (type, name, content, model_time_stamp, model_type) values(?,?,?,?,?)", @"video", name, content, timeStamp, type];
    if (flag) {
        NSLog(@"插入media索引成功");
    }else{
        NSLog(@"插入media索引失败");
    }
}

//id integer primary key autoincrement,type text,name text,model_time_stamp text)

+ (void)addImageByName:(NSString *)name timesStamp:(NSString *)timeStamp content:(NSString *)content type:(NSString *)type {
    BOOL flag = [_db executeUpdate:@"insert into t_media (type, name, content, model_time_stamp, model_type) values(?,?,?,?,?)", @"image", name, content, timeStamp, type];
    if (flag) {
        NSLog(@"插入media索引成功");
    }else{
        NSLog(@"插入media索引失败");
    }
}

+ (void)updateVideoByName:(NSString *)name withContent:(NSString *)content {
    
    BOOL flag = [_db executeUpdate:@"update t_media set content=? where name=?", content, name];
    if (flag) {
        NSLog(@"更新成功");
    }else{
        NSLog(@"更新失败");
    }
}

+ (void)updateImageByName:(NSString *)name withContent:(NSString *)content {
    BOOL flag = [_db executeUpdate:@"update t_media set content=? where name=?", content, name];
    if (flag) {
        NSLog(@"更新成功");
    }else{
        NSLog(@"更新失败");
    }
}

+ (void)deleteMediaByName:(NSString *)name {
    BOOL flag = [_db executeUpdate:@"delete from t_media where name=?", name];
    if (flag) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

@end
