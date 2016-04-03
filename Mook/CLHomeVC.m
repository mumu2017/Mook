//
//  CLHomeVC.m
//  Mook
//
//  Created by 陈林 on 16/3/25.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLHomeVC.h"
#import "CLListVC.h"
#import "CLTagListVC.h"
#import "CLNewEntryNavVC.h"
#import "CLNewShowNavVC.h"
#import "UINavigationBar+Awesome.h"

#import "CLShowModel.h"
#import "CLIdeaObjModel.h"
#import "CLRoutineModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"
#import "JGActionSheet.h"

@interface CLHomeVC ()

@property (nonatomic, strong) NSMutableArray *allItems;

@property (nonatomic, strong) NSMutableArray *ideaObjModelList;
@property (nonatomic, strong) NSMutableArray *showModelList;
@property (nonatomic, strong) NSMutableArray *routineModelList;
@property (nonatomic, strong) NSMutableArray *sleightObjModelList;
@property (nonatomic, strong) NSMutableArray *propObjModelList;
@property (nonatomic, strong) NSMutableArray *linesObjModelList;
@property (nonatomic, strong) NSMutableArray *allTags;

@property (nonatomic, assign) EditingContentType editingContentType;

@end

@implementation CLHomeVC

#pragma mark - 懒加载模型数组
- (NSMutableArray *)allItems {
    if (!_allItems)  _allItems = kDataListAll;
    return _allItems;
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

- (NSMutableArray *)allTags {
    if (!_allTags) _allTags = kDataListTagAll;
    return _allTags;
}

#pragma mark - 控制器方法
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = 44;

    self.tableView.backgroundColor = kMenuBackgroundColor;
    [self setToolBarStatus];
    
    self.tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:kUpdateDataNotification
                                               object:nil];
    
}


- (void)setToolBarStatus {
    self.navigationController.toolbar.hidden = NO;
    self.navigationController.toolbar.barTintColor = kMenuBackgroundColor;
    self.navigationController.toolbar.tintColor = kTintColor;
    self.navigationController.toolbar.clipsToBounds = YES;
    
    UIBarButtonItem *leftSpace, *buttonItem, *rightSpace;
    leftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    rightSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconAdd"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewEntry)];
    rightSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = [NSArray arrayWithObjects: leftSpace, buttonItem,rightSpace, nil];
}

