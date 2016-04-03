//
//  CLEditingVC.h
//  Mook
//
//  Created by 陈林 on 15/12/7.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLNewEntryVC.h"

@class CLToolBar, CLEditingVC, XLPagerTabStripViewController;
@class CLEffectModel, CLPropModel, CLPrepModel, CLPerformModel, CLNotesModel;
@class CLMediaView;

@protocol CLEditingVCDelegate <NSObject>

@optional

- (void) editingVCAddPrep:(CLEditingVC *)editingVC;
- (void) editingVCAddPerform:(CLEditingVC *)editingVC;
- (void) editingVCAddNotes:(CLEditingVC *)editingVC;

- (void) editingVCDeletePrep:(CLEditingVC *)editingVC;
- (void) editingVCDeletePerform:(CLEditingVC *)editingVC;
- (void) editingVCDeleteNotes:(CLEditingVC *)editingVC;

- (void) editingVCDidSwitchPerformContent:(CLEditingVC *)editingVC;

@end


@interface CLEditingVC : UIViewController

@property (nonatomic, weak) IBOutlet UITextView *editTextView;
@property (nonatomic, strong) CLMediaView *mediaView;

@property (nonatomic, assign) EditingContentType editingContentType;

@property (nonatomic, strong) CLEffectModel *effectModel;
@property (nonatomic, strong) CLPropModel *propModel;
@property (nonatomic, strong) CLPrepModel *prepModel;
@property (nonatomic, strong) CLPerformModel *performModel;
@property (nonatomic, strong) CLNotesModel *notesModel;
// 主模型中的timeStamp
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, assign) EditingMode editingModel;

@property (nonatomic, strong) CLToolBar *toolBar;

@property (nonatomic, weak) id<CLEditingVCDelegate> delegate;

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController;

@end
