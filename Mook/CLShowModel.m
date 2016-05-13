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
#import "FCFileManager.h"

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
    
    if (_date == nil)  _date = [NSDate date];
    
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
    
    // 先从effeceModel中找图片或视频首帧
    if (self.effectModel.isWithImage) {
        
        image = [self.effectModel.image getNamedImageThumbnail];
        
    } else if (self.effectModel.isWithVideo) {
        
        image = [self.effectModel.video getNamedVideoThumbnail];
        
    }
    
    if (image == nil) {
        NSArray *array = [self getRountineModelList];
        for (CLRoutineModel *model in array) {
            image = [model getThumbnail];
            if (image) {
                break;
            }
        }
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
    
    NSString *infoString = [NSString getDateString:self.date];
    return [effect contentStringWithDate:infoString];
}

- (NSAttributedString *)getContentWithType {
    
    NSString *effect;
    
    if (self.effectModel.isWithEffect) {
        effect = [NSString stringWithFormat:@"  %@", self.effectModel.effect];
        
    } else {
        effect = @"";
    }
    
    NSString *modelString = [NSString stringWithFormat:@"%@  ", NSLocalizedString(@"演出", nil)];
    NSString *infoString = [modelString stringByAppendingString:[NSString getDateString:self.date]];
    return [effect contentStringWithDate:infoString];
}

- (NSString *)getDurationText {
    if (_duration.length == 0) {
        return NSLocalizedString(@"无时长信息", nil);
    }
    return _duration;
}

- (NSString *)getPlaceText {
    if (_place.length == 0) {
        return NSLocalizedString(@"无场地信息", nil);
    }
    return _place;
}

- (NSString *)getAudianceCountText {
    if (_audianceCount.length == 0) {
        return NSLocalizedString(@"无观众信息", nil);
    }
    return _audianceCount;
}

- (NSString *)getEffectText {
    
    NSString *effect;
    
    if (self.effectModel.isWithEffect) {
        effect = self.effectModel.effect;
        
    } else {
        effect = NSLocalizedString(@"无演出说明", nil);
    }
    
    return effect;
}

@end
