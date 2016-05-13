//
//  CLLinesObjModel.h
//  Mook
//
//  Created by 陈林 on 15/11/21.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLInfoModel, CLEffectModel;

// 台词的数据分为两部分:
// 1. 台词的标题
// 2. 台词的种类
// 3. 台词具体信息:文字

@interface CLLinesObjModel : NSObject
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *timeStamp;

@property (nonatomic, strong) NSMutableArray <NSString*> *tags;
@property (nonatomic, assign) BOOL isStarred;

@property (nonatomic, strong) CLInfoModel *infoModel;
@property (nonatomic, strong) CLEffectModel *effectModel;

+ (instancetype)linesObjModel;

- (NSString *)getTitle;
- (NSAttributedString *)getContent;
- (NSAttributedString *)getContentWithType;

@end
