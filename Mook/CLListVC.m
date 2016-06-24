//
//  CLListvc.m
//  Mook
//
//  Created by 陈林 on 16/3/25.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLListVC.h"

#import "CLNewEntryTool.h"
#import "CLGetMediaTool.h"
#import "CLDataSaveTool.h"
#import "CLDataExportTool.h"
#import "CLNewEntryNavVC.h"
#import "CLNewShowNavVC.h"
#import "CLContentVC.h"
#import "CLShowVC.h"

#import "CLListCell.h"
#import "CLListImageCell.h"

#import "CLShowModel.h"
#import "CLIdeaObjModel.h"
#import "CLRoutineModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"

#import "CLInfoModel.h"
#import "CLEffectModel.h"
#import "CLPropModel.h"
#import "CLPrepModel.h"
#import "CLPerformModel.h"
//#import "CLNotesModel.h"

#import "CLTableBackView.h"

//#import "Masonry.h"
#import "CLAddView.h"
#import "Pop.h"

#import "BFPaperButton.h"

@interface CLListVC ()<SWTableViewCellDelegate, MBProgressHUDDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSMutableArray *tagList;

@property (nonatomic, strong) CLTableBackView *tableBackView;
@property (nonatomic, assign) EditingContentType editingContentType;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, copy) NSString *exportPath;


@property (strong, nonatomic) BFPaperButton *addButton;
@property (strong, nonatomic) BFPaperButton *mediaButton;

@property (strong, nonatomic) UIButton *coverButton;

@property (strong, nonatomic) CLAddView *addView;

@end

@implementation CLListVC


- (UIButton *)coverButton {
    if (!_coverButton) {
        _coverButton = [[UIButton alloc] initWithFrame:self.navigationController.view.frame];
        [self.navigationController.view addSubview:_coverButton];
        _coverButton.backgroundColor = [UIColor darkGrayColor];
        _coverButton.alpha = 0.0;
        _coverButton.enabled = NO;
        
        [_coverButton addTarget:self action:@selector(toggleAddView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}

- (BFPaperButton *)addButton {
    if (!_addButton) {
        _addButton = [[BFPaperButton alloc] initWithRaised:YES];
        [self.navigationController.view addSubview:_addButton];
        
        [_addButton addTarget:self action:@selector(addNewEntry:) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.navigationController.view.mas_right).with.offset(-10);
            make.bottom.equalTo(self.navigationController.view.mas_bottom).with.offset(-15);
            make.width.height.equalTo(@kAddButtonHeight);
        }];
        _addButton.cornerRadius = kAddButtonHeight/2;
        _addButton.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
        _addButton.alpha = 1.0f;
        
    }
    
    return _addButton;
}


- (BFPaperButton *)mediaButton {
    if (!_mediaButton) {
        _mediaButton = [[BFPaperButton alloc] initWithRaised:YES];
        [self.navigationController.view addSubview:_mediaButton];
        
        [_mediaButton addTarget:self action:@selector(addNewEntryWithMedia) forControlEvents:UIControlEventTouchUpInside];
        //        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        if (self.listType == kListTypeLines) {
            [_mediaButton setImage:[UIImage imageNamed:@"addAudio"] forState:UIControlStateNormal];
            
        } else {
            [_mediaButton setImage:[UIImage imageNamed:@"addMedia"] forState:UIControlStateNormal];
            
        }
        [_mediaButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.navigationController.view.mas_right).with.offset(-10);
            make.bottom.equalTo(self.addButton.mas_top).with.offset(-15);
            make.width.height.equalTo(@kAddButtonHeight);
        }];
        _mediaButton.cornerRadius = kAddButtonHeight/2;
        _mediaButton.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
        _mediaButton.alpha = 1.0f;
        _mediaButton.hidden = (self.listType == kListTypeAll);
        
        
    }
    
    return _mediaButton;
}

