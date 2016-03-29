//
//  CLPropModel.h
//  Mook
//
//  Created by 陈林 on 15/11/17.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLPropModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *prop;

@property (nonatomic, assign) NSString *quantity;

@property (nonatomic, copy) NSString *propDetail;
// 是否有道具信息
@property (nonatomic, assign) BOOL isWithProp;
@property (nonatomic, assign) BOOL isWithQuantity;
@property (nonatomic, assign) BOOL isWithDetail;
+ (instancetype) propModel;

@end
