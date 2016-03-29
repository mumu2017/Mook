//
//  CLShowModel.h
//  Mook
//
//  Created by 陈林 on 15/12/18.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLRoutineModel;

@interface CLShowModel : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *timeStamp;

@property (nonatomic, strong) NSMutableArray <NSString*> *tags;
@property (nonatomic, assign) BOOL isStarred;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSString *time;

@property (nonatomic, strong) NSMutableArray <CLRoutineModel*> *openerShow;
@property (nonatomic, strong) NSMutableArray <CLRoutineModel*> *middleShow;
@property (nonatomic, strong) NSMutableArray <CLRoutineModel*> *endingShow;

@property (nonatomic, assign) NSInteger vidCnt;
@property (nonatomic, assign) NSInteger picCnt;

+ (instancetype)showModel;
- (NSString *)getImage;


@end
