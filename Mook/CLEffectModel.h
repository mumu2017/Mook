//
//  CLEffectModel.h
//  Mook
//
//  Created by 陈林 on 15/11/17.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLEffectModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *effect;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *video;

@property (nonatomic, copy) NSString *audio;

// 是否有效果信息
@property (nonatomic, assign) BOOL isWithEffect;

@property (nonatomic, assign) BOOL isWithVideo;

@property (nonatomic, assign) BOOL isWithImage;

@property (nonatomic, assign) BOOL isWithAudio;

+ (instancetype) effectModel;

- (void)deleteMedia;
- (NSNumber *)mediaSize;

@end