- (CLAddView *)addView {
    if (!_addView) {
        _addView = [[CLAddView alloc] initWithFrame:CGRectMake(self.addButton.center.x, self.addButton.center.y, 0, 0)];
        [self.navigationController.view addSubview:_addView];
        _addView.hidden = NO;
        
        [_addView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(self.navigationController.view.mas_width).offset( -kAddButtonHeight);
            make.height.equalTo(_addView.mas_width).multipliedBy(1.5);
            make.centerX.equalTo(self.navigationController.view);
            make.top.equalTo(self.navigationController.view.mas_bottom).offset(_addView.frame.size.height);
        }];
        _addView.center = CGPointMake(self.navigationController.view.center.x, CGRectGetMaxY(self.navigationController.view.frame)+self.addView.frame.size.height/2);
        
        _addView.backgroundColor = [UIColor clearColor];
        [_addView initSubViews];
        [_addView updateColor:self.addButton.backgroundColor];
        
        [_addView addTarget:self action:@selector(toggleAddView) forControlEvents:UIControlEventTouchUpInside];
        
        [_addView.ideaBtn addTarget:self action:@selector(addNewIdeaWithVideo:orImage:) forControlEvents:UIControlEventTouchUpInside];
        [_addView.showBtn addTarget:self action:@selector(addNewShowWithVideo:orImage:) forControlEvents:UIControlEventTouchUpInside];
        [_addView.routineBtn addTarget:self action:@selector(addNewRoutineWithVideo:orImage:) forControlEvents:UIControlEventTouchUpInside];
        [_addView.sleightBtn addTarget:self action:@selector(addNewSleightWithVideo:orImage:) forControlEvents:UIControlEventTouchUpInside];
        [_addView.propBtn addTarget:self action:@selector(addNewPropWithVideo:orImage:) forControlEvents:UIControlEventTouchUpInside];
        [_addView.linesBtn addTarget:self action:@selector(addNewLines) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addView;
}


#pragma mark - 模型数组懒加载

-(NSMutableArray *)ideaObjModelList {
    if (!_ideaObjModelList) _ideaObjModelList = kDataListIdea;
    return _ideaObjModelList;
}

- (NSMutableArray *)showModelList {
    if (!_showModelList) _showModelList = kDataListShow;
    return _showModelList;
}

- (NSMutableArray *)routineModelList {
    if (!_routineModelList)  _routineModelList = kDataListRoutine;
    return _routineModelList;
}

-(NSMutableArray *)sleightObjModelList {
    if (!_sleightObjModelList) _sleightObjModelList = kDataListSleight;
    return _sleightObjModelList;
}

- (NSMutableArray *)propObjModelList {
    if (!_propObjModelList)  _propObjModelList = kDataListProp;
    return _propObjModelList;
}

- (NSMutableArray *)linesObjModelList {
    if (!_linesObjModelList)  _linesObjModelList = kDataListLines;
    return _linesObjModelList;
}

#pragma mark - 背景view懒加载
- (CLTableBackView *)tableBackView {
    if (!_tableBackView) {
        _tableBackView = [CLTableBackView tableBackView];
    }
    return _tableBackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self coverButton];

    self.tableView.backgroundView = self.tableBackView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = kListCellHeight;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 96, 0);

    [self.tableView registerNib:[UINib nibWithNibName:@"CLListCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListImageCellID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeEntryIfWithTag:) name:kDeleteEntryNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeEntryIfWithTag:) name:kCancelEntryNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateDataNotification
                                               object:nil];
    
    [self addView];
    [self addButton];
    [self mediaButton];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.addButton.hidden = NO;
    self.mediaButton.hidden = (self.listType == kListTypeAll);
    
    [self.navigationController setToolbarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.addButton.hidden = YES;
    self.mediaButton.hidden = YES;
    if (self.addView.center.y == self.navigationController.view.center.y) {
        [self toggleAddView];
    }
}
- (void)toggleAddView {
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    
    //弹性值
    springAnimation.springBounciness = 10.0;
    //弹性速度
    springAnimation.springSpeed = 15.0;
    
    CGPoint point = self.addView.center;
    
    if (point.y == self.navigationController.view.center.y) {
        
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, CGRectGetMaxY(self.navigationController.view.frame)+self.addView.frame.size.height)];
        
        self.coverButton.enabled = NO;
        self.coverButton.alpha = 0.0;
        [self.addView pop_addAnimation:springAnimation forKey:@"changeposition"];
        
        [_addButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        
    }
    else{
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, self.navigationController.view.center.y)];
        [self.addView pop_addAnimation:springAnimation forKey:@"changeposition"];
        
        self.coverButton.enabled = YES;
        self.coverButton.alpha = 0.9;
        [_addButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    }
    
}


