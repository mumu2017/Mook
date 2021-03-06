//
//  CLSleightObjModel.m
//  Mook
//
//  Created by 陈林 on 15/11/21.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLSleightObjModel.h"
#import "CLInfoModel.h"
#import "CLEffectModel.h"
#import "CLPrepModel.h"
#import "UIImage+WaterMark.h"

@implementation CLSleightObjModel


+ (instancetype)sleightObjModel {
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
    return kTypeSleight;
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

- (NSMutableArray *)prepModelList {
    if (!_prepModelList) {
        _prepModelList = [NSMutableArray array];
        CLPrepModel *model = [CLPrepModel prepModel];
        [_prepModelList addObject:model];
    }
    
    return _prepModelList;
}

- (UIImage *)getImage {
    UIImage *image;
    // 先从effeceModel中找图片或视频首帧
    if (self.effectModel.isWithImage) {
        
        image = [self.effectModel.image getNamedImage];
        
    } else if (self.effectModel.isWithVideo) {
        
        image = [self.effectModel.video getNamedVideoFrame];
        
    }
    
    // 如果效果中没有, 则从prepModel中从效果中找图片或视频首帧
    if (image == nil) {
        for (CLPrepModel *model in self.prepModelList) {
            if (model.isWithImage) {
                image = [model.image getNamedImage];
                break;
            }
        }
    }
    
    if (image == nil) {
        for (CLPrepModel *model in self.prepModelList) {
            if (model.isWithVideo) {
                image = [model.video getNamedVideoFrame];
                break;
            }
        }
        
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
    
    // 如果效果中没有, 则从prepModel中从效果中找图片或视频首帧
    if (image == nil) {
        for (CLPrepModel *model in self.prepModelList) {
            if (model.isWithImage) {
                image = [model.image getNamedImageThumbnail];
                break;
            }
        }
    }
    
    if (image == nil) {
        for (CLPrepModel *model in self.prepModelList) {
            if (model.isWithVideo) {
                image = [model.video getNamedVideoThumbnail];
                break;
            }
        }
        
    }
    
    return image;
}

- (NSString *)getTitle {
    if (self.infoModel.isWithName) {
        return self.infoModel.name;
    } else {
        return kDefaultTitleSleight;
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
    
    NSString *modelString = [NSString stringWithFormat:@"%@ / ", NSLocalizedString(@"技巧", nil)];
    NSString *infoString = [modelString stringByAppendingString:[NSString getDateString:self.date]];
    return [effect contentStringWithDate:infoString];
}

- (NSInteger)picCnt {
    _vidCnt = 0;
    if (self.effectModel.isWithImage) {
        _vidCnt ++;
    }
    
    for (CLPrepModel *prepModel in self.prepModelList) {
        if (prepModel.isWithImage) {
            _vidCnt ++;
            
        }
    }
    
    return _vidCnt;
}

- (NSInteger)vidCnt {
    _vidCnt = 0;
    if (self.effectModel.isWithVideo) {
        _vidCnt ++;
    }
    
    for (CLPrepModel *prepModel in self.prepModelList) {
        if (prepModel.isWithVideo) {
            _vidCnt ++;
            
        }
    }
    
    return _vidCnt;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"tags" : [NSString class],
             @"prepModelList" : [CLPrepModel class],
             
             };
}

@end
