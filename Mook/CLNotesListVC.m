//
//  CLNotesListVC.m
//  Mook
//
//  Created by 陈林 on 16/6/24.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLNotesListVC.h"

#import "CLNewEntryTool.h"
#import "CLDataSaveTool.h"
#import "CLDataExportTool.h"
#import "CLNewEntryNavVC.h"
#import "CLNewShowNavVC.h"
#import "CLContentVC.h"
#import "CLShowVC.h"

#import "CLNotesListCell.h"
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

#import "CLTableBackView.h"
#import "CLGetMediaTool.h"

#import "Masonry.h"
#import "CLAddView.h"
#import "Pop.h"
#import "BTNavigationDropdownMenu-Swift.h"
@class BTNavigationDropdownMenu;

#import "BFPaperButton.h"
@interface CLNotesListVC()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIDocumentInteractionControllerDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

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

@property (strong, nonatomic) BFPaperButton *addButton;
@property (strong, nonatomic) BFPaperButton *mediaButton;

@property (strong, nonatomic) UIButton *coverButton;

@property (strong, nonatomic) BTNavigationDropdownMenu *menu;

@property (strong, nonatomic) CLAddView *addView;


@end

@implementation CLNotesListVC

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];

        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [self.view addSubview: _collectionView];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}


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
            make.bottom.equalTo(self.navigationController.view.mas_bottom).with.offset(-64);
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
        
        NSArray *items = [NSArray arrayWithObjects:NSLocalizedString(@"演出", nil), NSLocalizedString(@"流程", nil), NSLocalizedString(@"想法", nil), NSLocalizedString(@"技巧", nil), NSLocalizedString(@"道具", nil), NSLocalizedString(@"台词", nil), NSLocalizedString(@"全部", nil), nil];
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

#pragma mark - 控制器生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self coverButton];
    
    self.collectionView.backgroundView = self.tableBackView;
    self.collectionView.backgroundColor = kAppThemeColor;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, kAddButtonHeight*2, 0);
    
    self.navigationItem.titleView = self.menu;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CLNotesListCell"
                                                    bundle:nil] forCellWithReuseIdentifier:@"notesListCell"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateDataNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateMookNotification
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
    
//    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    [self prepareVisibleCellsForAnimation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self animateVisibleCells];
}

#pragma mark - Private

