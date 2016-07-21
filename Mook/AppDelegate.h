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
@property (strong, nonatomic) UIViewController *mainController;


@property (nonatomic, strong) NSMutableArray *allItems;
@property (nonatomic, strong) NSMutableArray *allTags;
@property (nonatomic, strong) NSMutableArray *allTagsShow;
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

@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, assign) BOOL shouldInputPassword;

- (void)reloadData; // 恢复备份后更新数据
- (void)updateData; // 只更新mook笔记的数据,不包括标签

- (void)setAppUI;

- (void)reloadAllItems;

- (void)reloadAllIdeas;

- (void)reloadAllShows;

- (void)reloadAllRoutines;

- (void)reloadAllSleights;

- (void)reloadAllProps;

- (void)reloadAllLines;

@end

