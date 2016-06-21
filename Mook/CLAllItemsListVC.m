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
#import "CLListTextCell.h"
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

#import "Masonry.h"
#import "CLAddView.h"
#import "Pop.h"
#import "BTNavigationDropdownMenu-Swift.h"
@class BTNavigationDropdownMenu;

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

@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *coverButton;

@property (strong, nonatomic) BTNavigationDropdownMenu *menu;

@property (strong, nonatomic) CLAddView *addView;

@end

@implementation CLAllItemsListVC

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

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.navigationController.view addSubview:_addButton];
        
        [_addButton addTarget:self action:@selector(addNewEntry:) forControlEvents:UIControlEventTouchUpInside];
//        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.navigationController.view.mas_right).with.offset(-15);
            make.bottom.equalTo(self.navigationController.view.mas_bottom).with.offset(-64);
            make.width.height.equalTo(@kAddButtonHeight);
        }];
        _addButton.layer.cornerRadius = kAddButtonHeight/2;
        _addButton.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
        _addButton.alpha = 1.0f;
        
    }
    
    return _addButton;
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
        
        [_addView.ideaBtn addTarget:self action:@selector(addNewIdea) forControlEvents:UIControlEventTouchUpInside];
        [_addView.showBtn addTarget:self action:@selector(addNewShow) forControlEvents:UIControlEventTouchUpInside];
        [_addView.routineBtn addTarget:self action:@selector(addNewRoutine) forControlEvents:UIControlEventTouchUpInside];
        [_addView.sleightBtn addTarget:self action:@selector(addNewSleight) forControlEvents:UIControlEventTouchUpInside];
        [_addView.propBtn addTarget:self action:@selector(addNewProp) forControlEvents:UIControlEventTouchUpInside];
        [_addView.linesBtn addTarget:self action:@selector(addNewLines) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addView;
}

