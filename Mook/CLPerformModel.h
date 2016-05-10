//
//  CLPerformModel.h
//  Mook
//
//  Created by 陈林 on 15/11/16.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLPerformModel : NSObject<NSCoding>

// 表演信息
@property (nonatomic, copy) NSString *perform;
// 配图
@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *video;

// 添加配图状态
@property (nonatomic, assign) BOOL isWithImage;

@property (nonatomic, assign) BOOL isWithVideo;
// 是否有表演信息
@property (nonatomic, assign) BOOL isWithPerform;


// 类方法-直接获取模型实例
+ (instancetype) performModel;

- (void)deleteMedia;
- (NSNumber *)mediaSize;

@end
