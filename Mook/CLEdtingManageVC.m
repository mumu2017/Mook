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

#define kEffectCount   1
#define kEffectIndex    0

@interface CLEdtingManageVC ()<CLEditingVCDelegate, CLPropInputVCDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIProgressView *topProgressView;

@property (nonatomic, strong) CLMediaView *mediaView;

@property (nonatomic, assign) NSUInteger indexInPropModelList;
@property (nonatomic, assign) NSUInteger indexInPrepModelList;
@property (nonatomic, assign) NSUInteger indexInPerformModelList;
@property (nonatomic, assign) NSUInteger indexInNotesModelList;

@end

@implementation CLEdtingManageVC

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

- (void)updateProgress {
    
    CGFloat progress = (1.0 * (self.currentIndex + 1)) / self.childVCCount;
    CGFloat topProgress = (1.0 * (self.currentIndex)) / self.childVCCount;

    [self.progressView setProgress:progress animated:YES];
    [self.topProgressView setProgress:topProgress animated:YES];
}

#pragma mark - VC数量
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
            
        default:
            break;
    }
    
    return _childVCCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self mediaView];
    self.isProgressiveIndicator = NO;
    self.isElasticIndicatorLimit = YES;
    self.isEditing = YES;

    // Do any additional setup after loading the view.

//    self.pageControl.dotColor = [UIColor lightGrayColor];
//    self.pageControl.selectedDotColor = kTintColor;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.pagerTabStripChildViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSAssert([obj conformsToProtocol:@protocol(XLPagerTabStripChildItem)], @"child view controller must conform to XLPagerTabStripChildItem");
        
        if (idx == self.selectedVCIndex) {
            [self moveToViewControllerAtIndex:idx];

            UIViewController<XLPagerTabStripChildItem> * childViewController = (UIViewController<XLPagerTabStripChildItem> *)obj;
            
            self.navigationItem.title = [childViewController titleForPagerTabStripViewController:self];
            [self updateProgress];
            
        }
    }];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    NSLog(@"llllllllllllll");

    if (self.presentedViewController == nil) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateEntryVCNotification object:self];
        
//        NSString *notification = nil;
//        
//        if (self.editingContentType == kEditingContentTypeRoutine) {
//            notification = kUpdateRoutinesNotification;
//        } else if (self.editingContentType == kEditingContentTypeIdea) {
//            notification = kUpdateIdeasNotification;
//        } else if (self.editingContentType == kEditingContentTypeSleight) {
//            notification = kUpdateSleightsNotification;
//        } else if (self.editingContentType == kEditingContentTypeProp) {
//            notification = kUpdatePropsNotification;
//        } else if (self.editingContentType == kEditingContentTypeLines) {
//            notification = kUpdateLinesNotification;
//        }
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
//        NSLog(@"xxxxxxxxxxxx");
    }
    
}

#pragma mark - XLPagerTabStripViewControllerDataSource

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
                vc.manageVC = self;
                vc.mediaView = self.mediaView;
                [childVCArray addObject:vc];
            } else if (i > 0 && i <= self.routineModel.propModelList.count) {
                CLPropInputVC *vc = [sb instantiateViewControllerWithIdentifier:@"propInputVC"];
                vc.propModel = self.routineModel.propModelList[i-1];
                vc.delegate = self;
                vc.manageVC = self;

                [childVCArray addObject:vc];
            } else if (i > self.routineModel.propModelList.count && i <= self.routineModel.propModelList.count + self.routineModel.prepModelList.count) {
                
                CLEditingVC *vc = [sb instantiateViewControllerWithIdentifier:@"editingVC"];
                vc.prepModel = self.routineModel.prepModelList[i-self.routineModel.propModelList.count-1];
                vc.editingModel = kEditingModePrep;
                vc.editingContentType = self.editingContentType;
                vc.timeStamp = self.routineModel.timeStamp;

                vc.delegate = self;
                vc.manageVC = self;
                vc.mediaView = self.mediaView;

                [childVCArray addObject:vc];
            } else if (i > self.routineModel.propModelList.count + self.routineModel.prepModelList.count && i <= self.routineModel.propModelList.count + self.routineModel.prepModelList.count + self.routineModel.performModelList.count) {
                
                CLEditingVC *vc = [sb instantiateViewControllerWithIdentifier:@"editingVC"];
                vc.performModel = self.routineModel.performModelList[i-self.routineModel.propModelList.count-self.routineModel.prepModelList.count-1];
                vc.editingModel = kEditingModePerform;

                vc.editingContentType = self.editingContentType;
                vc.timeStamp = self.routineModel.timeStamp;

                vc.delegate = self;
                vc.manageVC = self;
                vc.mediaView = self.mediaView;

                [childVCArray addObject:vc];
            } else if (i > self.routineModel.propModelList.count + self.routineModel.prepModelList.count + self.routineModel.performModelList.count && i <= self.routineModel.propModelList.count + self.routineModel.prepModelList.count + self.routineModel.performModelList.count + self.routineModel.notesModelLsit.count) {
                CLEditingVC *vc = [sb instantiateViewControllerWithIdentifier:@"editingVC"];
                vc.notesModel = self.routineModel.notesModelLsit[i-self.routineModel.propModelList.count-self.routineModel.prepModelList.count-self.routineModel.performModelList.count-1];
                vc.editingModel = kEditingModeNotes;
                vc.editingContentType = self.editingContentType;
                vc.delegate = self;
                vc.manageVC = self;
                vc.mediaView = self.mediaView;

                [childVCArray addObject:vc];
            }
            
        } else {
            CLEditingVC *vc = [sb instantiateViewControllerWithIdentifier:@"editingVC"];
            vc.delegate = self;
            vc.manageVC = self;
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
            }

            [childVCArray addObject:vc];
        }
        
    }
    
    return childVCArray;
}



