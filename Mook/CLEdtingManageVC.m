//
//  CLEdtingManageVC.m
//  Mook
//
//  Created by 陈林 on 16/1/3.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import "CLEdtingManageVC.h"

#import "CLPropInputVC.h"
#import "CLEditingVC.h"

#import "CLShowModel.h"
#import "CLRoutineModel.h"
#import "CLIdeaObjModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"

#import "CLPerformModel.h"
#import "CLPrepModel.h"
#import "CLEffectModel.h"
#import "CLPropModel.h"
#import "CLInfoModel.h"
#import "CLNotesModel.h"

#import "CLMediaView.h"

#import "IATConfig.h"
#import "PopupView.h"
#import "ISRDataHelper.h"

#define kEffectCount   1
#define kEffectIndex    0

@interface CLEdtingManageVC ()<CLEditingVCDelegate, CLPropInputVCDelegate, IFlySpeechRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIProgressView *topProgressView;

@property (nonatomic, strong) CLMediaView *mediaView;

@property (nonatomic, assign) NSUInteger indexInPropModelList;
@property (nonatomic, assign) NSUInteger indexInPrepModelList;
@property (nonatomic, assign) NSUInteger indexInPerformModelList;
@property (nonatomic, assign) NSUInteger indexInNotesModelList;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger currentIdentifierTag;
@property (nonatomic, copy) NSString *voiceLanguage;

@end

@implementation CLEdtingManageVC

- (NSString *)voiceLanguage {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _voiceLanguage = [defaults stringForKey:kVoiceLanguageKey];
    if (_voiceLanguage == nil) {
        _voiceLanguage = kVoiceChinese;
        [defaults setObject:_voiceLanguage forKey:kVoiceLanguageKey];
    }
    
    return _voiceLanguage;
}

- (CLMediaView *)mediaView {
    if (!_mediaView) {
        _mediaView = [CLMediaView mediaView];
        _mediaView.alpha = 0.0f;
        _mediaView.isEditing = YES;
        UIView *windowView = [[UIApplication sharedApplication] keyWindow];
        [windowView addSubview:_mediaView];
        
        _mediaView.frame = CGRectMake(0, 0, kImageDisplayW, kImageDisplayH);
        _mediaView.center = windowView.center;
        [_mediaView showWhiteBorder];
    }
    
    return _mediaView;
}

-(NSUInteger)indexInPropModelList {
   return (self.currentIndex > kEffectIndex) ? self.currentIndex - kEffectIndex : 0;
    
}

- (NSUInteger)indexInPrepModelList {
    return (self.currentIndex > self.propModelList.count + kEffectIndex) ? self.currentIndex - self.propModelList.count - kEffectIndex : 0;
}

- (NSUInteger)indexInPerformModelList {
    return (self.currentIndex > self.prepModelList.count + self.propModelList.count + kEffectIndex) ? self.currentIndex - self.prepModelList.count - self.propModelList.count - kEffectIndex : 0;
}

- (NSUInteger)indexInNotesModelList {
       return (self.currentIndex > self.performModelList.count + self.prepModelList.count + self.propModelList.count + kEffectIndex) ? self.currentIndex - self.performModelList.count - self.prepModelList.count - self.propModelList.count - kEffectIndex : 0;
}

#pragma mark - 数据懒加载
- (CLEffectModel *)effectModel {
    
    if (_effectModel == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _effectModel = self.routineModel.effectModel;
                break;
                
            case kEditingContentTypeIdea:
                _effectModel = self.ideaObjModel.effectModel;
                break;
                
            case kEditingContentTypeSleight:
                _effectModel = self.sleightObjModel.effectModel;
                break;
                
            case kEditingContentTypeProp:
                _effectModel = self.propObjModel.effectModel;
                break;
                
            case kEditingContentTypeLines:
                _effectModel = self.linesObjModel.effectModel;
                break;
                
            case kEditingContentTypeShow:
                _effectModel = self.showModel.effectModel;
                break;
            default:
                break;
        }
        
    }
    
    return _effectModel;
}

