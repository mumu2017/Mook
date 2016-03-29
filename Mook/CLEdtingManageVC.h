//
//  CLEdtingManageVC.h
//  Mook
//
//  Created by 陈林 on 16/1/3.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import "XLPagerTabStripViewController.h"
#import "CLNewEntryVC.h"

@class CLRoutineModel, CLIdeaObjModel, CLSleightObjModel, CLPropObjModel, CLLinesObjModel;
@class CLEffectModel, CLPropModel, CLPrepModel, CLPerformModel, CLNotesModel;

@interface CLEdtingManageVC : XLPagerTabStripViewController

@property (nonatomic, assign) EditingContentType editingContentType;

@property (nonatomic, strong) CLRoutineModel *routineModel;
@property (nonatomic, strong) CLIdeaObjModel *ideaObjModel;
@property (nonatomic, strong) CLSleightObjModel *sleightObjModel;
@property (nonatomic, strong) CLPropObjModel *propObjModel;
@property (nonatomic, strong) CLLinesObjModel *linesObjModel;

@property (nonatomic, strong) CLEffectModel *effectModel;
@property (nonatomic, strong) NSMutableArray <CLPropModel*> *propModelList;
@property (nonatomic, strong) NSMutableArray <CLPrepModel*> *prepModelList;
@property (nonatomic, strong) NSMutableArray <CLPerformModel*> *performModelList;
@property (nonatomic, strong) NSMutableArray <CLNotesModel*> *notesModelList;

@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, assign) NSUInteger childVCCount;
@property (nonatomic, assign) NSUInteger selectedVCIndex;

@end
