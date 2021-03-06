//
//  CLAllItemsListVC.m
//  Mook
//
//  Created by 陈林 on 16/4/12.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLAllItemsListVC.h"

#import "CLNewEntryTool.h"
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
#import "CLGetMediaTool.h"

#import "BTNavigationDropdownMenu-Swift.h"
@class BTNavigationDropdownMenu;

//#import "CLListRefreshHeader.h"
//
//typedef enum {
//    kNewEntryModeText = 1,
//    kNewEntryModeMedia
//    
//} NewEntryMode;

@interface CLAllItemsListVC ()<SWTableViewCellDelegate, MBProgressHUDDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSMutableArray *allItems;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, strong) NSMutableArray *ideaObjModelList;
@property (nonatomic, strong) NSMutableArray *showModelList;
@property (nonatomic, strong) NSMutableArray *routineModelList;
@property (nonatomic, strong) NSMutableArray *sleightObjModelList;
@property (nonatomic, strong) NSMutableArray *propObjModelList;
@property (nonatomic, strong) NSMutableArray *linesObjModelList;

@property (nonatomic, strong) CLTableBackView *tableBackView;
@property (nonatomic, assign) EditingContentType editingContentType;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, copy) NSString *exportPath;


@property (strong, nonatomic) BTNavigationDropdownMenu *menu;

@end

@implementation CLAllItemsListVC

- (BTNavigationDropdownMenu *)menu {
    if (!_menu) {

        NSArray *items = [NSArray arrayWithObjects:NSLocalizedString(@"全部", nil),NSLocalizedString(@"演出", nil), NSLocalizedString(@"流程", nil), NSLocalizedString(@"想法", nil), NSLocalizedString(@"技巧", nil), NSLocalizedString(@"道具", nil), NSLocalizedString(@"台词", nil),  nil];
        _menu = [[BTNavigationDropdownMenu alloc] initWithNavigationController:self.navigationController containerView:self.navigationController.view title:items[0] items:items];

        self.listType = kListTypeAll;
        
        __weak typeof(self) weakself = self;

        [_menu setDidSelectItemAtIndexHandler:^(NSInteger index) {
            
            typeof(self) strongself = weakself;

            switch (index) {
                    
                case 0:
                    _listType = kListTypeAll;
                    break;
                case 1:
                    _listType = kListTypeShow;
                    break;
                case 2:
                    _listType = kListTypeRoutine;
                    break;
                case 3:
                    _listType = kListTypeIdea;
                    break;
                case 4:
                    _listType = kListTypeSleight;
                    break;
                case 5:
                    _listType = kListTypeProp;
                    break;
                case 6:
                    _listType = kListTypeLines;

                    break;
                    
                default:
                    break;
            }
            
            [strongself.tableView reloadData];
            
            if (_listType == kListTypeLines) {
                [strongself.navigationItem.rightBarButtonItems[1] setImage:[UIImage imageNamed:@"addAudio"]];
                
            } else {
                [strongself.navigationItem.rightBarButtonItems[1] setImage:[UIImage imageNamed:@"addMedia"]];
                
            }
            
            
            if ([strongself.tableView.dataSource tableView:strongself.tableView numberOfRowsInSection:0] > 0) {
                [strongself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                
            }

            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongself prepareVisibleCellsForAnimation];
                [strongself animateVisibleCells];
            });

        }];
        
        _menu.cellTextLabelColor = kTintColor;
        _menu.menuTitleColor = kTintColor;
        _menu.cellBackgroundColor = kAppThemeColor;
        _menu.cellSelectionColor = [UIColor whiteColor];
        _menu.cellSeparatorColor = [UIColor flatGrayColorDark];

    }
    return _menu;
}

#pragma mark - 模型数组懒加载
- (NSMutableArray *)allItems {
    _allItems = kDataListAll;
    return kDataListAll;
}

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

#pragma mark - 控制器生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView = self.tableBackView;
    self.tableView.backgroundColor = [UIColor flatWhiteColor];
    self.tableView.rowHeight = kListCellHeight;
    self.tableView.tableFooterView = [UIView new];
//    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    self.navigationItem.titleView = self.menu;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListImageCellID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateDataNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateMookNotification
                                               object:nil];
    
//    [self setRefreshHeader];
}

