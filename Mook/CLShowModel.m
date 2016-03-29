//
//  CLShowModel.m
//  Mook
//
//  Created by 陈林 on 15/12/18.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLShowModel.h"
#import "CLRoutineModel.h"

@implementation CLShowModel

+ (instancetype)showModel {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self timeStamp];
    }
    
    return self;
}

- (NSString *)timeStamp {
    if (_timeStamp == nil) {
        _timeStamp = kTimestamp;
    }
    
    return _timeStamp;
}

- (NSString *)date {
    
    if (_date == nil) {
        NSDate *todayDate = [NSDate date]; // get today date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
        [dateFormatter setDateFormat:@"yyyy-MM-dd"]; //Here we can set the format which we need
        _date = [dateFormatter stringFromDate:todayDate];// here convert date in
    }
    
    return _date;
}

- (NSMutableArray<NSString *> *)tags {
    if (!_tags) {
        _tags = [NSMutableArray array];
        
    }
    return _tags;
}

- (NSMutableArray<CLRoutineModel *> *)openerShow {
    if (!_openerShow) {
        _openerShow = [NSMutableArray array];
    }
    return _openerShow;
}

- (NSMutableArray<CLRoutineModel *> *)middleShow {
    if (!_middleShow) {
        _middleShow = [NSMutableArray array];
    }
    return _middleShow;
}

- (NSMutableArray<CLRoutineModel *> *)endingShow {
    if (!_endingShow) {
        _endingShow = [NSMutableArray array];
    }
    return _endingShow;
}

- (NSString *)getImage {
    NSString *imageName = nil;
    
    for (CLRoutineModel *model in self.openerShow) {
        imageName = [model getImage];
        if (imageName) break;
    }
    
    if (imageName == nil) {
        for (CLRoutineModel *model in self.middleShow) {
            imageName = [model getImage];
            if (imageName) break;
        }
    }
    
    if (imageName == nil) {
        for (CLRoutineModel *model in self.endingShow) {
            imageName = [model getImage];
            if (imageName) break;
        }
    }

    return imageName;
}

- (NSInteger)picCnt {
    _picCnt = 0;
    
    for (CLRoutineModel *model in self.openerShow) {
        _picCnt += model.picCnt;
    }
    

    for (CLRoutineModel *model in self.middleShow) {
        _picCnt += model.picCnt;

    }

    for (CLRoutineModel *model in self.endingShow) {
        _picCnt += model.picCnt;

    }
    
    return _picCnt;
}

- (NSInteger)vidCnt {
    _vidCnt = 0;
    
    for (CLRoutineModel *model in self.openerShow) {
        _vidCnt += model.vidCnt;
    }
    
    
    for (CLRoutineModel *model in self.middleShow) {
        _vidCnt += model.vidCnt;
        
    }
    
    for (CLRoutineModel *model in self.endingShow) {
        _vidCnt += model.vidCnt;
        
    }
    
    return _vidCnt;
}

//- (void)encodeWithCoder:(NSCoder *)coder
//{
//    [coder encodeObject:self.date forKey:kDateKey];
//    [coder encodeObject:self.tags forKey:kTagListKey];
//    [coder encodeObject:self.name forKey:kShowNameKey];
//    [coder encodeObject:self.time forKey:kShowDurationKey];
//
//    [coder encodeObject:self.openerShow forKey:kShowOpenerKey];
//    [coder encodeObject:self.middleShow forKey:kShowMiddleKey];
//    [coder encodeObject:self.endingShow forKey:kShowEndingKey];
//    
//}
//
//- (instancetype)initWithCoder:(NSCoder *)coder
//{
//    self = [super init];
//    if (self) {
//        self.date = [coder decodeObjectForKey:kDateKey];
//        self.tags = [coder decodeObjectForKey:kTagListKey];
//        self.name = [coder decodeObjectForKey:kShowNameKey];
//        self.time = [coder decodeObjectForKey:kShowDurationKey];
//        
//        self.openerShow = [coder decodeObjectForKey:kShowOpenerKey];
//        self.middleShow = [coder decodeObjectForKey:kShowMiddleKey];
//        self.endingShow = [coder decodeObjectForKey:kShowEndingKey];
//
//    }
//    return self;
//}

@end
