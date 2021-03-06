//
//  CLContentVC.h
//  Mook
//
//  Created by 陈林 on 16/3/25.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>

@class CLRoutineModel,CLShowModel,CLIdeaObjModel,CLSleightObjModel,CLPropObjModel,CLLinesObjModel;

@interface CLContentVC : UITableViewController<MWPhotoBrowserDelegate>

@property (nonatomic, assign) ContentType contentType;

@property (nonatomic, strong) CLIdeaObjModel *ideaObjModel;
@property (nonatomic, strong) CLShowModel *showModel;
@property (nonatomic, strong) CLRoutineModel *routineModel;
@property (nonatomic, strong) CLSleightObjModel *sleightObjModel;
@property (nonatomic, strong) CLPropObjModel *propObjModel;
@property (nonatomic, strong) CLLinesObjModel *linesObjModel;

@end
