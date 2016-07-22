//
//  CLDataSizeTool.m
//  Mook
//
//  Created by 陈林 on 16/4/14.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLDataSizeTool.h"
#import "FCFileManager.h"

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

@implementation CLDataSizeTool

+ (NSString *)totalSize { // 总的储存空间占用, 并不准确, 只计算了近似值.
    
    NSString *size;
    
    NSNumber *documentSize = [FCFileManager sizeOfDirectoryAtPath:[FCFileManager pathForDocumentsDirectory]];
    
    NSNumber *cacheSize = [FCFileManager sizeOfDirectoryAtPath:[FCFileManager pathForCachesDirectory]];
    NSNumber *tempSize = [FCFileManager sizeOfDirectoryAtPath:[FCFileManager pathForTemporaryDirectory]];
    NSNumber *webCacheSize = [FCFileManager sizeOfDirectoryAtPath:[self webCachePath]];
    NSLog(@"WEBCACHE: %@", webCacheSize);
    NSString *mookPath = [NSString mookPath];
    // 拼接文件名
    NSString *filePath = [mookPath stringByAppendingPathComponent:@"mook.sqlite"];
    NSNumber *dataBaseSize = [FCFileManager sizeOfFileAtPath:filePath];
    NSNumber *total = @([documentSize intValue] + [cacheSize intValue] + [dataBaseSize intValue] + [tempSize intValue] + [webCacheSize intValue]);
    
    for (CLShowModel *model in kDataListShow) {
        total = @([total intValue] + [[self sizeOfShow:model] intValue]);
    }
    for (CLRoutineModel *model in kDataListRoutine) {
        total = @([total intValue] + [[self sizeOfRoutine:model] intValue]);
    }
    for (CLIdeaObjModel *model in kDataListIdea) {
        total = @([total intValue] + [[self sizeOfIdea:model] intValue]);
    }
    for (CLSleightObjModel *model in kDataListSleight) {
        total = @([total intValue] + [[self sizeOfSleight:model] intValue]);
    }
    for (CLPropObjModel *model in kDataListProp) {
        total = @([total intValue] + [[self sizeOfProp:model] intValue]);
    }
    
    total = @([total intValue] + [[self textAverageSize] intValue] * [kDataListLines count]);
    
    size = [FCFileManager sizeFormatted:total];
    
    return size;
}

+ (NSString *)sizeOfMook {
    
   return [FCFileManager sizeFormattedOfDirectoryAtPath:[FCFileManager pathForLibraryDirectory]];
}

+ (NSString *)sizeOfCache {
    
    return [FCFileManager sizeFormattedOfDirectoryAtPath:[FCFileManager pathForCachesDirectory]];
}

+ (NSString *)sizeOfWebCache {
    
    return [FCFileManager sizeFormattedOfDirectoryAtPath:[self webCachePath]];

}

+ (NSString *)sizeOfTemp {
    
    return [FCFileManager sizeFormattedOfDirectoryAtPath:[FCFileManager pathForTemporaryDirectory]];
}

+ (NSString *)sizeOfCacheAndTemporaryData {
    NSString *size;
    NSNumber *cacheSize = [FCFileManager sizeOfDirectoryAtPath:[FCFileManager pathForCachesDirectory]];
    NSNumber *tempSize = [FCFileManager sizeOfDirectoryAtPath:[FCFileManager pathForTemporaryDirectory]];
    NSNumber *total = @([cacheSize intValue] + [tempSize intValue]);
    size = [FCFileManager sizeFormatted:total];
    return size;
}

+ (NSNumber *)textAverageSize {
    
    NSString *mookPath = [NSString mookPath];
    // 拼接文件名
    NSString *filePath = [mookPath stringByAppendingPathComponent:@"mook.sqlite"];
    NSNumber *dataBaseSize = [FCFileManager sizeOfFileAtPath:filePath];
    NSNumber *averageSize = @([dataBaseSize floatValue] / kDataListAll.count);
    
    return averageSize;
}

+ (NSNumber *)sizeOfIdea:(CLIdeaObjModel *)ideaObjModel {
    
    NSNumber *size = [ideaObjModel.effectModel mediaSize];
    
    for (CLPrepModel *model in ideaObjModel.prepModelList) {
        size = @([size intValue] + [[model mediaSize] intValue]);
    }
    
    size = @([size intValue] + [[self textAverageSize] intValue]);
    
    return size;
}

+ (NSNumber *)sizeOfShow:(CLShowModel *)showModel {
    NSNumber *size = [showModel.effectModel mediaSize];
    
    size = @([size intValue] + [[self textAverageSize] intValue]);
    
    return size;
}

