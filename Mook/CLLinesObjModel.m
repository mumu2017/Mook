//
//  CLLinesObjModel.m
//  Mook
//
//  Created by 陈林 on 15/11/21.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLLinesObjModel.h"
#import "CLInfoModel.h"
#import "CLEffectModel.h"

@implementation CLLinesObjModel


+ (instancetype)linesObjModel {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self timeStamp];
    }
    
    return self;
}

- (NSString *)type {
    return kTypeLines;
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


- (NSString *)getTitle {
    if (self.infoModel.isWithName) {
        return self.infoModel.name;
    } else {
        return kDefaultTitleLines;
    }
    
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
    
    NSString *modelString = [NSString stringWithFormat:@"%@  ", NSLocalizedString(@"台词", nil)];
    NSString *infoString = [modelString stringByAppendingString:[NSString getDateString:self.date]];    return [effect contentStringWithDate:infoString];
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


@end