//- (void)setRefreshHeader {
//    
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    CLListRefreshHeader *header = [CLListRefreshHeader headerWithRefreshingBlock:^{
//        
//        [self.tableView.mj_header endRefreshing];
//    }];
//    
//    header.endRefreshingCompletionBlock = ^ () {
//        
//        [self showMenu];
//    };
//    
//    // 设置文字
//    [header setTitle:@"下拉可以切换笔记" forState:MJRefreshStateIdle];
//    [header setTitle:@"松开马上切换笔记" forState:MJRefreshStatePulling];
//    [header setTitle:@"" forState:MJRefreshStateRefreshing];
//    
//    // 设置字体
//    header.stateLabel.font = [UIFont systemFontOfSize:16];
//    
//    // 设置颜色
////    header.stateLabel.textColor = kAppThemeColor;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    
//    header.automaticallyChangeAlpha = YES;
//    
//    // 设置刷新控件
//    self.tableView.mj_header = header;
//}

//- (void)showMenu {
//    [self.tableView.mj_header endRefreshing];
//    [self.menu show];
//}


- (void)update:(NSNotification *)noti {
    if (noti.object == self) return;

    self.menu.cellBackgroundColor = kAppThemeColor;
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.addButton.hidden = NO;
//    self.mediaButton.hidden = (self.listType == kListTypeAll);

    [self.navigationController setToolbarHidden:YES];
    
//    [self prepareVisibleCellsForAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.menu hide];
}

#pragma mark - Private Cell的动画效果

- (void)prepareVisibleCellsForAnimation {
    
    NSArray *indexArr = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *topIndexPath = [indexArr firstObject];
    NSIndexPath *bottomIndexPath = [indexArr lastObject];
    
    for (NSInteger i = topIndexPath.row; i < bottomIndexPath.row+1; i++) {
        CLListImageCell * cell = (CLListImageCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        cell.frame = CGRectMake(-CGRectGetWidth(cell.bounds), cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
        cell.alpha = 0.f;
    }
}

- (void)animateVisibleCells {
    
    NSArray *indexArr = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *topIndexPath = [indexArr firstObject];
    NSIndexPath *bottomIndexPath = [indexArr lastObject];
    
    for (NSInteger i = topIndexPath.row; i < bottomIndexPath.row+1; i++) {
        CLListImageCell * cell = (CLListImageCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        cell.alpha = 1.f;
        [UIView animateWithDuration:0.15f
                              delay:(i-topIndexPath.row) * 0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.frame = CGRectMake(0.f, cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
                         }
                         completion:nil];
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
            number = self.allItems.count;
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

    id model;
    
    switch (self.listType) {
        case kListTypeAll:
    
            model = self.allItems[indexPath.row];
            break;
     
        case kListTypeIdea:
      
            model = self.ideaObjModelList[indexPath.row];
            break;
            
        case kListTypeShow:

            model = self.showModelList[indexPath.row];
            break;

        case kListTypeRoutine:

            model = self.routineModelList[indexPath.row];
            break;

        case kListTypeSleight:

            model = self.sleightObjModelList[indexPath.row];
            break;
  
        case kListTypeProp:

            model = self.propObjModelList[indexPath.row];
            break;
        case kListTypeLines:
            model = self.linesObjModelList[indexPath.row];
            break;
            
        default:
            break;
    }
    
    [cell setModel:model utilityButtons:[self rightButtons] delegate:self];
    
    cell.backgroundColor = [UIColor flatWhiteColor];
    
    return cell;
    
}

#pragma mark - SWTableViewCellDelegate

// 演出的右滑按钮,不含导出
- (NSArray *)showRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor flatRedColor] icon:[UIImage imageNamed:@"iconBin"]];
    
    return rightUtilityButtons;
}

// 其他笔记的右滑按钮,包含导出按钮
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor flatBlackColorDark] icon:[UIImage imageNamed:@"iconAction"]];
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
        if (self.listType == kListTypeAll) {
            id modelUnknown = self.allItems[path.row];
            if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
                [self delete:path];
            }else {
                
                [self exportWithIndexPath:path];
                
            }
        }
        
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

#pragma mark - 删除和导出笔记方法
// 删除笔记
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

