//
//  CLQuickInputVC.h
//  Mook
//
//  Created by 陈林 on 16/1/2.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLQuickStringVC;

@protocol CLQuickStringVCDelegate <NSObject>

@optional
- (void)quickStringVC:(CLQuickStringVC *)quickStringVC didSelectQuickString:(NSString *)quickString;

@end


@interface CLQuickStringVC : UITableViewController

@property (nonatomic, assign) BOOL isPicking;
@property (nonatomic, weak) id<CLQuickStringVCDelegate> delegate;

@end