#pragma mark - XLPagerTabStripViewControllerDelegate

-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
{
    
    [self.pagerTabStripChildViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSAssert([obj conformsToProtocol:@protocol(XLPagerTabStripChildItem)], @"child view controller must conform to XLPagerTabStripChildItem");
        
        if (idx == toIndex) {
            UIViewController<XLPagerTabStripChildItem> * childViewController = (UIViewController<XLPagerTabStripChildItem> *)obj;
            
            self.navigationItem.title = [childViewController titleForPagerTabStripViewController:self];
            [self updateProgress];
        }
    }];
    
}

//-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
//          updateIndicatorFromIndex:(NSInteger)fromIndex
//                           toIndex:(NSInteger)toIndex
//            withProgressPercentage:(CGFloat)progressPercentage
//                   indexWasChanged:(BOOL)indexWasChanged
//{
//
//    [self.pagerTabStripChildViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NSAssert([obj conformsToProtocol:@protocol(XLPagerTabStripChildItem)], @"child view controller must conform to XLPagerTabStripChildItem");
//        
//        if (idx == toIndex) {
//            UIViewController<XLPagerTabStripChildItem> * childViewController = (UIViewController<XLPagerTabStripChildItem> *)obj;
//            
//            self.titleView.text = [childViewController titleForPagerTabStripViewController:self];
//            self.titleView.alpha = progressPercentage;
//        }
//        
//        
//    }];
//}

#pragma mark EditingVC 代理方法
- (void)editingVCDidSwitchPerformContent:(CLEditingVC *)editingVC {
    
    self.navigationItem.title = [editingVC titleForPagerTabStripViewController:self];
}

- (void)editingVCAddPrep:(CLEditingVC *)editingVC {
    
    CLPrepModel *model = [CLPrepModel prepModel];
    [self.prepModelList insertObject:model atIndex:self.indexInPrepModelList];
    
    [self reloadPagerTabStripView];
    self.isEditing = YES;
    [self moveToViewControllerAtIndex:self.currentIndex+1 animated:YES];
//    NSUInteger tempIndex = self.indexInPrepModelList + 1;
//    [self reloadPagerTabStripView];
//    [self moveToViewControllerAtIndex:self.propModelList.count + tempIndex animated:YES];
    
}

- (void)editingVCAddPerform:(CLEditingVC *)editingVC {
    
    CLPerformModel *model = [CLPerformModel performModel];
    [self.performModelList insertObject:model atIndex:self.indexInPerformModelList];
    
    [self reloadPagerTabStripView];
    self.isEditing = YES;

    [self moveToViewControllerAtIndex:self.currentIndex+1 animated:YES];
}

- (void)editingVCAddNotes:(CLEditingVC *)editingVC {
    CLNotesModel *model = [CLNotesModel notesModel];
    [self.notesModelList insertObject:model atIndex:self.indexInNotesModelList];
    
    [self reloadPagerTabStripView];
    self.isEditing = YES;

    [self moveToViewControllerAtIndex:self.currentIndex+1 animated:YES];

}

- (void)editingVCDeletePrep:(CLEditingVC *)editingVC {
    
    [self.prepModelList removeObject:editingVC.prepModel];
    
    [self reloadPagerTabStripView];
    self.isEditing = YES;

    [self moveToViewControllerAtIndex:self.currentIndex-1 animated:YES];

}

- (void)editingVCDeletePerform:(CLEditingVC *)editingVC {
    
    [self.performModelList removeObject:editingVC.performModel];
    
    [self reloadPagerTabStripView];
    self.isEditing = YES;

    [self moveToViewControllerAtIndex:self.currentIndex-1 animated:YES];
}

- (void)editingVCDeleteNotes:(CLEditingVC *)editingVC {
    
    [self.notesModelList removeObject:editingVC.notesModel];

    [self reloadPagerTabStripView];
    self.isEditing = YES;

    [self moveToViewControllerAtIndex:self.currentIndex-1 animated:YES];

}

#pragma mark -PropInputVC 代理方法
- (void)propInputVCAddProp:(CLPropInputVC *)propInputVC {
    CLPropModel *model = [CLPropModel propModel];
    [self.propModelList insertObject:model atIndex:self.indexInPropModelList];
    
    [self reloadPagerTabStripView];
    self.isEditing = YES;

    [self moveToViewControllerAtIndex:self.currentIndex+1 animated:YES];
}

- (void)propInputVCDeleteProp:(CLPropInputVC *)propInputVC {
    [self.propModelList removeObject:propInputVC.propModel];
    
    [self reloadPagerTabStripView];
    self.isEditing = YES;

    [self moveToViewControllerAtIndex:self.currentIndex-1 animated:YES];
}

- (IBAction)doneButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
