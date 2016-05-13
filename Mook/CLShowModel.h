//
//  CLShowModel.h
//  Mook
//
//  Created by 陈林 on 15/12/18.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLRoutineModel, CLEffectModel;

@interface CLShowModel : NSObject

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *timeStamp;

@property (nonatomic, strong) NSMutableArray <NSString*> *tags;

@property (nonatomic, assign) BOOL isStarred;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *audianceCount;
@property (nonatomic, strong) CLEffectModel *effectModel;

@property (nonatomic, strong) NSMutableArray *routineTimeStampList;

+ (instancetype)showModel;

- (NSMutableArray *)getRountineModelList;
- (UIImage *)getImage;
- (UIImage *)getThumbnail;

- (NSString *)getTitle;
- (NSAttributedString *)getContent;
- (NSAttributedString *)getContentWithType;

- (NSString *)getEffectText;
- (NSString *)getDurationText;
- (NSString *)getPlaceText;
- (NSString *)getAudianceCountText;

@end
