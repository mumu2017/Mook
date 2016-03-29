//
//  CLShowListVC.h
//  Mook
//
//  Created by 陈林 on 15/12/19.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLShowListVC;

@protocol CLShowListVCDelegate <NSObject>

@optional
- (void)showListVCDidEdit:(CLShowListVC *)showListVC;

@end

@interface CLShowListVC : UITableViewController

@property (nonatomic, strong) NSMutableArray *showModelList;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, weak) id<CLShowListVCDelegate> delegate;

- (void) addNewShow;

@end
