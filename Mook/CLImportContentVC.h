//
//  CLImportContentVC.h
//  Mook
//
//  Created by 陈林 on 16/4/11.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLRoutineModel,CLShowModel,CLIdeaObjModel,CLSleightObjModel,CLPropObjModel,CLLinesObjModel;

@interface CLImportContentVC : UITableViewController

@property (nonatomic, assign) ContentType contentType;

@property (nonatomic, strong) CLIdeaObjModel *ideaObjModel;
@property (nonatomic, strong) CLRoutineModel *routineModel;
@property (nonatomic, strong) CLSleightObjModel *sleightObjModel;
@property (nonatomic, strong) CLPropObjModel *propObjModel;
@property (nonatomic, strong) CLLinesObjModel *linesObjModel;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *importPassword;

@end
