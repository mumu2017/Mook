//
//  CLDataImportTool.m
//  Mook
//
//  Created by 陈林 on 16/4/11.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLDataImportTool.h"
#import "CLDataSaveTool.h"

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


@implementation CLDataImportTool

#pragma mark - 导入数据 

// 打开URL的数据,并做好准备
+ (NSDictionary *)getDataFromURL:(NSURL *)url {
    // 因为文件以及在Document的Inbox文件夹中,所以不用再次拷贝
    
    if (url != nil) {
//        NSLog(@"url is here!");
        
        NSError *err;
        BOOL flag = [SSZipArchive unzipFileAtPath:[url path] toDestination:[NSString tempUnzipPath] overwrite:YES password:kZipPassword error:&err];
        
        if (flag) {
            NSLog(@"unzip sucess");
            
            NSData *data = [NSData dataWithContentsOfFile:[[NSString tempUnzipPath] stringByAppendingPathComponent:@"mookShare.data"]];
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            // 解压后删除Inbox中的文件
            BOOL flag1 = [[NSFileManager defaultManager] removeItemAtURL:url error:NULL];
            if (flag1) {
                NSLog(@"INBOX CLEANED");
            } else {
                // 如果删除不成功,再尝试删除一次
                [[NSFileManager defaultManager] removeItemAtURL:url error:NULL];
            }
            
            return dict;
            
        } else {
            NSLog(@"unzip failed");
            // 解压后删除Inbox中的文件
            BOOL flag1 = [[NSFileManager defaultManager] removeItemAtURL:url error:NULL];
            if (flag1) {
                NSLog(@"INBOX CLEANED");
            } else {
                // 如果删除不成功,再尝试删除一次
                [[NSFileManager defaultManager] removeItemAtURL:url error:NULL];
            }
            
            return nil;
        }
        
    }
    
    return nil;
}


+ (BOOL)importRoutine:(CLRoutineModel *)routineModel {
    
   return [CLDataSaveTool updateRoutine:routineModel];
}

+ (BOOL)importIdea:(CLIdeaObjModel *)ideaObjModel {
    
    return [CLDataSaveTool updateIdea:ideaObjModel];

}

+ (BOOL)importSleight:(CLSleightObjModel *)sleightObjModel {
    
    return [CLDataSaveTool updateSleight:sleightObjModel];
}

+ (BOOL)importProp:(CLPropObjModel *)propObjModel {
    
    return [CLDataSaveTool updateProp:propObjModel];
}

+ (BOOL)importLines:(CLLinesObjModel *)linesObjModel {
    
    return [CLDataSaveTool updateLines:linesObjModel];
}

+ (void)cancelImportRoutine:(CLRoutineModel *)routineModel {
    
    [CLDataSaveTool deleteMediaInEffectModel:routineModel.effectModel prepModelList:routineModel.prepModelList performModelList:routineModel.performModelList];
}

+ (void)cancelImportIdea:(CLIdeaObjModel *)ideaObjModel {
    
    [CLDataSaveTool deleteMediaInEffectModel:ideaObjModel.effectModel prepModelList:ideaObjModel.prepModelList performModelList:nil];

}

+ (void)cancelImportSleight:(CLSleightObjModel *)sleightObjModel {
    
    [CLDataSaveTool deleteMediaInEffectModel:sleightObjModel.effectModel prepModelList:sleightObjModel.prepModelList performModelList:nil];
}

+ (void)cancelImportProp:(CLPropObjModel *)propObjModel {
    
    [CLDataSaveTool deleteMediaInEffectModel:propObjModel.effectModel prepModelList:propObjModel.prepModelList performModelList:nil];
}

+ (void)cancelImportLines:(CLLinesObjModel *)linesObjModel {
    
    // 没有多媒体,什么也不用执行
}

