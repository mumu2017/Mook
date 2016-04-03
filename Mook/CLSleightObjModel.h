//
//  CLSleightObjModel.h
//  Mook
//
//  Created by 陈林 on 15/11/21.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLInfoModel, CLEffectModel, CLPrepModel;

// 手法的数据分为两部分:
// 1. 手法的名字
// 2. 手法描述信息:文字
// 3. 手法具体操作信息:文字和图片


@interface CLSleightObjModel : NSObject
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

+ (instancetype)sleightObjModel;

- (NSString *)getTitle;
- (NSAttributedString *)getContent;
- (UIImage *)getImage;
- (UIImage *)getThumbnail;

@end