- (void)update:(NSNotification *)noti {
    if (noti.object == self) return;
    
    self.addButton.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
    self.mediaButton.backgroundColor = self.addButton.backgroundColor;
    
    if (self.navigationController.visibleViewController == self) {
        self.mediaButton.hidden = (self.listType == kListTypeAll);
        
    }
    
    if (self.listType == kListTypeLines) {
        [_mediaButton setImage:[UIImage imageNamed:@"addAudio"] forState:UIControlStateNormal];
        
    } else {
        [_mediaButton setImage:[UIImage imageNamed:@"addMedia"] forState:UIControlStateNormal];
        
    }
    
    [self.addView updateColor:self.addButton.backgroundColor];
    [self.tableView reloadData];
}

- (void)removeEntryIfWithTag:(NSNotification *)noti {
    if (self.tag == nil) return;
    
    if (noti.object == nil) {
//        NSLog(@"error : cancel object == nil");
        return;
    } else {
        id modelUnknown = noti.object;
        if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
            CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
            
            if (self.ideaObjModelList != kDataListIdea) {
                [self.ideaObjModelList removeObject:model];
            }
            
        } else if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
            CLShowModel *model = (CLShowModel *)modelUnknown;

            if (self.showModelList != kDataListShow) {
                [self.showModelList removeObject:model];
            }
            
        } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
            CLRoutineModel *model = (CLRoutineModel *)modelUnknown;

            if (self.routineModelList != kDataListRoutine) {
                [self.routineModelList removeObject:model];
            }
            
        } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
            CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;

            if (self.sleightObjModelList != kDataListSleight) {
                [self.sleightObjModelList removeObject:model];
            }
            
        } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
            CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
            
            if (self.propObjModelList != kDataListProp) {
                [self.propObjModelList removeObject:model];
            }

        } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
            CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
            
            if (self.linesObjModelList != kDataListLines) {
                [self.linesObjModelList removeObject:model];
            }
        }
        
//        NSLog(@"cancel entry sucess!");
    }

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger number;
    switch (self.listType) {
        case kListTypeAll:
            number = 0;
            break;
            
        case kListTypeIdea:
            number = self.ideaObjModelList.count;
            break;
            
        case kListTypeShow:
            number = self.showModelList.count;
            break;
            
        case kListTypeRoutine:
            number = self.routineModelList.count;
            break;
            
        case kListTypeSleight:
            number = self.sleightObjModelList.count;
            break;
            
        case kListTypeProp:
            number = self.propObjModelList.count;
            break;
            
        case kListTypeLines:
            number = self.linesObjModelList.count;
            break;
            
        default:
            break;
    }
    
    self.tableBackView.hidden = !(number == 0);
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
    
    switch (self.listType) {
        case kListTypeAll:
        {
            id modelUnknown = kDataListAll[indexPath.row];
            [cell setModel:modelUnknown utilityButtons:[self rightButtons] delegate:self];
            
            break;
        }
        case kListTypeIdea:
        {
            CLIdeaObjModel *model = self.ideaObjModelList[indexPath.row];
            [cell setModel:model utilityButtons:[self rightButtons] delegate:self];
            
            break;
        }
            
        case kListTypeShow:
        {
            CLShowModel *model = self.showModelList[indexPath.row];
            [cell setModel:model utilityButtons:[self rightButtons] delegate:self];
            
            break;
        }
        case kListTypeRoutine:
        {
            CLRoutineModel *model = self.routineModelList[indexPath.row];
            [cell setModel:model utilityButtons:[self rightButtons] delegate:self];
            
            break;
        }
        case kListTypeSleight:
        {
            CLSleightObjModel *model = self.sleightObjModelList[indexPath.row];
            [cell setModel:model utilityButtons:[self rightButtons] delegate:self];
            
            break;
        }
            
            
        case kListTypeProp:
        {
            CLPropObjModel *model = self.propObjModelList[indexPath.row];
            [cell setModel:model utilityButtons:[self rightButtons] delegate:self];
            
            break;
        }
        case kListTypeLines:
        {
            CLLinesObjModel *model = self.linesObjModelList[indexPath.row];
            [cell setModel:model utilityButtons:[self rightButtons] delegate:self];
            break;
        }
        default:
            break;
    }
    
    return cell;
    
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];

    if (self.listType != kListTypeShow) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor flatGrayColorDark] icon:[UIImage imageNamed:@"iconAction"]];
    }
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor flatRedColor] icon:[UIImage imageNamed:@"iconBin"]];

    return rightUtilityButtons;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    if (index == 0) {
        
        if (self.listType == kListTypeShow) {
            // 演讲不可导出,所以只有删除按钮
            [self delete:path];
        } else {
            // 如果不是演讲, 则可导出
            [self exportWithIndexPath:path];

        }
        
    } else if (index == 1) {
        
        [self delete:path];
    }
    
    [cell hideUtilityButtonsAnimated:YES];
}

