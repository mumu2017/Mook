//
//  CLListvc.h
//  Mook
//
//  Created by 陈林 on 16/3/25.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLListVC : UITableViewController

@property (nonatomic, assign) ListType listType;
@property (nonatomic, copy) NSString *tag;

@property (nonatomic, strong) NSMutableArray *ideaObjModelList;
@property (nonatomic, strong) NSMutableArray *showModelList;
@property (nonatomic, strong) NSMutableArray *routineModelList;
@property (nonatomic, strong) NSMutableArray *sleightObjModelList;
@property (nonatomic, strong) NSMutableArray *propObjModelList;
@property (nonatomic, strong) NSMutableArray *linesObjModelList;

@end
