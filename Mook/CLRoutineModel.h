//
//  CLRoutineModel.h
//  Mook
//
//  Created by 陈林 on 15/11/17.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLInfoModel, CLEffectModel, CLPropModel, CLPrepModel, CLPerformModel, CLNotesModel, SMTag;

@interface CLRoutineModel : NSObject

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *timeStamp;

@property (nonatomic, copy) NSDate *date;

@property (nonatomic, strong) NSMutableArray <NSString*> *tags;
@property (nonatomic, assign) BOOL isStarred;

@property (nonatomic, strong) CLInfoModel *infoModel;
@property (nonatomic, strong) CLEffectModel *effectModel;
@property (nonatomic, strong) NSMutableArray <CLPropModel*> *propModelList;
@property (nonatomic, strong) NSMutableArray <CLPrepModel*> *prepModelList;
@property (nonatomic, strong) NSMutableArray <CLPerformModel*> *performModelList;
@property (nonatomic, strong) NSMutableArray <CLNotesModel*> *notesModelLsit;

@property (nonatomic, assign) NSInteger vidCnt;
@property (nonatomic, assign) NSInteger picCnt;

+ (instancetype)routineModel;

- (NSString *)getTitle;
- (NSAttributedString *)getContent;
- (NSAttributedString *)getContentWithType;

- (UIImage *)getImage;
- (UIImage *)getThumbnail;

@end