- (void)delete:(NSIndexPath *)path {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"提示: 删除内容后将无法恢复,确定要删除当前内容吗?", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self deleteEntryWithIndexPath:path];
            
        });
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    

}

- (void) deleteEntryWithIndexPath:(NSIndexPath *)path {
    switch (self.listType) {
        case kListTypeAll:
            break;
        
        case kListTypeIdea:
        {
            CLIdeaObjModel *model = self.ideaObjModelList[path.row];
            
            [CLDataSaveTool deleteIdea:model];
            [kAppDelegate reloadAllItems];
            
            [self.ideaObjModelList removeObject:model];

            if (self.tag) {
                [kAppDelegate reloadAllIdeas];

            }
            
            self.tableBackView.hidden = !(self.ideaObjModelList.count == 0);
            
            break;
        }
        case kListTypeShow:
        {
            CLShowModel *model = self.showModelList[path.row];
            
            [CLDataSaveTool deleteShow:model];
            [kAppDelegate reloadAllItems];

            [self.showModelList removeObject:model];
            
            if (self.tag) {
                [kAppDelegate reloadAllShows];
                
            }
            self.tableBackView.hidden = !(self.showModelList.count == 0);

            break;
        }
            
        case kListTypeRoutine:
        {
            CLRoutineModel *model = self.routineModelList[path.row];
            
            [CLDataSaveTool deleteRoutine:model];
            [kAppDelegate reloadAllItems];

            [self.routineModelList removeObject:model];
            
            if (self.tag) {
                [kAppDelegate reloadAllRoutines];
                
            }
            self.tableBackView.hidden = !(self.routineModelList.count == 0);

            break;
        }
        case kListTypeSleight:
        {
            CLSleightObjModel *model = self.sleightObjModelList[path.row];
            
            [CLDataSaveTool deleteSleight:model];
            [kAppDelegate reloadAllItems];
            [self.sleightObjModelList removeObject:model];

            if (self.tag) {
                [kAppDelegate reloadAllSleights];
                
            }
            self.tableBackView.hidden = !(self.sleightObjModelList.count == 0);
            
            break;
        }
            
        case kListTypeProp:
        {
            CLPropObjModel *model = self.propObjModelList[path.row];
            
            [CLDataSaveTool deleteProp:model];
            [kAppDelegate reloadAllItems];
            [self.propObjModelList removeObject:model];
            
            if (self.tag) {
                [kAppDelegate reloadAllProps];
                
            }
            self.tableBackView.hidden = !(self.propObjModelList.count == 0);
            
            break;
        }
        case kListTypeLines:
        {
            CLLinesObjModel *model = self.linesObjModelList[path.row];
            
            [CLDataSaveTool deleteLines:model];
            [kAppDelegate reloadAllItems];
            [self.linesObjModelList removeObject:model];
            
            if (self.tag) {
                [kAppDelegate reloadAllLines];
                
            }
            self.tableBackView.hidden = !(self.linesObjModelList.count == 0);
            
            break;
        }
            
        default:
            break;
    }
    
    [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];

    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:self];

}

// 导出笔记 (选择是否密码导出)
- (void)exportWithIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"导出笔记", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* exportWithPassword = [UIAlertAction actionWithTitle:NSLocalizedString(@"密码导出", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self passwordExportWithIndexPath:indexPath];
        
    }];
    
    UIAlertAction* exportWithoutPassword = [UIAlertAction actionWithTitle:NSLocalizedString(@"直接导出", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self exportEntryWithIndexPath:indexPath importPassword:@""];
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:exportWithPassword];
    [alert addAction:exportWithoutPassword];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

// 密码导出
- (void)passwordExportWithIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"设置导出密码", nil) message:NSLocalizedString(@"请输入笔记密码", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"导出密码", nil);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.font = kFontSys16;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"导出", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *passwordTF = alertController.textFields.firstObject;
        
        NSString *exportPassword = passwordTF.text;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
        [self exportEntryWithIndexPath:indexPath importPassword:exportPassword];
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        UITextField *passwordTF = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = passwordTF.text.length > 0;
    }];
    
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *nameTF = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = nameTF.text.length > 0;
    }
}

