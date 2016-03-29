//
//  CLNewEntryNavVC.h
//  Mook
//
//  Created by 陈林 on 16/3/23.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLNewEntryVC.h"
@interface CLNewEntryNavVC : UINavigationController

@property (nonatomic, assign) EditingContentType editingContentType;

@property (nonatomic, strong) CLRoutineModel *routineModel;
@property (nonatomic, strong) CLIdeaObjModel *ideaObjModel;
@property (nonatomic, strong) CLSleightObjModel *sleightObjModel;
@property (nonatomic, strong) CLPropObjModel *propObjModel;
@property (nonatomic, strong) CLLinesObjModel *linesObjModel;

@end