- (void)prepareVisibleCellsForAnimation {
    for (int i = 0; i < [self.collectionView.visibleCells count]; i++) {
        CLNotesListCell * cell = (CLNotesListCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        cell.frame = CGRectMake(-CGRectGetWidth(cell.bounds), cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
        cell.alpha = 0.f;
    }
}

- (void)animateVisibleCells {
    for (int i = 0; i < [self.collectionView.visibleCells count]; i++) {
        CLNotesListCell * cell = (CLNotesListCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        cell.alpha = 1.f;
        [UIView animateWithDuration:0.25f
                              delay:i * 0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.frame = CGRectMake(0.f, cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
                         }
                         completion:nil];
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
    self.menu.cellBackgroundColor = kAppThemeColor;
    self.mediaButton.backgroundColor = self.addButton.backgroundColor;
    
    if (self.listType == kListTypeLines) {
        [_mediaButton setImage:[UIImage imageNamed:@"addAudio"] forState:UIControlStateNormal];
        
    } else {
        [_mediaButton setImage:[UIImage imageNamed:@"addMedia"] forState:UIControlStateNormal];
        
    }
    
    if (self.navigationController.visibleViewController == self) {
        self.mediaButton.hidden = (self.listType == kListTypeAll);
        
    }
    
    [self.addView updateColor:self.addButton.backgroundColor];
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.addButton.hidden = YES;
    self.mediaButton.hidden = YES;
    [self.menu hide];
    
    [self hideAddView];
}

- (void)hideAddView {
    if (self.addView.center.y == self.navigationController.view.center.y) {
        [self toggleAddView];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CLNotesListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"notesListCell" forIndexPath:indexPath];
    
    cell.backgroundColor = kAppThemeColor;
    
    switch (self.listType) {
        case kListTypeAll:
        {
            id modelUnknown = self.allItems[indexPath.row];
            [cell setModel:modelUnknown];
            
            break;
        }
        case kListTypeIdea:
        {
            CLIdeaObjModel *model = self.ideaObjModelList[indexPath.row];
            [cell setModel:model];
            
            break;
        }
            
        case kListTypeShow:
        {
            CLShowModel *model = self.showModelList[indexPath.row];
            [cell setModel:model];
            
            break;
        }
        case kListTypeRoutine:
        {
            CLRoutineModel *model = self.routineModelList[indexPath.row];
            [cell setModel:model];
            
            break;
        }
        case kListTypeSleight:
        {
            CLSleightObjModel *model = self.sleightObjModelList[indexPath.row];
            [cell setModel:model];
            
            break;
        }
            
            
        case kListTypeProp:
        {
            CLPropObjModel *model = self.propObjModelList[indexPath.row];
            [cell setModel:model];
            
            break;
        }
        case kListTypeLines:
        {
            CLLinesObjModel *model = self.linesObjModelList[indexPath.row];
            [cell setModel:model];
            break;
        }
        default:
            break;
    }
    
    return cell;
    

}

#pragma mark - UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
//    
//    return CGSizeMake(CGRectGetWidth(self.view.bounds), layout.itemSize.height);
//}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    return CGSizeMake((self.view.frame.size.width-1)/2, (self.view.frame.size.width-1)/2);
    return CGSizeMake(self.view.frame.size.width, kListCellHeight);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 1, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1; // This is the minimum inter item spacing, can be more
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
    
    [self.collectionView deleteItemsAtIndexPaths:@[path]];
//     deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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

- (void)addNewEntry:(id)sender {
    
    switch (self.listType) {
        case kListTypeAll:
            [self toggleAddView];
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
    
    //    滚动到第一行
    //    if ([self.tableView numberOfRowsInSection:0] > 0) {
    //        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    //
    //    }
    
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
    [self hideAddView];
    
    [[CLGetMediaTool getInstance] recordAudioFromCurrentController:self.tabBarController audioBlock:^(NSString *filePath) {
        [CLNewEntryTool quickAddNewLinesFromCurrentController:self withAudio:filePath];
    }];
}

- (void)addNewShowWithVideo {
    [self hideAddView];
    
    [[CLGetMediaTool getInstance] loadCameraFromCurrentViewController:self maximumDuration:600.0 completion:^(NSURL *videoURL, UIImage *photo) {
        [CLNewEntryTool quickAddNewShowFromCurrentController:self withVideo:videoURL orImage:photo];
    }];
}


- (void)addNewIdeaWithVideo {
    
    [self hideAddView];
    
    [[CLGetMediaTool getInstance] loadCameraFromCurrentViewController:self maximumDuration:30.0 completion:^(NSURL *videoURL, UIImage *photo) {
        [CLNewEntryTool quickAddNewIdeaFromCurrentController:self withVideo:videoURL orImage:photo];
    }];
}

- (void)addNewRoutineWithVideo {
    [self hideAddView];
    
    [[CLGetMediaTool getInstance] loadCameraFromCurrentViewController:self maximumDuration:180.0 completion:^(NSURL *videoURL, UIImage *photo) {
        [CLNewEntryTool quickAddNewRoutineFromCurrentController:self withVideo:videoURL orImage:photo];
    }];
}

- (void)addNewSleightWithVideo {
    [self hideAddView];
    
    [[CLGetMediaTool getInstance] loadCameraFromCurrentViewController:self maximumDuration:30.0 completion:^(NSURL *videoURL, UIImage *photo) {
        [CLNewEntryTool quickAddNewSleightFromCurrentController:self withVideo:videoURL orImage:photo];
    }];
}

- (void)addNewPropWithVideo {
    [self hideAddView];
    
    [[CLGetMediaTool getInstance] loadCameraFromCurrentViewController:self maximumDuration:30.0 completion:^(NSURL *videoURL, UIImage *photo) {
        [CLNewEntryTool quickAddNewPropFromCurrentController:self withVideo:videoURL orImage:photo];
        
    }];
}

- (void)addNewIdea {
    
    [CLNewEntryTool addNewIdeaFromCurrentController:self withVideo:nil orImage:nil];
}

- (void)addNewShow {
    
    [CLNewEntryTool addNewShowFromCurrentController:self withVideo:nil orImage:nil];
}

- (void)addNewRoutine {
    
    [CLNewEntryTool addNewRoutineFromCurrentController:self withVideo:nil  orImage:nil];
}

- (void)addNewSleight {
    
    [CLNewEntryTool addNewSleightFromCurrentController:self withVideo:nil  orImage:nil];
}

- (void)addNewProp {
    
    [CLNewEntryTool addNewPropFromCurrentController:self withVideo:nil  orImage:nil];
}

- (void)addNewLines {
    [CLNewEntryTool addNewLinesFromCurrentController:self];
}



@end
