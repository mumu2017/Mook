//
//  CLPropModel.m
//  Mook
//
//  Created by 陈林 on 15/11/17.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLPropModel.h"

@implementation CLPropModel

+ (instancetype) propModel {
    return [[self alloc] init];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.prop forKey:kPropKey];
    [coder encodeObject:self.quantity forKey:kPropQuantityKey];
    [coder encodeObject:self.propDetail forKey:kPropDetialKey];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.prop = [coder decodeObjectForKey:kPropKey];
        self.quantity = [coder decodeObjectForKey:kPropQuantityKey];
        self.propDetail = [coder decodeObjectForKey:kPropDetialKey];
        
    }
    return self;
}

- (BOOL)isWithProp {
    return self.prop.length > 0;
}

- (BOOL)isWithQuantity {
    return self.quantity.length > 0;
}

- (BOOL)isWithDetail {
    return self.propDetail.length > 0;
}

@end
