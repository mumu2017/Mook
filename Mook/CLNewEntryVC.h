//
//  CLNewRoutineVC.h
//  Mook
//
//  Created by 陈林 on 15/12/7.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLNewEntryVC;
@class CLRoutineModel, CLIdeaObjModel, CLSleightObjModel, CLPropObjModel, CLLinesObjModel;

@interface CLNewEntryVC : UITableViewController

@property (nonatomic, assign) EditingContentType editingContentType;
@property (nonatomic, strong) CLRoutineModel *routineModel;
@property (nonatomic, strong) CLIdeaObjModel *ideaObjModel;
@property (nonatomic, strong) CLSleightObjModel *sleightObjModel;
@property (nonatomic, strong) CLPropObjModel *propObjModel;
@property (nonatomic, strong) CLLinesObjModel *linesObjModel;

@end