#pragma mark - 拷贝多媒体数据到本地多媒体文件夹
+ (void)prepareDataWithRoutine:(CLRoutineModel *)routineModel {
    
    routineModel.date = [NSDate date];
    routineModel.timeStamp = kTimestamp;
    
    // 重设标签
    NSString *tag = NSLocalizedString(@"导入", nil);
    
    if ([routineModel.infoModel.name containsString:[NSString stringWithFormat:@"(%@)", tag]] == NO) {
        routineModel.infoModel.name = [NSString stringWithFormat:@"%@(%@)", routineModel.infoModel.name, tag];
    }
    
    routineModel.tags = [NSMutableArray arrayWithObject:tag];
    [CLDataSaveTool addTag:tag type:kTypeRoutine];
    
    if (routineModel.effectModel.image.length > 0) {
        
        routineModel.effectModel.image = [CLDataImportTool copyTempUnzipImageToMook:routineModel.effectModel.image modelTimeStamp:routineModel.timeStamp content:routineModel.effectModel.effect type:kTypeRoutine];
        
    } else if (routineModel.effectModel.video.length > 0) {
        
        routineModel.effectModel.video = [CLDataImportTool copyTempUnzipVideoToMook:routineModel.effectModel.video modelTimeStamp:routineModel.timeStamp content:routineModel.effectModel.effect type:kTypeRoutine];
        
    }
    
    for (CLPerformModel *model in routineModel.performModelList) {
        if (model.image.length > 0) {
            
            model.image = [CLDataImportTool copyTempUnzipImageToMook:model.image modelTimeStamp:routineModel.timeStamp content:model.perform type:kTypeRoutine];
            
            
        } else if (model.video.length > 0) {
            
            model.video = [CLDataImportTool copyTempUnzipVideoToMook:model.video modelTimeStamp:routineModel.timeStamp content:model.perform type:kTypeRoutine];
            
        }
    }
    
    for (CLPrepModel *model in routineModel.prepModelList) {
        if (model.image.length > 0) {
            
            model.image = [CLDataImportTool copyTempUnzipImageToMook:model.image modelTimeStamp:routineModel.timeStamp content:model.prep type:kTypeRoutine];
            
        } else if (model.video.length > 0) {
            
            model.video = [CLDataImportTool copyTempUnzipVideoToMook:model.video modelTimeStamp:routineModel.timeStamp content:model.prep type:kTypeRoutine];
            
        }
    }
    
}

+ (void)prepareDataWithIdea:(CLIdeaObjModel *)ideaObjModel {
    
    ideaObjModel.date = [NSDate date];
    ideaObjModel.timeStamp = kTimestamp;
    
    // 重设标签
    NSString *tag = NSLocalizedString(@"导入", nil);
    
    if ([ideaObjModel.infoModel.name containsString:[NSString stringWithFormat:@"(%@)", tag]] == NO) {
        ideaObjModel.infoModel.name = [NSString stringWithFormat:@"%@(%@)", ideaObjModel.infoModel.name, tag];
    }
    
    ideaObjModel.tags = [NSMutableArray arrayWithObject:tag];
    [CLDataSaveTool addTag:tag type:kTypeIdea];
    
    if (ideaObjModel.effectModel.image.length > 0) {
        
        ideaObjModel.effectModel.image = [CLDataImportTool copyTempUnzipImageToMook:ideaObjModel.effectModel.image modelTimeStamp:ideaObjModel.timeStamp content:ideaObjModel.effectModel.effect type:kTypeIdea];
        
    } else if (ideaObjModel.effectModel.video.length > 0) {
        
        ideaObjModel.effectModel.video = [CLDataImportTool copyTempUnzipVideoToMook:ideaObjModel.effectModel.video modelTimeStamp:ideaObjModel.timeStamp content:ideaObjModel.effectModel.effect type:kTypeIdea];
        
    }
    
    for (CLPrepModel *model in ideaObjModel.prepModelList) {
        if (model.image.length > 0) {
            
            model.image = [CLDataImportTool copyTempUnzipImageToMook:model.image modelTimeStamp:ideaObjModel.timeStamp content:model.prep type:kTypeIdea];
            
        } else if (model.video.length > 0) {
            
            model.video = [CLDataImportTool copyTempUnzipVideoToMook:model.video modelTimeStamp:ideaObjModel.timeStamp content:model.prep type:kTypeIdea];
            
        }
    }
}

+ (void)prepareDataWithSleight:(CLSleightObjModel *)sleightObjModel {
    
    sleightObjModel.date = [NSDate date];
    sleightObjModel.timeStamp = kTimestamp;
    
    // 重设标签
    NSString *tag = NSLocalizedString(@"导入", nil);
    
    if ([sleightObjModel.infoModel.name containsString:[NSString stringWithFormat:@"(%@)", tag]] == NO) {
        sleightObjModel.infoModel.name = [NSString stringWithFormat:@"%@(%@)", sleightObjModel.infoModel.name, tag];
    }
    
    sleightObjModel.tags = [NSMutableArray arrayWithObject:tag];
    [CLDataSaveTool addTag:tag type:kTypeSleight];
    
    if (sleightObjModel.effectModel.image.length > 0) {
        
        sleightObjModel.effectModel.image = [CLDataImportTool copyTempUnzipImageToMook:sleightObjModel.effectModel.image modelTimeStamp:sleightObjModel.timeStamp content:sleightObjModel.effectModel.effect type:kTypeSleight];
        
    } else if (sleightObjModel.effectModel.video.length > 0) {
        
        sleightObjModel.effectModel.video = [CLDataImportTool copyTempUnzipVideoToMook:sleightObjModel.effectModel.video modelTimeStamp:sleightObjModel.timeStamp content:sleightObjModel.effectModel.effect type:kTypeSleight];
        
    }
    
    for (CLPrepModel *model in sleightObjModel.prepModelList) {
        if (model.image.length > 0) {
            
            model.image = [CLDataImportTool copyTempUnzipImageToMook:model.image modelTimeStamp:sleightObjModel.timeStamp content:model.prep type:kTypeSleight];
            
        } else if (model.video.length > 0) {
            
            model.video = [CLDataImportTool copyTempUnzipVideoToMook:model.video modelTimeStamp:sleightObjModel.timeStamp content:model.prep type:kTypeSleight];
            
        }
    }
}

