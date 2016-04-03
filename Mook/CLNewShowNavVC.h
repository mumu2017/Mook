//
//  CLNewShowNavVc.h
//  Mook
//
//  Created by 陈林 on 16/3/31.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLNewShowVC.h"
@class CLShowModel;

@interface CLNewShowNavVC : UINavigationController

@property (nonatomic, strong) CLShowModel *showModel;

@end