- (NSMutableArray *)propModelList {
    
    if (_propModelList == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _propModelList = self.routineModel.propModelList;
                break;
                
            default:
                break;
        }
    }
    
    return _propModelList;
}

- (NSMutableArray *)prepModelList {
    
    if (_prepModelList == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _prepModelList = self.routineModel.prepModelList;
                break;
                
            case kEditingContentTypeIdea:
                _prepModelList = self.ideaObjModel.prepModelList;
                break;
                
            case kEditingContentTypeSleight:
                _prepModelList = self.sleightObjModel.prepModelList;
                break;
                
            case kEditingContentTypeProp:
                _prepModelList = self.propObjModel.prepModelList;
                break;
                
            default:
                break;
        }
    }
    return _prepModelList;
}

- (NSMutableArray *)performModelList {
    if (_performModelList == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _performModelList = self.routineModel.performModelList;
                break;
                
            default:
                break;
        }
    }
    return _performModelList;
}

- (NSMutableArray *)notesModelList {
    if (_notesModelList == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _notesModelList = self.routineModel.notesModelLsit;
                break;
                
            default:
                break;
        }
    }
    return _notesModelList;
}

// 懒加载routineModel
- (CLRoutineModel *)routineModel {
    if (!_routineModel) {
        _routineModel = [CLRoutineModel routineModel];
    }
    return _routineModel;
}

- (CLIdeaObjModel *)ideaObjModel {
    if (_ideaObjModel == nil) {
        _ideaObjModel = [CLIdeaObjModel ideaObjModel];
    }
    return _ideaObjModel;
}

- (CLSleightObjModel *)sleightObjModel {
    if (_sleightObjModel == nil) {
        _sleightObjModel = [CLSleightObjModel sleightObjModel];
    }
    return _sleightObjModel;
}

- (CLPropObjModel *)propObjModel {
    if (_propObjModel == nil) {
        _propObjModel = [CLPropObjModel propObjModel];
    }
    return _propObjModel;
}

- (CLLinesObjModel *)linesObjModel {
    if (_linesObjModel == nil) {
        _linesObjModel = [CLLinesObjModel linesObjModel];
    }
    return _linesObjModel;
}


#pragma mark - 更新进度条
- (void)updateProgressToRight:(NSInteger)fromIndex withPercent:(CGFloat)percent {
    
    CGFloat progress = (1.0 * (fromIndex + 1 + percent)) / self.childVCCount;
    CGFloat topProgress = progress - (1.0/self.childVCCount);

    [self.progressView setProgress:progress animated:NO];
    [self.topProgressView setProgress:topProgress animated:NO];
}

- (void)updateProgressToLeft:(NSInteger)fromIndex withPercent:(CGFloat)percent {
    
    CGFloat progress = (1.0 * (fromIndex + 1 - percent)) / self.childVCCount;
    CGFloat topProgress = progress - (1.0/self.childVCCount);
    
    [self.progressView setProgress:progress animated:NO];
    [self.topProgressView setProgress:topProgress animated:NO];
}

- (void)updateProgress {
    
    CGFloat progress = (1.0 * (self.currentIndex + 1)) / self.childVCCount;
    CGFloat topProgress = progress - (1.0/self.childVCCount);
    
    [self.progressView setProgress:progress animated:NO];
    [self.topProgressView setProgress:topProgress animated:NO];
    [self updateTitle];
}

#pragma mark 更新标题
- (void)updateTitle {
    [self.pagerTabStripChildViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSAssert([obj conformsToProtocol:@protocol(XLPagerTabStripChildItem)], @"child view controller must conform to XLPagerTabStripChildItem");
        
        if (idx == self.currentIndex) {
            UIViewController<XLPagerTabStripChildItem> * childViewController = (UIViewController<XLPagerTabStripChildItem> *)obj;
            
            self.navigationItem.title = [childViewController titleForPagerTabStripViewController:self];
        }
    }];
}

