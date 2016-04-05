//
//  CLQuickStringNavVC.h
//  Mook
//
//  Created by 陈林 on 16/4/5.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLQuickStringNavVC;

@protocol CLQuickStringNavDelegate <NSObject>

@optional
- (void)quickStringNavVC:(CLQuickStringNavVC *)quickStringNavVC didSelectQuickString:(NSString *)quickString;

@end


@interface CLQuickStringNavVC : UINavigationController

@property (nonatomic, weak) id<CLQuickStringNavDelegate> navDelegate;


@end