- (void)exportEntryWithIndexPath:(NSIndexPath *)indexPath importPassword:(NSString *)importPassword {
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
    [self.tabBarController.view addSubview:HUD];
    
    HUD.delegate = self;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        
        switch (self.listType) {
            case kListTypeAll:
                break;
                
            case kListTypeIdea:
            {
                CLIdeaObjModel *ideaObjModel = self.ideaObjModelList[indexPath.row];
                
                self.exportPath = [CLDataExportTool makeDataPackageWithIdea:ideaObjModel passWord:importPassword];
                break;
            }
            case kListTypeShow:
                break;
                
            case kListTypeRoutine:
            {
                CLRoutineModel *routineModel = self.routineModelList[indexPath.row];
                self.exportPath = [CLDataExportTool makeDataPackageWithRoutine:routineModel passWord:importPassword];
                break;
            }
            case kListTypeSleight:
            {
                CLSleightObjModel *sleightObjModel = self.sleightObjModelList[indexPath.row];
                self.exportPath = [CLDataExportTool makeDataPackageWithSleight:sleightObjModel passWord:importPassword];
                
                break;
            }
                
            case kListTypeProp:
            {
                CLPropObjModel *propObjModel = self.propObjModelList[indexPath.row];
                self.exportPath = [CLDataExportTool makeDataPackageWithProp:propObjModel passWord:importPassword];
                
                break;
            }
            case kListTypeLines:
            {
                CLLinesObjModel *linesObjModel = self.linesObjModelList[indexPath.row];
                self.exportPath = [CLDataExportTool makeDataPackageWithLines:linesObjModel passWord:importPassword];
                break;
            }
                
            default:
                break;
        }
        
    } onQueue:dispatch_get_main_queue() completionBlock:^{
        
        if (self.exportPath != nil) {
            NSURL *dataUrl;
            dataUrl = [NSURL fileURLWithPath:self.exportPath];
            
            CGRect navRect = self.view.frame;
            self.documentInteractionController =[UIDocumentInteractionController interactionControllerWithURL:dataUrl];
            self.documentInteractionController.delegate = self;
            
            [self.documentInteractionController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
        } else {
            
            [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"导出失败", nil) hideAfterDelay:1.0];
        }
    }];
    
}


#pragma mark - UIDocumentInteractionControllerDelegate

//===================================================================
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}


#pragma mark 选中cell跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.listType == kListTypeShow) {

        [self performSegueWithIdentifier:kSegueListToShow sender:indexPath];
        
    } else {
        
        [self performSegueWithIdentifier:kSegueListToContent sender:indexPath];
    }
}

#pragma mark - segue方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    UIViewController *vc = (UIViewController *)destVC;
    vc.hidesBottomBarWhenPushed = YES;
    
    if ([destVC isKindOfClass:[CLContentVC class]]) {
        CLContentVC *vc = (CLContentVC *)destVC;
        
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;

            switch (self.listType) {
                case kListTypeAll:
                    break;
                    
                case kListTypeIdea:
                {
                    CLIdeaObjModel *model = self.ideaObjModelList[indexPath.row];
                    vc.contentType = kContentTypeIdea;
                    vc.ideaObjModel = model;
                    break;
                }

                case kListTypeRoutine:
                {
                    CLRoutineModel *model = self.routineModelList[indexPath.row];
                    vc.contentType = kContentTypeRoutine;
                    vc.routineModel = model;
                    break;
                }
                case kListTypeSleight:
                {
                    CLSleightObjModel *model = self.sleightObjModelList[indexPath.row];
                    vc.contentType = kContentTypeSleight;
                    vc.sleightObjModel = model;
                    break;
                }
                    
                    
                case kListTypeProp:
                {
                    CLPropObjModel *model = self.propObjModelList[indexPath.row];
                    vc.contentType = kContentTypeProp;
                    vc.propObjModel = model;
                    break;
                }
                case kListTypeLines:
                {
                    CLLinesObjModel *model = self.linesObjModelList[indexPath.row];
                    vc.contentType = kContentTypeLines;
                    vc.linesObjModel = model;
                    break;
                }

                default:
                    break;
            }
        }
        
    } else if ([destVC isKindOfClass:[CLNewEntryNavVC class]]) {
        CLNewEntryNavVC *vc = (CLNewEntryNavVC *)destVC;
        
        vc.editingContentType = self.editingContentType;
        
        if (self.editingContentType == kEditingContentTypeIdea) {
            vc.ideaObjModel = kDataListIdea[0];
        } else if (self.editingContentType == kEditingContentTypeRoutine) {
            vc.routineModel = kDataListRoutine[0];
        } else if (self.editingContentType == kEditingContentTypeSleight) {
            vc.sleightObjModel = kDataListSleight[0];
        } else if (self.editingContentType == kEditingContentTypeProp) {
            vc.propObjModel = kDataListProp[0];
        } else if (self.editingContentType == kEditingContentTypeLines) {
            vc.linesObjModel = kDataListLines[0];
        }
        
    } else if ([destVC isKindOfClass:[CLNewShowNavVC class]]) {
        CLNewShowNavVC *vc = (CLNewShowNavVC *)destVC;
        vc.showModel = kDataListShow[0];
        
    } else if ([destVC isKindOfClass:[CLShowVC class]]) {
        CLShowVC *vc = (CLShowVC *)destVC;
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            CLShowModel *model;
            
            if (self.listType == kListTypeShow) {
                model = self.showModelList[indexPath.row];
            }
            
            vc.showModel = model;
            vc.date = model.date;
        }
    }

}