#pragma mark - 子VC数量
- (NSUInteger)childVCCount {
    
    _childVCCount = 0;
    
    switch (self.editingContentType) {
        case kEditingContentTypeRoutine:
            _childVCCount = kEffectCount + self.propModelList.count + self.prepModelList.count + self.performModelList.count + self.notesModelList.count;
            break;
            
        case kEditingContentTypeIdea:
            _childVCCount = kEffectCount + self.prepModelList.count;
            break;
            
        case kEditingContentTypeSleight:
            _childVCCount = kEffectCount + self.prepModelList.count;
            break;
            
        case kEditingContentTypeProp:
            _childVCCount = kEffectCount + self.prepModelList.count;
            break;
            
        case kEditingContentTypeLines:
            _childVCCount = kEffectCount;
            break;
            
        case kEditingContentTypeShow:
            _childVCCount = kEffectCount;
            break;
            
        default:
            break;
    }
    
    return _childVCCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self mediaView];
    self.isProgressiveIndicator = YES;
    self.isElasticIndicatorLimit = YES;
    self.progressView.progressTintColor = [UIColor whiteColor];
    self.progressView.trackTintColor = kMenuBackgroundColor;
    self.topProgressView.progressTintColor = kMenuBackgroundColor;
    self.topProgressView.trackTintColor = [UIColor clearColor];
    
    CGFloat posY = 100;
    _popUpView = [[PopupView alloc] initWithFrame:CGRectMake(100, posY, 0, 0) withParentView:self.view];
    
    //demo录音文件保存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    _pcmFilePath = [[NSString alloc] initWithFormat:@"%@",[cachePath stringByAppendingPathComponent:@"asr.pcm"]];
}

- (void)dealloc {
    
    [_iFlySpeechRecognizer cancel]; //取消识别
    [_iFlySpeechRecognizer setDelegate:nil];
    [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self moveToViewControllerAtIndex:self.selectedVCIndex];
    [self updateProgress];
    
    [self initRecognizer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateEntryVCNotification object:self];
}

