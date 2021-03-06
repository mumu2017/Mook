//
//  CLInfoModel.m
//  Mook
//
//  Created by 陈林 on 15/11/17.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLInfoModel.h"


@implementation CLInfoModel

+ (instancetype) infoModel {
    return [[self alloc] init];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:kInfoNameKey];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectForKey:kInfoNameKey];
    }
    return self;
}

- (BOOL)isWithName {
    return self.name.length > 0;
}

@end