- (IBAction)addNewEntry:(id)sender {
    
    switch (self.listType) {
        case kListTypeAll:
            
            break;
            
        case kListTypeIdea:
            [self addNewIdeaWithVideo:nil orImage:nil];
            break;
          
        case kListTypeShow:
            [self addNewShowWithVideo:nil orImage:nil];
            break;
            
        case kListTypeRoutine:
            [self addNewRoutineWithVideo:nil orImage:nil];
            break;
            
        case kListTypeSleight:
            [self addNewSleightWithVideo:nil orImage:nil];
            break;
            
        case kListTypeProp:
            [self addNewPropWithVideo:nil orImage:nil];
            break;
            
        case kListTypeLines:
            [self addNewLines];
            break;
          
        default:
            break;
    }

    if ([self.tableView numberOfRowsInSection:0] > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

    }
    
}


- (void)addNewEntryWithMedia {
    
    
    switch (self.listType) {
        case kListTypeAll:
            break;
            
        case kListTypeIdea:
            [self addNewIdeaWithVideo];
            break;
            
        case kListTypeShow:
            [self addNewShowWithVideo];
            break;
            
        case kListTypeRoutine:
            [self addNewRoutineWithVideo];
            break;
            
        case kListTypeSleight:
            [self addNewSleightWithVideo];
            break;
            
        case kListTypeProp:
            [self addNewPropWithVideo];
            break;
            
        case kListTypeLines:
            [self addNewLinesWithAudio];
            break;
            
        default:
            break;
    }
}

- (void)addNewLinesWithAudio {
    [[CLGetMediaTool getInstance] recordAudioFromCurrentController:self audioBlock:^(NSString *filePath) {
        
        [self addNewLinesWithAudio:filePath];
    }];
}

- (void)addNewLinesWithAudio:(NSString *)filePath {
    self.editingContentType = kEditingContentTypeLines;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLLinesObjModel *model = [CLLinesObjModel linesObjModel];
    
    NSString *audioName = [kTimestamp stringByAppendingString:@".m4a"];
    [audioName saveNamedAudioToDocument:filePath];
    model.effectModel.audio = audioName;
    [CLDataSaveTool addAudioByName:audioName timesStamp:model.timeStamp content:nil type:kTypeLines];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListLines insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.linesObjModelList != kDataListLines) {
        [model.tags addObject:self.tag];
        [self.linesObjModelList insertObject:model atIndex:0];
    }
    
    [CLNewEntryTool showAlertControllerWithTextFieldFromCurrentController:self comfirmHandler:^(NSString * _Nullable title) {
        model.infoModel.name = title;
        [CLDataSaveTool updateLines:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:nil];
    } editMoreHandler:^(NSString * _Nullable title) {
        model.infoModel.name = title;
        
        [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];

    }];
    
}

- (void)addNewShowWithVideo {
    
    [[CLGetMediaTool getInstance] loadCameraFromCurrentViewController:self maximumDuration:600.0 completion:^(NSURL *videoURL, UIImage *photo) {
        [self addNewShowWithVideo:videoURL orImage:photo];
    }];
}