- (BTNavigationDropdownMenu *)menu {
    if (!_menu) {

        NSArray *items = [NSArray arrayWithObjects:NSLocalizedString(@"演出", nil), NSLocalizedString(@"流程", nil), NSLocalizedString(@"灵感", nil), NSLocalizedString(@"技巧", nil), NSLocalizedString(@"道具", nil), NSLocalizedString(@"台词", nil), NSLocalizedString(@"全部", nil), nil];
        _menu = [[BTNavigationDropdownMenu alloc] initWithTitle:items[1] items:items];
        self.listType = kListTypeRoutine;
        [_menu setDidSelectItemAtIndexHandler:^(NSInteger index) {
            switch (index) {
                case 0:
                    _listType = kListTypeShow;
                    break;
                case 1:
                    _listType = kListTypeRoutine;
                    break;
                case 2:
                    _listType = kListTypeIdea;
                    break;
                case 3:
                    _listType = kListTypeSleight;
                    break;
                case 4:
                    _listType = kListTypeProp;
                    break;
                case 5:
                    _listType = kListTypeLines;
                    break;
                case 6:
                    _listType = kListTypeAll;
                    break;
                    
                default:
                    break;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:nil];
        }];
        
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self coverButton];
    self.tableView.backgroundView = self.tableBackView;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = kListCellHeight;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 96, 0);
    
    self.navigationItem.titleView = self.menu;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListImageCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListTextCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListTextCellID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateDataNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateMookNotification
                                               object:nil];
    
    [self addView];
    [self addButton];

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
    self.menu.cellBackgroundColor = kAppThemeColor;
    [self.addView updateColor:self.addButton.backgroundColor];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.addButton.hidden = NO;
    [self.navigationController setToolbarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.addButton.hidden = YES;
    [self.menu hide];
    if (self.addView.center.y == self.navigationController.view.center.y) {
        [self toggleAddView];
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
    
    NSString *iconName, *title;
    UIImage *image;
    NSAttributedString *contentWithType, *content;
 
    switch (self.listType) {
        case kListTypeAll:
        {
            id modelUnknown = self.allItems[indexPath.row];
            
            if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
                CLShowModel *model = (CLShowModel *)modelUnknown;
                image = [model getThumbnail];
                iconName = kIconNameShow;
                title = [model getTitle];
                contentWithType = [model getContentWithType];
                if (image != nil) { // 如果返回图片,则表示模型中有图片或多媒体
                    CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
                    cell.iconView.image = image;
                    cell.iconName = title;
                    
                    
                    [cell setTitle:title content:contentWithType];
                    
                    cell.rightUtilityButtons = [self showRightButtons];
                    cell.delegate = self;
                    cell.backgroundColor = [UIColor flatWhiteColor];
                    
                    return cell;
                    
                } else {
                    CLListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kListTextCellID forIndexPath:indexPath];
                    cell.iconName = title;
                    
                    [cell setTitle:title content:contentWithType];
                    
                    cell.rightUtilityButtons = [self showRightButtons];
                    cell.delegate = self;
                    cell.backgroundColor = [UIColor flatWhiteColor];
                    
                    return cell;
                }
                
            } else if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
                CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
                image = [model getThumbnail];
                iconName = kIconNameIdea;
                title = [model getTitle];
                contentWithType = [model getContentWithType];
            } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
                CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
                image = [model getThumbnail];
                iconName = kIconNameRoutine;
                title = [model getTitle];
                contentWithType = [model getContentWithType];
            } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
                CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
                image = [model getThumbnail];
                iconName = kIconNameSleight;
                title = [model getTitle];
                contentWithType = [model getContentWithType];
            } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
                CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
                image = [model getThumbnail];
                iconName = kIconNameProp;
                title = [model getTitle];
                contentWithType = [model getContentWithType];
            } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
                CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
                iconName = kIconNameLines;
                title = [model getTitle];
                contentWithType = [model getContentWithType];
            }
            
            if (image != nil) { // 如果返回图片,则表示模型中有图片或多媒体
                CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
                cell.iconView.image = image;
                cell.iconName = title;
                [cell setTitle:title content:contentWithType];
                
                cell.rightUtilityButtons = [self rightButtons];
                cell.delegate = self;
                cell.backgroundColor = [UIColor flatWhiteColor];
                
                return cell;
                
            } else {
                CLListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kListTextCellID forIndexPath:indexPath];
                cell.iconName = title;
                [cell setTitle:title content:contentWithType];
                
                cell.rightUtilityButtons = [self rightButtons];
                cell.delegate = self;
                cell.backgroundColor = [UIColor flatWhiteColor];
                
                return cell;
            }

            break;
        }
        case kListTypeIdea:
        {
            CLIdeaObjModel *model = self.ideaObjModelList[indexPath.row];
            image = [model getThumbnail];
            iconName = kIconNameIdea;
            title = [model getTitle];
            content = [model getContent];
            break;
        }
            
        case kListTypeShow:
        {
            CLShowModel *model = self.showModelList[indexPath.row];
            image = [model getThumbnail];
            iconName = kIconNameShow;
            title = [model getTitle];
            content = [model getContent];
            
            break;
        }
        case kListTypeRoutine:
        {
            CLRoutineModel *model = self.routineModelList[indexPath.row];
            image = [model getThumbnail];
            iconName = kIconNameRoutine;
            title = [model getTitle];
            content = [model getContent];
            break;
        }
        case kListTypeSleight:
        {
            CLSleightObjModel *model = self.sleightObjModelList[indexPath.row];
            image = [model getThumbnail];
            iconName = kIconNameSleight;
            title = [model getTitle];
            content = [model getContent];
            break;
        }
            
            
        case kListTypeProp:
        {
            CLPropObjModel *model = self.propObjModelList[indexPath.row];
            image = [model getThumbnail];
            iconName = kIconNameProp;
            title = [model getTitle];
            content = [model getContent];
            break;
        }
        case kListTypeLines:
        {
            CLLinesObjModel *model = self.linesObjModelList[indexPath.row];
            iconName = kIconNameLines;
            title = [model getTitle];
            content = [model getContent];
            break;
        }
        default:
            break;
    }
    
    if (image != nil) { // 如果返回图片,则表示模型中有图片或多媒体
        CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
        cell.iconView.image = image;
        cell.iconName = title;
        [cell setTitle:title content:content];
        
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        cell.backgroundColor = [UIColor flatWhiteColor];
        
        return cell;
        
    } else {
        CLListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kListTextCellID forIndexPath:indexPath];
        cell.iconName = title;
        [cell setTitle:title content:content];
        
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        cell.backgroundColor = [UIColor flatWhiteColor];
        
        return cell;
    }
    
    return nil;
    
}

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
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor flatGrayColorDark] icon:[UIImage imageNamed:@"iconAction"]];
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
                
                NSLog(@"%lu, %lu", (unsigned long)kDataListAll.count, (unsigned long)kDataListIdea.count);
                
                [kAppDelegate reloadAllIdeas];
                
                //        [kDataListIdea removeObject:model];
                //        [kDataListAll removeObject:model];
                
                NSLog(@"%lu, %lu", (unsigned long)kDataListAll.count, (unsigned long)kDataListIdea.count);
                
            } else if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
                CLShowModel *model = (CLShowModel *)modelUnknown;
                [CLDataSaveTool deleteShow:model];
                [kAppDelegate reloadAllShows];
                
                //        [kDataListShow removeObject:model];
                //        [kDataListAll removeObject:model];
                
            } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
                CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
                [CLDataSaveTool deleteRoutine:model];
                [kAppDelegate reloadAllRoutines];
                
                //        [kDataListRoutine removeObject:model];
                //        [kDataListAll removeObject:model];
                
            } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
                CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
                [CLDataSaveTool deleteSleight:model];
                [kAppDelegate reloadAllSleights];
                
                //        [kDataListSleight removeObject:model];
                //        [kDataListAll removeObject:model];
                
                
            } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
                CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
                [CLDataSaveTool deleteProp:model];
                [kAppDelegate reloadAllProps];
                
                //        [kDataListProp removeObject:model];
                //        [kDataListAll removeObject:model];
                
            } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
                CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
                [CLDataSaveTool deleteLines:model];
                [kAppDelegate reloadAllLines];
                
                //        [kDataListLines removeObject:model];
                //        [kDataListAll removeObject:model];
                
                
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
            
            id modelUnknown = self.allItems[indexPath.row];
            if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
                model = (CLShowModel *)modelUnknown;
            }
            
            vc.showModel = model;
            vc.date = model.date;
        }
    }
    
}