- (void) update {
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number;
    
    switch (section) {
        case 0:
            number = 1;
            break;
        case 1:
            number = 1;
            break;
        case 2:
            number = 1;
            break;
        case 3:
            number = 1;
            break;
        case 4:
            number = 3;
            break;
            
        default:
            break;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.backgroundColor = kMenuBackgroundColor;
    cell.layer.borderColor = kTintColor.CGColor;
//    cell.layer.borderWidth = 1.0;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *iconName, *count, *title;
    
    switch (indexPath.section) {
            
        case 0:
            title = @"全部";
            count = [NSString stringWithFormat:@"%ld", (unsigned long)self.allItems.count];
            iconName = kIconNameAll;
            break;
            
        case 1:
            title = @"灵感";
            count = [NSString stringWithFormat:@"%ld", (unsigned long)self.ideaObjModelList.count];
            iconName = kIconNameIdea;
            break;
            
        case 2:
            title = @"演出";
            count = [NSString stringWithFormat:@"%ld", (unsigned long)self.showModelList.count];
            iconName = kIconNameShow;
            break;
            
        case 3:
            title = @"流程";
            count = [NSString stringWithFormat:@"%ld", (unsigned long)self.routineModelList.count];
            iconName = kIconNameRoutine;
            break;
            
        case 4:
        {
            if (indexPath.row == 0) {
                title = @"技巧";
                count = [NSString stringWithFormat:@"%ld", (unsigned long)self.sleightObjModelList.count];
                iconName = kIconNameSleight;
            } else if (indexPath.row == 1) {
                title = @"道具";
                count = [NSString stringWithFormat:@"%ld", (unsigned long)self.propObjModelList.count];
                iconName = kIconNameProp;
            } else if (indexPath.row == 2) {
                title = @"梗";
                count = [NSString stringWithFormat:@"%ld", (unsigned long)self.linesObjModelList.count];
                iconName = kIconNameLines;
            }
        }
            
            break;
            
        default:
            break;
    }
    
//    cell.backgroundColor = kCellBgColor;
    cell.imageView.image = [UIImage imageNamed:iconName];
    cell.textLabel.text = title;
    cell.textLabel.font = kFontSys16;
//    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = count;
//    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:kSegueHomeToList sender:indexPath];
 
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id destVC = [segue destinationViewController];
    
    if ([destVC isKindOfClass:[CLListVC class]]) {
        
        CLListVC *vc = (CLListVC *)destVC;
        
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            
            switch (indexPath.section) {
                case 0:
                    vc.listType = kListTypeAll;
                    vc.title = kDefaultTitleAll;
                    
                    break;
                    
                case 1:
                    vc.listType = kListTypeIdea;
                    vc.title = kDefaultTitleIdea;
                    
                    break;
                    
                case 2:
                    vc.listType = kListTypeShow;
                    vc.title = kDefaultTitleShow;
                    
                    break;
                    
                case 3:
                    vc.listType = kListTypeRoutine;
                    vc.title = kDefaultTitleRoutine;
                    
                    break;
                    
                case 4:
                {
                    if (indexPath.row == 0) {
                        vc.listType = kListTypeSleight;
                        vc.title = kDefaultTitleSleight;
                    } else if (indexPath.row == 1) {
                        vc.listType = kListTypeProp;
                        vc.title = kDefaultTitleProp;
                    } else if (indexPath.row == 2) {
                        vc.listType = kListTypeLines;
                        vc.title = kDefaultTitleLines;
                    }
                    break;
                }
                    

                default:
                    break;
            }
        }
        
    } else if ([destVC isKindOfClass:[CLTagListVC class]]) {
        CLTagListVC *vc = (CLTagListVC *)destVC;
        vc.hidesBottomBarWhenPushed = YES;
        
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
    }
}

- (void)addNewEntry {
    
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"新建灵感" , @"新建演出", @"新建流程", @"新建技巧", @"新建道具", @"新建梗"] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleCancel];
    
    NSArray *sections = @[section1, cancelSection];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
    sheet.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    [self addNewIdea];
                    break;
                case 1:
                    [self addNewShow];
                    break;
                    
                case 2:
                    [self addNewRoutine];
                    break;
                case 3:
                    [self addNewSleight];
                    break;
                case 4:
                    [self addNewProp];
                    break;
                case 5:
                    [self addNewLines];
                    break;
                default:
                    break;
            }
            
        }
        
        [sheet dismissAnimated:YES];
    }];
    
    [sheet showInView:self.navigationController.view animated:YES];
}

- (void)addNewIdea {
    self.editingContentType = kEditingContentTypeIdea;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLIdeaObjModel *model = [CLIdeaObjModel ideaObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListIdea insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntry sender:nil];
}

- (void)addNewShow {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLShowModel *model = [CLShowModel showModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListShow insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewShow sender:nil];
}

- (void)addNewRoutine {
    
    self.editingContentType = kEditingContentTypeRoutine;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLRoutineModel *model = [CLRoutineModel routineModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListRoutine insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntry sender:nil];
}

- (void)addNewSleight {
    self.editingContentType = kEditingContentTypeSleight;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLSleightObjModel *model = [CLSleightObjModel sleightObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListSleight insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntry sender:nil];
}

- (void)addNewProp {
    self.editingContentType = kEditingContentTypeProp;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLPropObjModel *model = [CLPropObjModel propObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListProp insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntry sender:nil];
}

- (void)addNewLines {
    self.editingContentType = kEditingContentTypeLines;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLLinesObjModel *model = [CLLinesObjModel linesObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListLines insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntry sender:nil];
}

@end