+ (NSNumber *)sizeOfSleight:(CLSleightObjModel *)sleightObjModel {
    
    NSNumber *size = [sleightObjModel.effectModel mediaSize];
    
    for (CLPrepModel *model in sleightObjModel.prepModelList) {
        size = @([size intValue] + [[model mediaSize] intValue]);
    }
    
    size = @([size intValue] + [[self textAverageSize] intValue]);
    
    return size;
}

+ (NSNumber *)sizeOfProp:(CLPropObjModel *)propObjModel {
    
    NSNumber *size = [propObjModel.effectModel mediaSize];
    
    for (CLPrepModel *model in propObjModel.prepModelList) {
        size = @([size intValue] + [[model mediaSize] intValue]);
    }
    
    size = @([size intValue] + [[self textAverageSize] intValue]);
    
    return size;
}

+ (NSNumber *)sizeOfRoutine:(CLRoutineModel *)routineModel {
    
    NSNumber *size = [routineModel.effectModel mediaSize];
    

    for (CLPerformModel *model in routineModel.performModelList) {
        size = @([size intValue] + [[model mediaSize] intValue]);
        }
    

    for (CLPrepModel *model in routineModel.prepModelList) {
            size = @([size intValue] + [[model mediaSize] intValue]);
        }
    
    size = @([size intValue] + [[self textAverageSize] intValue]);
    
    return size;
}

+ (NSString *)sizeOfAllShows {
    
    NSNumber *size = @0;
    
    for (CLShowModel *model in kDataListShow) {
        size = @([size intValue] + [[self sizeOfShow:model] intValue]);
    }
    
    NSString *formatted = [FCFileManager sizeFormatted:size];
    
    return formatted;
}

+ (NSString *)sizeOfAllRoutines {
    
    NSNumber *size = @0;
    
    for (CLRoutineModel *model in kDataListRoutine) {
        size = @([size intValue] + [[self sizeOfRoutine:model] intValue]);
    }
    
    NSString *formatted = [FCFileManager sizeFormatted:size];
    
    return formatted;
}

+ (NSString *)sizeOfAllIdeas {
 
    NSNumber *size = @0;
    
    for (CLIdeaObjModel *model in kDataListIdea) {
        size = @([size intValue] + [[self sizeOfIdea:model] intValue]);
    }
    
    NSString *formatted = [FCFileManager sizeFormatted:size];
    
    return formatted;
}

+ (NSString *)sizeOfAllSleights {
    
    NSNumber *size = @0;
    
    for (CLSleightObjModel *model in kDataListSleight) {
        size = @([size intValue] + [[self sizeOfSleight:model] intValue]);
    }
    
    NSString *formatted = [FCFileManager sizeFormatted:size];
    
    return formatted;
}

+ (NSString *)sizeOfAllProps {
    
    NSNumber *size = @0;
    
    for (CLPropObjModel *model in kDataListProp) {
        size = @([size intValue] + [[self sizeOfProp:model] intValue]);
    }
    
    NSString *formatted = [FCFileManager sizeFormatted:size];
    
    return formatted;
}

+ (NSString *)sizeOfAllLines {
    
    NSNumber *size = @([[self textAverageSize] intValue] * [kDataListLines count]);

    NSString *formatted = [FCFileManager sizeFormatted:size];
    
    return formatted;
}


+ (NSString *)sizeOfBackUp {
    
    NSNumber *size = @0;
    size = [FCFileManager sizeOfFileAtPath:[NSString backUpPath]];
    return [FCFileManager sizeFormatted:size];
}

+ (NSNumber *)sizeOfLines:(CLLinesObjModel *)model {
    
    return nil;
}

+ (BOOL)cleanWebCache {
    
    NSString *path = [self webCachePath];
    
    BOOL flag = YES;

    if ([FCFileManager isDirectoryItemAtPath:path]) {
        
        flag = [self totalCleanInDirectoryItemAtPath:path];
    }
    
    return flag;
}

+ (BOOL)totalCleanInDirectoryItemAtPath:(NSString *)path {
    
    NSArray *subPaths = [FCFileManager listFilesInDirectoryAtPath:path deep:YES];
    
    BOOL flag = YES;
    
    for (NSString *subPath in subPaths) {
        
        if ([FCFileManager isDirectoryItemAtPath:subPath]) {
            
            flag = [self totalCleanInDirectoryItemAtPath:subPath];
            
        } else if ([FCFileManager isFileItemAtPath:subPath]) {
            
            flag = [FCFileManager removeItemAtPath:subPath];
            
        }
        
        if (flag == NO) {
            
            return NO;
        }
    }

    return flag;
    
}

+ (NSString *)webCachePath {
    NSError *error;
    NSString *path = [[FCFileManager pathForCachesDirectory] stringByAppendingPathComponent:@"WebKit"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    return path;
}

@end
