//
//  CLWebSiteModel.h
//  Mook
//
//  Created by 陈林 on 16/6/15.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLWebSiteModel : NSObject

// 网站名称
@property (strong, nonatomic) NSString *title;

// 网站地址
@property (strong, nonatomic) NSURL *url;

+ (CLWebSiteModel *)modelWithTitle:(NSString *)title withUrlString:(NSString *)urlString;

@end