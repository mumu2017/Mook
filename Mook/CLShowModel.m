//
//  CLShowModel.m
//  Mook
//
//  Created by 陈林 on 15/12/18.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLShowModel.h"
#import "CLRoutineModel.h"
#import "CLEffectModel.h"

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

- (NSDate *)date {
    
    if (_date == nil) {
        _date = [NSDate date]; // get today date
    }
    
    return _date;
}

- (NSMutableArray<NSString *> *)tags {
    if (!_tags) {
        _tags = [NSMutableArray array];
        
    }
    return _tags;
}


- (CLEffectModel *)effectModel {
    if (!_effectModel) {
        _effectModel = [CLEffectModel effectModel];
    }
    return _effectModel;
}

- (NSMutableArray *)routineTimeStampList {
    if (!_routineTimeStampList) {
        _routineTimeStampList = [NSMutableArray array];
    }
    return _routineTimeStampList;
}

// 根据timeStamp来获取routineModel;
- (NSMutableArray *)getRountineModelList {
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *timeStamp in self.routineTimeStampList) {
        for (CLRoutineModel *model in kDataListRoutine) {
            if ([model.timeStamp isEqualToString:timeStamp]) {
                [arrM addObject:model];
                break;
            }
        }
    }
    return arrM;
}

- (NSString *)getTitle {
    if (self.name.length > 0) {
        return self.name;
    } else {
        return kDefaultTitleShow;
    }
}

- (UIImage *)getImage {
    UIImage *image;
    NSArray *array = [self getRountineModelList];
    for (CLRoutineModel *model in array) {
        image = [model getImage];
    }
    return image;
}

- (UIImage *)getThumbnail {
    UIImage *image;
    NSArray *array = [self getRountineModelList];
    for (CLRoutineModel *model in array) {
        image = [model getThumbnail];
    }
    return image;
}

- (NSAttributedString *)getContent {
    
    NSString *effect;
    
    if (self.effectModel.isWithEffect) {
        effect = [NSString stringWithFormat:@"  %@", self.effectModel.effect];
        
    } else {
        effect = @"";
    }
    
    return [effect contentStringWithDate:[NSString getDateString:self.date]];
}

- (NSString *)duration {
    if (_duration == nil) {
        _duration = NSLocalizedString(@"无时长信息", nil);
    }
    return _duration;
}

- (NSString *)place {
    if (_place == nil) {
        _place = NSLocalizedString(@"无场地信息", nil);
    }
    return _place;
}

- (NSString *)audianceCount {
    if (_audianceCount == nil) {
        _audianceCount = NSLocalizedString(@"无观众信息", nil);
    }
    return _audianceCount;
}

@end