- (void)addNewIdeaWithVideo {
    
    [[CLGetMediaTool getInstance] loadCameraFromCurrentViewController:self maximumDuration:30.0 completion:^(NSURL *videoURL, UIImage *photo) {
        [self addNewIdeaWithVideo:videoURL orImage:photo];
    }];
}

- (void)addNewRoutineWithVideo {
    
    [[CLGetMediaTool getInstance] loadCameraFromCurrentViewController:self maximumDuration:180.0 completion:^(NSURL *videoURL, UIImage *photo) {
        [self addNewRoutineWithVideo:videoURL orImage:photo];
    }];
}

- (void)addNewSleightWithVideo {
    
    [[CLGetMediaTool getInstance] loadCameraFromCurrentViewController:self maximumDuration:30.0 completion:^(NSURL *videoURL, UIImage *photo) {
        [self addNewSleightWithVideo:videoURL orImage:photo];
    }];
}

- (void)addNewPropWithVideo {
    
    [[CLGetMediaTool getInstance] loadCameraFromCurrentViewController:self maximumDuration:30.0 completion:^(NSURL *videoURL, UIImage *photo) {
        [self addNewPropWithVideo:videoURL orImage:photo];
        
    }];
}

- (void)addNewIdeaWithVideo:videoURL orImage:image {
    self.editingContentType = kEditingContentTypeIdea;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLIdeaObjModel *model = [CLIdeaObjModel ideaObjModel];
    if (videoURL) {
        NSString *videoName = [kTimestamp stringByAppendingString:@".mp4"];
        [videoName saveNamedVideoToDocument:videoURL];
        
        model.effectModel.video = videoName;
        [CLDataSaveTool addVideoByName:videoName timesStamp:model.timeStamp content:nil type:kTypeIdea];
    } else if (image) {
        NSString *imageName = [kTimestamp stringByAppendingString:@".jpg"];
        [imageName saveNamedImageToDocument:image];
        
        model.effectModel.image = imageName;
        [CLDataSaveTool addImageByName:imageName timesStamp:model.timeStamp content:nil type:kTypeIdea];
    }
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListIdea insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.ideaObjModelList != kDataListIdea) {
        [model.tags addObject:self.tag];
        [self.ideaObjModelList insertObject:model atIndex:0];
    }
    
    [CLNewEntryTool showAlertControllerWithTextFieldFromCurrentController:self comfirmHandler:^(NSString * _Nullable title) {
        model.infoModel.name = title;
        [CLDataSaveTool updateIdea:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:nil];
    } editMoreHandler:^(NSString * _Nullable title) {
        model.infoModel.name = title;
        
        [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
        
    }];
}

- (void)addNewShowWithVideo:videoURL orImage:image {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLShowModel *model = [CLShowModel showModel];
    if (videoURL) {
        NSString *videoName = [kTimestamp stringByAppendingString:@".mp4"];
        [videoName saveNamedVideoToDocument:videoURL];
        
        model.effectModel.video = videoName;
        [CLDataSaveTool addVideoByName:videoName timesStamp:model.timeStamp content:nil type:kTypeShow];
    } else if (image) {
        NSString *imageName = [kTimestamp stringByAppendingString:@".jpg"];
        [imageName saveNamedImageToDocument:image];
        
        model.effectModel.image = imageName;
        [CLDataSaveTool addImageByName:imageName timesStamp:model.timeStamp content:nil type:kTypeShow];
    }
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListShow insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.showModelList != kDataListShow) {
        [model.tags addObject:self.tag];
        [self.showModelList insertObject:model atIndex:0];
    }
    
    [CLNewEntryTool showAlertControllerWithTextFieldFromCurrentController:self comfirmHandler:^(NSString * _Nullable title) {
        model.name = title;
        [CLDataSaveTool updateShow:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:nil];
    } editMoreHandler:^(NSString * _Nullable title) {
        model.name = title;
        
        [self performSegueWithIdentifier:kSegueListToNewShow sender:nil];
        
    }];
}

