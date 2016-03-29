//
//  CLRoutineModel.m
//  Mook
//
//  Created by 陈林 on 15/11/17.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLRoutineModel.h"
#import "CLInfoModel.h"
#import "CLEffectModel.h"
#import "CLPropModel.h"
#import "CLPrepModel.h"
#import "CLPerformModel.h"
#import "CLNotesModel.h"
#import "SMTag.h"

@implementation CLRoutineModel


+ (instancetype)routineModel {
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

- (NSString *)type {
    return kTypeRoutine;
}

- (NSDate *)date {
    
    if (_date == nil) {
        _date = [NSDate date];  // get today date
    }

    return _date;
}

- (NSMutableArray<NSString *> *)tags {
    if (!_tags) {
        _tags = [NSMutableArray array];

    }
    return _tags;
}

- (CLInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [CLInfoModel infoModel];
    }
    
    return _infoModel;
}

- (CLEffectModel *)effectModel {
    if (!_effectModel) {
        _effectModel = [CLEffectModel effectModel];
    }
    return _effectModel;
}

- (NSMutableArray *)propModelList {
    if (!_propModelList) {
        _propModelList = [NSMutableArray array];
        CLPropModel *model = [CLPropModel propModel];
        [_propModelList addObject:model];
    }
    return _propModelList;
}

- (NSMutableArray *)prepModelList {
    if (!_prepModelList) {
        _prepModelList = [NSMutableArray array];
        CLPrepModel *model = [CLPrepModel prepModel];
        [_prepModelList addObject:model];
    }
    return _prepModelList;
}

- (NSMutableArray *)performModelList {
    if (!_performModelList) {
        _performModelList = [NSMutableArray array];
        CLPerformModel *model = [CLPerformModel performModel];
        [_performModelList addObject:model];
    }
    return _performModelList;
}

- (NSMutableArray *)notesModelLsit {
    if (!_notesModelLsit) {
        _notesModelLsit = [NSMutableArray array];
        CLNotesModel *model = [CLNotesModel notesModel];
        [_notesModelLsit addObject:model];
    }
    return _notesModelLsit;
}

- (NSString *)getTitle {
    if (self.infoModel.isWithName) {
        return self.infoModel.name;
    } else {
        return kDefaultTitleRoutine;
    }
    
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

- (UIImage *)getImage {
    UIImage *image = nil;
    NSString *name = nil;

    // 先从效果中找图片或视频首帧
    if (self.effectModel.isWithImage) {
        name = self.effectModel.image;
        image = [name getNamedImage];
    } else if (self.effectModel.isWithVideo) {
        name = self.effectModel.video;
        image = [name getFirstFrameOfNamedVideo];
        
    }
    
    // 如果效果中没有, 则从表演中从效果中找图片或视频首帧
    if (image == nil) {
        for (CLPerformModel *performModel in self.performModelList) {
            if (performModel.isWithImage) {
                name = performModel.image;
                image = [name getNamedImage];
                break;
            }
        }
    }
    
    if (image == nil) {
        for (CLPerformModel *performModel in self.performModelList) {
            if (performModel.isWithVideo) {
                name = performModel.video;
                image = [name getFirstFrameOfNamedVideo];
                break;
            }
        }

    }
    
    // 如果效果中没有, 则从准备中从效果中找图片或视频首帧
    if (image == nil) {
        for (CLPrepModel *prepModel in self.prepModelList) {
            if (prepModel.isWithImage) {
                name = prepModel.image;
                image = [name getNamedImage];
                break;
            }
        }
    }
    
    if (image == nil) {
        for (CLPrepModel *prepModel in self.prepModelList) {
            if (prepModel.isWithVideo) {
                name = prepModel.video;
                image = [name getFirstFrameOfNamedVideo];
                break;
            }
        }
        
    }

    return image;
}

@end