- (void)deleteEntryWithIndexPath:(NSIndexPath *)path {
 
    switch (self.listType) {
        case kListTypeAll:
        {
            
            id modelUnknown = self.allItems[path.row];
            
            if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
                CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
                [CLDataSaveTool deleteIdea:model];
                
                [kAppDelegate reloadAllIdeas];
                
            } else if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
                CLShowModel *model = (CLShowModel *)modelUnknown;
                [CLDataSaveTool deleteShow:model];
                [kAppDelegate reloadAllShows];
                
            } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
                CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
                [CLDataSaveTool deleteRoutine:model];
                [kAppDelegate reloadAllRoutines];
                
            } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
                CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
                [CLDataSaveTool deleteSleight:model];
                [kAppDelegate reloadAllSleights];
 
            } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
                CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
                [CLDataSaveTool deleteProp:model];
                [kAppDelegate reloadAllProps];
                
            } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
                CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
                [CLDataSaveTool deleteLines:model];
                [kAppDelegate reloadAllLines];

            }
            
            [self.allItems removeObject:modelUnknown];
        }
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
    self.tableBackView.hidden = !(self.allItems.count == 0);
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

// 导出笔记
- (void)exportEntryWithIndexPath:(NSIndexPath *)indexPath importPassword:(NSString *)importPassword {
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
    [self.tabBarController.view addSubview:HUD];
    
    HUD.delegate = self;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        
        switch (self.listType) {
            case kListTypeAll:
            {
                id modelUnknown = self.allItems[indexPath.row];
                if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
                    CLIdeaObjModel *ideaObjModel = (CLIdeaObjModel *)modelUnknown;
                    
                    self.exportPath = [CLDataExportTool makeDataPackageWithIdea:ideaObjModel passWord:importPassword];
                    
                } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
                    CLRoutineModel *routineModel = (CLRoutineModel *)modelUnknown;
                    self.exportPath = [CLDataExportTool makeDataPackageWithRoutine:routineModel passWord:importPassword];
                    
                    
                } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
                    CLSleightObjModel *sleightObjModel = (CLSleightObjModel *)modelUnknown;
                    self.exportPath = [CLDataExportTool makeDataPackageWithSleight:sleightObjModel passWord:importPassword];
                    
                    
                } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
                    CLPropObjModel *propObjModel = (CLPropObjModel *)modelUnknown;
                    self.exportPath = [CLDataExportTool makeDataPackageWithProp:propObjModel passWord:importPassword];
                    
                    
                } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
                    CLLinesObjModel *linesObjModel = (CLLinesObjModel *)modelUnknown;
                    self.exportPath = [CLDataExportTool makeDataPackageWithLines:linesObjModel passWord:importPassword];
                    
                }
            }
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
    
    if (self.listType == kListTypeAll) {
        id modelUnknown = self.allItems[indexPath.row];
        if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
            [self performSegueWithIdentifier:kSegueHomeToShowSegue sender:indexPath];
        } else {
            
            [self performSegueWithIdentifier:kSegueHomeToContentSegue sender:indexPath];
        }
    } else if (self.listType == kListTypeShow) {
        
        [self performSegueWithIdentifier:kSegueHomeToShowSegue sender:indexPath];
        
    } else {
        
        [self performSegueWithIdentifier:kSegueHomeToContentSegue sender:indexPath];
    }
    

}

#pragma mark - segue跳转

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
                {
                    id modelUnknown = self.allItems[indexPath.row];
                    if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
                        CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
                        vc.contentType = kContentTypeIdea;
                        vc.ideaObjModel = model;
                        
                    } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
                        CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
                        vc.contentType = kContentTypeRoutine;
                        vc.routineModel = model;
                        
                    } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
                        CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
                        vc.contentType = kContentTypeSleight;
                        vc.sleightObjModel = model;
                        
                    } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
                        CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
                        vc.contentType = kContentTypeProp;
                        vc.propObjModel = model;
                        
                    } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
                        CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
                        vc.contentType = kContentTypeLines;
                        vc.linesObjModel = model;
                    }

                }
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
        
    } else if ([destVC isKindOfClass:[CLShowVC class]]) {
        CLShowVC *vc = (CLShowVC *)destVC;
        
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            CLShowModel *model;
            
            if (self.listType == kListTypeAll) {
                id modelUnknown = self.allItems[indexPath.row];
                if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
                    model = (CLShowModel *)modelUnknown;
                }
            } else if (self.listType == kListTypeShow) {
                model = self.showModelList[indexPath.row];
            }

            
            vc.showModel = model;
            vc.date = model.date;
        }
    }
    
}

#pragma mark - 新建笔记

- (IBAction)addNewEntry:(id)sender {

    [CLNewEntryTool addNewEntryWithEntryMode:kNewEntryModeText inViewController:self listType:self.listType];
}

- (IBAction)addNewEntryWithMedia {
    
    [CLNewEntryTool addNewEntryWithEntryMode:kNewEntryModeMedia inViewController:self listType:self.listType];
}


@end