- (void)addNewRoutineWithVideo:videoURL orImage:image {
    
    self.editingContentType = kEditingContentTypeRoutine;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLRoutineModel *model = [CLRoutineModel routineModel];
    if (videoURL) {
        NSString *videoName = [kTimestamp stringByAppendingString:@".mp4"];
        [videoName saveNamedVideoToDocument:videoURL];
        
        model.effectModel.video = videoName;
        [CLDataSaveTool addVideoByName:videoName timesStamp:model.timeStamp content:nil type:kTypeRoutine];
    } else if (image) {
        NSString *imageName = [kTimestamp stringByAppendingString:@".jpg"];
        [imageName saveNamedImageToDocument:image];
        
        model.effectModel.image = imageName;
        [CLDataSaveTool addImageByName:imageName timesStamp:model.timeStamp content:nil type:kTypeRoutine];
    }
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListRoutine insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];

    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.routineModelList != kDataListRoutine) {
        [model.tags addObject:self.tag];
        [self.routineModelList insertObject:model atIndex:0];
    }
    
    [CLNewEntryTool showAlertControllerWithTextFieldFromCurrentController:self comfirmHandler:^(NSString * _Nullable title) {
        model.infoModel.name = title;
        [CLDataSaveTool updateRoutine:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:nil];
    } editMoreHandler:^(NSString * _Nullable title) {
        model.infoModel.name = title;
        
        [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
        
    }];
}

- (void)addNewSleightWithVideo:videoURL orImage:image {
    self.editingContentType = kEditingContentTypeSleight;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLSleightObjModel *model = [CLSleightObjModel sleightObjModel];
    if (videoURL) {
        NSString *videoName = [kTimestamp stringByAppendingString:@".mp4"];
        [videoName saveNamedVideoToDocument:videoURL];
        
        model.effectModel.video = videoName;
        [CLDataSaveTool addVideoByName:videoName timesStamp:model.timeStamp content:nil type:kTypeSleight];
    } else if (image) {
        NSString *imageName = [kTimestamp stringByAppendingString:@".jpg"];
        [imageName saveNamedImageToDocument:image];
        
        model.effectModel.image = imageName;
        [CLDataSaveTool addImageByName:imageName timesStamp:model.timeStamp content:nil type:kTypeSleight];
    }

    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListSleight insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];

    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到sleightModelList中
    if (self.tag.length > 0 && self.sleightObjModelList != kDataListSleight) {
        [model.tags addObject:self.tag];
        [self.sleightObjModelList insertObject:model atIndex:0];
    }
    
    [CLNewEntryTool showAlertControllerWithTextFieldFromCurrentController:self comfirmHandler:^(NSString * _Nullable title) {
        model.infoModel.name = title;
        [CLDataSaveTool updateSleight:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:nil];
    } editMoreHandler:^(NSString * _Nullable title) {
        model.infoModel.name = title;
        
        [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
        
    }];
}

- (void)addNewPropWithVideo:videoURL orImage:image {
    self.editingContentType = kEditingContentTypeProp;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLPropObjModel *model = [CLPropObjModel propObjModel];
    if (videoURL) {
        NSString *videoName = [kTimestamp stringByAppendingString:@".mp4"];
        [videoName saveNamedVideoToDocument:videoURL];
        
        model.effectModel.video = videoName;
        [CLDataSaveTool addVideoByName:videoName timesStamp:model.timeStamp content:nil type:kTypeProp];
    }  else if (image) {
        NSString *imageName = [kTimestamp stringByAppendingString:@".jpg"];
        [imageName saveNamedImageToDocument:image];
        
        model.effectModel.image = imageName;
        [CLDataSaveTool addImageByName:imageName timesStamp:model.timeStamp content:nil type:kTypeProp];
    }
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListProp insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];

    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.propObjModelList != kDataListProp) {
        [model.tags addObject:self.tag];
        [self.propObjModelList insertObject:model atIndex:0];
    }
    
    [CLNewEntryTool showAlertControllerWithTextFieldFromCurrentController:self comfirmHandler:^(NSString * _Nullable title) {
        model.infoModel.name = title;
        [CLDataSaveTool updateProp:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:nil];
    } editMoreHandler:^(NSString * _Nullable title) {
        model.infoModel.name = title;
        
        [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
        
    }];
}

- (void)addNewLines {
    self.editingContentType = kEditingContentTypeLines;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLLinesObjModel *model = [CLLinesObjModel linesObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListLines insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];

    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.linesObjModelList != kDataListLines) {
        [model.tags addObject:self.tag];
        [self.linesObjModelList insertObject:model atIndex:0];
    }
    
    [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
}


@end
