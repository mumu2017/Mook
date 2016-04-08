//
//  CLEdtingManageVC.h
//  Mook
//
//  Created by 陈林 on 16/1/3.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import "XLPagerTabStripViewController.h"
#import "CLNewEntryVC.h"
#import "iflyMSC/iflyMSC.h"

@class CLRoutineModel, CLIdeaObjModel, CLSleightObjModel, CLPropObjModel, CLLinesObjModel, CLShowModel;
@class CLEffectModel, CLPropModel, CLPrepModel, CLPerformModel, CLNotesModel;
@class CLEdtingManageVC, PopupView;

@protocol CLEdtingManageVCDelegate <NSObject>

@optional
- (void)editingManageVC:(CLEdtingManageVC *)edtingManageVC didFinishWithAudioRecognizeResult:(NSString *)result currentIdentifierTag:(NSInteger)identifierTag;

@end

@interface CLEdtingManageVC : XLPagerTabStripViewController

@property (nonatomic, assign) EditingContentType editingContentType;

@property (nonatomic, strong) CLRoutineModel *routineModel;
@property (nonatomic, strong) CLIdeaObjModel *ideaObjModel;
@property (nonatomic, strong) CLSleightObjModel *sleightObjModel;
@property (nonatomic, strong) CLPropObjModel *propObjModel;
@property (nonatomic, strong) CLLinesObjModel *linesObjModel;
@property (nonatomic, strong) CLShowModel *showModel;

@property (nonatomic, strong) CLEffectModel *effectModel;
@property (nonatomic, strong) NSMutableArray <CLPropModel*> *propModelList;
@property (nonatomic, strong) NSMutableArray <CLPrepModel*> *prepModelList;
@property (nonatomic, strong) NSMutableArray <CLPerformModel*> *performModelList;
@property (nonatomic, strong) NSMutableArray <CLNotesModel*> *notesModelList;

@property (nonatomic, assign) NSUInteger childVCCount;
@property (nonatomic, assign) NSUInteger selectedVCIndex;

#pragma mark - 讯飞语音识别
@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) PopupView *popUpView;

@property (nonatomic, strong) NSString * result;
@property (nonatomic, assign) BOOL isCanceled;

@property (nonatomic, weak) id<CLEdtingManageVCDelegate> editDelegate;

@end
