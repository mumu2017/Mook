//
//  CLNewShowVC.h
//  Mook
//
//  Created by 陈林 on 15/12/19.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLShowModel, CLNewShowVC;


@interface CLNewShowVC : UITableViewController

@property (nonatomic, strong) CLShowModel *showModel;
@property (nonatomic, strong) NSIndexPath *dataPath;

@end
