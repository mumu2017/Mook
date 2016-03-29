//
//  CLInfoModel.h
//  Mook
//
//  Created by 陈林 on 15/11/17.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLInfoModel : NSObject<NSCoding>

// name
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL isWithName;

// 类方法-直接获取模型实例
+ (instancetype) infoModel;

@end