#pragma mark - 新建笔记方法

- (void)addNewEntry:(id)sender {

    switch (self.listType) {
        case kListTypeAll:
            [self addNewEntry];
            break;
            
        case kListTypeIdea:
            [self addNewIdea];
            break;
            
        case kListTypeShow:
            [self addNewShow];
            break;
            
        case kListTypeRoutine:
            [self addNewRoutine];
            break;
            
        case kListTypeSleight:
            [self addNewSleight];
            break;
            
        case kListTypeProp:
            [self addNewProp];
            break;
            
        case kListTypeLines:
            [self addNewLines];
            break;
            
        default:
            break;
    }
    
    if (self.listType == kListTypeAll) {
        return;
    }
//    滚动到第一行
//    if ([self.tableView numberOfRowsInSection:0] > 0) {
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        
//    }
    
}


- (void)addNewEntry {
    
    [self toggleAddView];
}

- (void)addNewIdeaWithVideo {
    
    [[CLGetMediaTool getInstance] recordVideoFromCurrentController:self maximumDuration:30.0 resultBlock:^(NSURL *videoURL) {
        
        [CLNewEntryTool addNewIdeaFromCurrentController:self withVideo:videoURL];
    }];
}

- (void)addNewRoutineWithVideo {
    
    [[CLGetMediaTool getInstance] recordVideoFromCurrentController:self maximumDuration:30.0 resultBlock:^(NSURL *videoURL) {
        
        [CLNewEntryTool addNewRoutineFromCurrentController:self withVideo:videoURL];
    }];
}

- (void)addNewSleightWithVideo {
    
    [[CLGetMediaTool getInstance] recordVideoFromCurrentController:self maximumDuration:30.0 resultBlock:^(NSURL *videoURL) {
        
        [CLNewEntryTool addNewSleightFromCurrentController:self withVideo:videoURL];
    }];
}

- (void)addNewPropWithVideo {
    
    [[CLGetMediaTool getInstance] recordVideoFromCurrentController:self maximumDuration:30.0 resultBlock:^(NSURL *videoURL) {
        
        [CLNewEntryTool addNewPropFromCurrentController:self withVideo:videoURL];
    }];
}

- (void)addNewIdea {
        
    [CLNewEntryTool addNewIdeaFromCurrentController:self withVideo:nil];
}

- (void)addNewShow {

    [CLNewEntryTool addNewShowFromCurrentController:self];
}

- (void)addNewRoutine {

    [CLNewEntryTool addNewRoutineFromCurrentController:self withVideo:nil];
}

- (void)addNewSleight {
    
    [CLNewEntryTool addNewSleightFromCurrentController:self withVideo:nil];
}

- (void)addNewProp {

    [CLNewEntryTool addNewPropFromCurrentController:self withVideo:nil];
}

- (void)addNewLines {
    [CLNewEntryTool addNewLinesFromCurrentController:self];
}


@end
