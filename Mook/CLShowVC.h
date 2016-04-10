//
//  CLShowVC.h
//  Mook
//
//  Created by 陈林 on 15/12/19.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLShowModel, CLShowVC;

@interface CLShowVC : UITableViewController

@property (nonatomic, strong) CLShowModel *showModel;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSIndexPath *dataPath;

@end