#pragma mark - XLPagerTabStripViewControllerDataSource 设置子控制器属性

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    // create child view controllers that will be managed by XLPagerTabStripViewController
    NSMutableArray *childVCArray = [NSMutableArray array];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    for (int i=0; i < self.childVCCount; i++) {
        
        if (self.editingContentType == kEditingContentTypeRoutine) {
            if (i == 0) {
                CLEditingVC *vc = [sb instantiateViewControllerWithIdentifier:@"editingVC"];
                vc.effectModel = self.routineModel.effectModel;
                vc.editingModel = kEditingModeEffect;
                vc.editingContentType = self.editingContentType;
                vc.timeStamp = self.routineModel.timeStamp;
                vc.delegate = self;
                vc.identifierTag = i; // 每个子控制器都有一个单独的tag,用于语音识别传输数据
                vc.mediaView = self.mediaView;
                vc.manageVC = self;
                
                [childVCArray addObject:vc];
            } else if (i > 0 && i <= self.routineModel.propModelList.count) {
                CLPropInputVC *vc = [sb instantiateViewControllerWithIdentifier:@"propInputVC"];
                vc.propModel = self.routineModel.propModelList[i-1];
                vc.delegate = self;

                [childVCArray addObject:vc];
            } else if (i > self.routineModel.propModelList.count && i <= self.routineModel.propModelList.count + self.routineModel.prepModelList.count) {
                
                CLEditingVC *vc = [sb instantiateViewControllerWithIdentifier:@"editingVC"];
                vc.prepModel = self.routineModel.prepModelList[i-self.routineModel.propModelList.count-1];
                vc.editingModel = kEditingModePrep;
                vc.editingContentType = self.editingContentType;
                vc.timeStamp = self.routineModel.timeStamp;

                vc.manageVC = self;
                vc.identifierTag = i;
                vc.delegate = self;
                vc.mediaView = self.mediaView;

                [childVCArray addObject:vc];
            } else if (i > self.routineModel.propModelList.count + self.routineModel.prepModelList.count && i <= self.routineModel.propModelList.count + self.routineModel.prepModelList.count + self.routineModel.performModelList.count) {
                
                CLEditingVC *vc = [sb instantiateViewControllerWithIdentifier:@"editingVC"];
                vc.performModel = self.routineModel.performModelList[i-self.routineModel.propModelList.count-self.routineModel.prepModelList.count-1];
                vc.editingModel = kEditingModePerform;

                vc.editingContentType = self.editingContentType;
                vc.timeStamp = self.routineModel.timeStamp;

                vc.manageVC = self;
                vc.identifierTag = i;
                vc.delegate = self;
                vc.mediaView = self.mediaView;

                [childVCArray addObject:vc];
            } else if (i > self.routineModel.propModelList.count + self.routineModel.prepModelList.count + self.routineModel.performModelList.count && i <= self.routineModel.propModelList.count + self.routineModel.prepModelList.count + self.routineModel.performModelList.count + self.routineModel.notesModelLsit.count) {
                CLEditingVC *vc = [sb instantiateViewControllerWithIdentifier:@"editingVC"];
                vc.notesModel = self.routineModel.notesModelLsit[i-self.routineModel.propModelList.count-self.routineModel.prepModelList.count-self.routineModel.performModelList.count-1];
                vc.editingModel = kEditingModeNotes;
                vc.editingContentType = self.editingContentType;
                
                vc.manageVC = self;
                vc.identifierTag = i;
                vc.delegate = self;
                vc.mediaView = self.mediaView;

                [childVCArray addObject:vc];
            }
            
        } else {
            CLEditingVC *vc = [sb instantiateViewControllerWithIdentifier:@"editingVC"];
            
            vc.manageVC = self;
            vc.identifierTag = i;
            vc.delegate = self;
            vc.editingContentType = self.editingContentType;
            vc.mediaView = self.mediaView;

            if (self.editingContentType == kEditingContentTypeIdea) {
                if (i == 0) {
                    vc.effectModel = self.ideaObjModel.effectModel;
                    vc.editingModel = kEditingModeEffect;
                    vc.timeStamp = self.ideaObjModel.timeStamp;

                } else if (i > 0 && i <= self.ideaObjModel.prepModelList.count) {
                    
                    vc.prepModel = self.ideaObjModel.prepModelList[i-1];
                    vc.editingModel = kEditingModePrep;
                    vc.timeStamp = self.ideaObjModel.timeStamp;

                }
            } else if (self.editingContentType == kEditingContentTypeSleight) {
                if (i == 0) {
                    vc.effectModel = self.sleightObjModel.effectModel;
                    vc.editingModel = kEditingModeEffect;
                    vc.timeStamp = self.sleightObjModel.timeStamp;

                } else if (i > 0 && i <= self.sleightObjModel.prepModelList.count) {
                    
                    vc.prepModel = self.sleightObjModel.prepModelList[i-1];
                    vc.editingModel = kEditingModePrep;
                    vc.timeStamp = self.sleightObjModel.timeStamp;

                }
            } else if (self.editingContentType == kEditingContentTypeProp) {
                if (i == 0) {
                    vc.effectModel = self.propObjModel.effectModel;
                    vc.editingModel = kEditingModeEffect;
                    vc.timeStamp = self.propObjModel.timeStamp;

                } else if (i > 0 && i <= self.propObjModel.prepModelList.count) {
                    
                    vc.prepModel = self.propObjModel.prepModelList[i-1];
                    vc.editingModel = kEditingModePrep;
                    vc.timeStamp = self.propObjModel.timeStamp;

                }
            } else if (self.editingContentType == kEditingContentTypeLines) {
                if (i == 0) {
                    vc.effectModel = self.linesObjModel.effectModel;
                    vc.editingModel = kEditingModeEffect;

                }
            } else if (self.editingContentType == kEditingContentTypeShow) {
                if (i == 0) {
                    vc.effectModel = self.showModel.effectModel;
                    vc.editingModel = kEditingModeEffect;
                    vc.timeStamp = self.showModel.timeStamp;

                }
            }

            [childVCArray addObject:vc];
        }
        
    }
    
    return childVCArray;
}



#pragma mark - XLPagerTabStripViewControllerDelegate 更新进度条

