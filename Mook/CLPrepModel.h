//
//  CLPrepModel.h
//  Mook
//
//  Created by 陈林 on 15/11/17.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLPrepModel : NSObject<NSCoding>

// 表演信息
@property (nonatomic, copy) NSString *prep;
// image的保存路径
@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *video;

@property (nonatomic, copy) NSString *audio;

// 添加配图状态
@property (nonatomic, assign) BOOL isWithImage;

@property (nonatomic, assign) BOOL isWithVideo;
// 是否有表演信息
@property (nonatomic, assign) BOOL isWithPrep;

@property (nonatomic, assign) BOOL isWithAudio;

// 类方法-直接获取模型实例
+ (instancetype) prepModel;

- (void)deleteMedia;
- (NSNumber *)mediaSize;

@end
