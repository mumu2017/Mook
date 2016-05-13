//
//  CLPropObjModel.h
//  Mook
//
//  Created by 陈林 on 15/11/21.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLInfoModel, CLEffectModel, CLPrepModel;
// 道具的数据分为两部分:
// 1. 道具的名字
// 2. 道具描述信息:文字
// 3. 道具具体操作信息:文字和图片

@interface CLPropObjModel : NSObject
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *timeStamp;

@property (nonatomic, strong) NSMutableArray <NSString*> *tags;
@property (nonatomic, assign) BOOL isStarred;

@property (nonatomic, strong) CLInfoModel *infoModel;
@property (nonatomic, strong) CLEffectModel *effectModel;
@property (nonatomic, strong) NSMutableArray *prepModelList;

@property (nonatomic, assign) NSInteger vidCnt;
@property (nonatomic, assign) NSInteger picCnt;

+ (instancetype)propObjModel;

- (NSString *)getTitle;
- (NSAttributedString *)getContent;
- (NSAttributedString *)getContentWithType;

- (UIImage *)getImage;
- (UIImage *)getThumbnail;


@end