-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
            withProgressPercentage:(CGFloat)progressPercentage
                   indexWasChanged:(BOOL)indexWasChanged
{

    if (!indexWasChanged) {
        if (toIndex > fromIndex) {
            [self updateProgressToRight:fromIndex withPercent:progressPercentage];
        } else if (toIndex < fromIndex) {
            [self updateProgressToLeft:fromIndex withPercent:progressPercentage];
        }
    }

    if (indexWasChanged) {

        [self.pagerTabStripChildViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSAssert([obj conformsToProtocol:@protocol(XLPagerTabStripChildItem)], @"child view controller must conform to XLPagerTabStripChildItem");

            if (indexWasChanged) {
                [self updateTitle];
            }
        }];
    }
}

#pragma mark EditingVC 代理方法
- (void)editingVCDidSwitchPerformContent:(CLEditingVC *)editingVC {
    
    self.navigationItem.title = [editingVC titleForPagerTabStripViewController:self];
}

- (void)editingVCAddPrep:(CLEditingVC *)editingVC {
    
    CLPrepModel *model = [CLPrepModel prepModel];
    [self.prepModelList insertObject:model atIndex:self.indexInPrepModelList];
    
    [self reloadPagerTabStripView];
    [self moveToViewControllerAtIndex:self.currentIndex+1 animated:YES];
    [self updateProgress];

//    NSUInteger tempIndex = self.indexInPrepModelList + 1;
//    [self reloadPagerTabStripView];
//    [self moveToViewControllerAtIndex:self.propModelList.count + tempIndex animated:YES];
    
}

- (void)editingVCAddPerform:(CLEditingVC *)editingVC {
    
    CLPerformModel *model = [CLPerformModel performModel];
    [self.performModelList insertObject:model atIndex:self.indexInPerformModelList];
    
    [self reloadPagerTabStripView];

    [self moveToViewControllerAtIndex:self.currentIndex+1 animated:YES];
    [self updateProgress];
}

- (void)editingVCAddNotes:(CLEditingVC *)editingVC {
    CLNotesModel *model = [CLNotesModel notesModel];
    [self.notesModelList insertObject:model atIndex:self.indexInNotesModelList];
    
    [self reloadPagerTabStripView];

    [self moveToViewControllerAtIndex:self.currentIndex+1 animated:YES];
    [self updateProgress];
}

- (void)editingVCDeletePrep:(CLEditingVC *)editingVC {
    
    [self.prepModelList removeObject:editingVC.prepModel];

    [self reloadPagerTabStripView];
    if (self.currentIndex > 0 && self.currentIndex != self.childVCCount-1) {
        [self moveToViewControllerAtIndex:self.currentIndex-1 animated:YES];
    }
    [self updateProgress];
}

- (void)editingVCDeletePerform:(CLEditingVC *)editingVC {
    
    [self.performModelList removeObject:editingVC.performModel];
    
    [self reloadPagerTabStripView];
    if (self.currentIndex > 0 && self.currentIndex != self.childVCCount-1) {
        [self moveToViewControllerAtIndex:self.currentIndex-1 animated:YES];
    }
    [self updateProgress];
}

- (void)editingVCDeleteNotes:(CLEditingVC *)editingVC {
    
    [self.notesModelList removeObject:editingVC.notesModel];
    
    [self reloadPagerTabStripView];
    if (self.currentIndex > 0 && self.currentIndex != self.childVCCount-1) {
        [self moveToViewControllerAtIndex:self.currentIndex-1 animated:YES];
    }
    [self updateProgress];
}

#pragma mark -PropInputVC 代理方法
- (void)propInputVCAddProp:(CLPropInputVC *)propInputVC {
    CLPropModel *model = [CLPropModel propModel];
    [self.propModelList insertObject:model atIndex:self.indexInPropModelList];
    
    [self reloadPagerTabStripView];

    [self moveToViewControllerAtIndex:self.currentIndex+1 animated:YES];
    [self updateProgress];
}

- (void)propInputVCDeleteProp:(CLPropInputVC *)propInputVC {
    [self.propModelList removeObject:propInputVC.propModel];
    
    [self reloadPagerTabStripView];
    if (self.currentIndex > 0 && self.currentIndex != self.childVCCount-1) {
        [self moveToViewControllerAtIndex:self.currentIndex-1 animated:YES];
    }
    [self updateProgress];
}