+ (void)prepareDataWithProp:(CLPropObjModel *)propObjModel {
    
    propObjModel.date = [NSDate date];
    propObjModel.timeStamp = kTimestamp;
    
    // 重设标签
    NSString *tag = NSLocalizedString(@"导入", nil);
    
    if ([propObjModel.infoModel.name containsString:[NSString stringWithFormat:@"(%@)", tag]] == NO) {
        propObjModel.infoModel.name = [NSString stringWithFormat:@"%@(%@)", propObjModel.infoModel.name, tag];
    }
    
    propObjModel.tags = [NSMutableArray arrayWithObject:tag];
    [CLDataSaveTool addTag:tag type:kTypeProp];
    
    if (propObjModel.effectModel.image.length > 0) {
        
        propObjModel.effectModel.image = [CLDataImportTool copyTempUnzipImageToMook:propObjModel.effectModel.image modelTimeStamp:propObjModel.timeStamp content:propObjModel.effectModel.effect type:kTypeProp];
        
    } else if (propObjModel.effectModel.video.length > 0) {
        
        propObjModel.effectModel.video = [CLDataImportTool copyTempUnzipVideoToMook:propObjModel.effectModel.video modelTimeStamp:propObjModel.timeStamp content:propObjModel.effectModel.effect type:kTypeProp];
        
    }
    
    for (CLPrepModel *model in propObjModel.prepModelList) {
        if (model.image.length > 0) {
            
            model.image = [CLDataImportTool copyTempUnzipImageToMook:model.image modelTimeStamp:propObjModel.timeStamp content:model.prep type:kTypeProp];
            
        } else if (model.video.length > 0) {
            
            model.video = [CLDataImportTool copyTempUnzipVideoToMook:model.video modelTimeStamp:propObjModel.timeStamp content:model.prep type:kTypeProp];
            
        }
    }
}

+ (void)prepareDataWithLines:(CLLinesObjModel *)linesObjModel {
 
    linesObjModel.date = [NSDate date];
    linesObjModel.timeStamp = kTimestamp;
    
    // 重设标签
    NSString *tag = NSLocalizedString(@"导入", nil);
    if ([linesObjModel.infoModel.name containsString:[NSString stringWithFormat:@"(%@)", tag]] == NO) {
        linesObjModel.infoModel.name = [NSString stringWithFormat:@"%@(%@)", linesObjModel.infoModel.name, tag];
    }


    linesObjModel.tags = [NSMutableArray arrayWithObject:tag];
    [CLDataSaveTool addTag:tag type:kTypeLines];
}


+ (NSString *)copyTempUnzipImageToMook:(NSString *)imageName modelTimeStamp:(NSString *)timeStamp content:(NSString *)content type:(NSString *)type {
    
    if (imageName.length > 0) {
        NSString *mediaPath = [[NSString tempUnzipPath] stringByAppendingPathComponent:imageName];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:mediaPath];
        
        if (fileExists) {
            NSError *error;
            NSString *newImageName = [kTimestamp stringByAppendingString:@".jpg"];
            NSString *destPath = [[NSString imagePath] stringByAppendingPathComponent:newImageName];
            BOOL flag = [[NSFileManager defaultManager] copyItemAtPath:mediaPath
                                                                toPath:destPath
                                                                 error:&error];
            if (flag) {
                
                [CLDataSaveTool addImageByName:newImageName timesStamp:timeStamp content:content type:type];
                return newImageName;
            }
        }
    }
    
    return nil;
}

+ (NSString *)copyTempUnzipVideoToMook:(NSString *)videoName modelTimeStamp:(NSString *)timeStamp content:(NSString *)content type:(NSString *)type {
    
    
    if (videoName.length > 0) {
        NSString *mediaPath = [[NSString tempUnzipPath] stringByAppendingPathComponent:videoName];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:mediaPath];
        
        if (fileExists) {
            NSError *error;
            NSString *newVideoName = [kTimestamp stringByAppendingString:@".mp4"];
            
            NSString *destPath = [[NSString videoPath] stringByAppendingPathComponent:newVideoName];
            BOOL flag = [[NSFileManager defaultManager] copyItemAtPath:mediaPath
                                                                toPath:destPath
                                                                 error:&error];
            if (flag) {
                [CLDataSaveTool addVideoByName:newVideoName timesStamp:timeStamp content:content type:type];
                return newVideoName;
            }
        }
    }
    
    return nil;
}


@end
