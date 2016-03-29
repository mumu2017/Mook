//
//  AppDelegate.h
//  Mook
//
//  Created by 陈林 on 15/11/16.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLShowModel, CLRoutineModel, CLIdeaObjModel, CLSleightObjModel, CLPropObjModel, CLLinesObjModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSMutableArray *allItems;
@property (nonatomic, strong) NSMutableArray *allTags;
@property (nonatomic, strong) NSMutableArray *allTagsIdea;
@property (nonatomic, strong) NSMutableArray *allTagsRoutine;
@property (nonatomic, strong) NSMutableArray *allTagsSleight;
@property (nonatomic, strong) NSMutableArray *allTagsProp;
@property (nonatomic, strong) NSMutableArray *allTagsLines;


@property (nonatomic, strong) NSMutableArray <CLShowModel*> *showModelList;
@property (nonatomic, strong) NSMutableArray <CLRoutineModel*> *routineModelList;
@property (nonatomic, strong) NSMutableArray <CLIdeaObjModel*> *ideaObjModelList;
@property (nonatomic, strong) NSMutableArray <CLSleightObjModel*> *sleightObjModelList;
@property (nonatomic, strong) NSMutableArray <CLPropObjModel*> *propObjModelList;
@property (nonatomic, strong) NSMutableArray <CLLinesObjModel*> *linesObjModelList;

@property (nonatomic, assign) BOOL shouldInputPassword;

@end

