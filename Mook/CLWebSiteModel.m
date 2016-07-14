//
//  CLWebSiteModel.m
//  Mook
//
//  Created by 陈林 on 16/6/15.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLWebSiteModel.h"

@implementation CLWebSiteModel

+ (CLWebSiteModel *)modelWithTitle:(NSString *)title withUrlString:(NSString *)urlString {
    
    CLWebSiteModel *model = [[CLWebSiteModel alloc] init];
    model.title = title;
    model.url = [NSURL URLWithString:urlString];
    
    return model;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self timeStamp];
    }
    
    return self;
}

- (NSString *)timeStamp {
    if (_timeStamp == nil) {
        _timeStamp = kTimestamp;
    }
    
    return _timeStamp;
}

@end