- (IBAction)doneButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 讯飞语音

- (void)editingVC:(CLEditingVC *)editingVC startAudioRecognitionWithContent:(NSString *)content andIdentifierTag:(NSInteger)identifierTag{
    
    self.content = content;
    self.currentIdentifierTag = identifierTag;
    
    if ([self.iFlySpeechRecognizer isListening]) {
        [self stopVoiceRecognition];
    } else {
        [self startVoiceRecognition];
    }
}

- (void)editingVCCancelAudioRecognition:(CLEditingVC *)editingVC {
    
    if ([self.iFlySpeechRecognizer isListening]) {
        [self stopVoiceRecognition];
    }
    
}

/**
 启动听写
 *****/
- (void)startVoiceRecognition {
    
    self.isCanceled = NO;
    
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (ret) {

        
    }else{
        [_popUpView showText: NSLocalizedString(@"启动识别服务失败，请稍后重试", nil)];//可能是上次请求未结束，暂不支持多路并发
    }
}

/**
 停止听写
 *****/
- (void)stopVoiceRecognition {
    self.isCanceled = YES;
    
    [_iFlySpeechRecognizer stopListening];
    
    if ([self.editDelegate respondsToSelector:@selector(editingManageVC:didFinishWithAudioRecognizeResult:currentIdentifierTag:)]) {
        [self.editDelegate editingManageVC:self didFinishWithAudioRecognizeResult:self.content currentIdentifierTag:self.currentIdentifierTag];
    }
    
//    [_popUpView removeFromSuperview];
}


/**
 设置识别参数
 ****/
-(void)initRecognizer
{
//    NSLog(@"%s",__func__);
    
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
}

#pragma mark - IFlySpeechRecognizerDelegate

/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
//    if (self.isCanceled) {
//        [_popUpView removeFromSuperview];
//        return;
//    }
    
    NSString * vol = [NSString stringWithFormat:NSLocalizedString(@"语音识别中\n音量：%d", nil),volume];
    [_popUpView showText: vol];
}



/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
//    NSLog(@"onBeginOfSpeech");
    [_popUpView showText: NSLocalizedString(@"正在录音", nil)];
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
//    NSLog(@"onEndOfSpeech");
    
    [_popUpView showText: NSLocalizedString(@"停止录音", nil)];
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
//    NSLog(@"%s",__func__);
    
    if ([IATConfig sharedInstance].haveView == NO ) {
        NSString *text ;
        
        if (self.isCanceled) {
            text = NSLocalizedString(@"识别停止", nil);
            
        } else if (error.errorCode == 0 ) {
            if (_result.length == 0) {
                text = NSLocalizedString(@"无识别结果", nil);
            }else {
                text = NSLocalizedString(@"识别成功", nil);
            }
        }else {
            text = [NSString stringWithFormat:NSLocalizedString(@"发生错误：%d %@", nil), error.errorCode,error.errorDesc];
//            NSLog(@"%@",text);
        }
        
        [_popUpView showText: text];
        
    }else {
        [_popUpView showText:NSLocalizedString(@"识别结束", nil)];
//        NSLog(@"errorCode:%d",[error errorCode]);
    }

    
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    _result =[NSString stringWithFormat:@"%@%@", self.content,resultString];
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    self.content = [NSString stringWithFormat:@"%@%@", self.content,resultFromJson];
    
    if (isLast){
//        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
//    NSLog(@"_result=%@",_result);
//    NSLog(@"resultFromJson=%@",resultFromJson);
//    NSLog(@"isLast=%d,_textView.text=%@",isLast,_editTextView.text);
    
    if ([self.editDelegate respondsToSelector:@selector(editingManageVC:didFinishWithAudioRecognizeResult:currentIdentifierTag:)]) {
        [self.editDelegate editingManageVC:self didFinishWithAudioRecognizeResult:self.content currentIdentifierTag:self.currentIdentifierTag];
    }
}


@end
