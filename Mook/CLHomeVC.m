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
#import "UINavigationBar+Awesome.h"

//#import "CLShowModel.h"
#import "CLIdeaObjModel.h"
#import "CLRoutineModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"
#import "JGActionSheet.h"

@interface CLHomeVC ()
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

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
    
//    [self setToolBarStatus];
    
    [self.leftButton addTarget:self action:@selector(addNewIdea) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(addNewEntry) forControlEvents:UIControlEventTouchUpInside];

    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = kMenuBackgroundColor;
    
    self.tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:kUpdateDataNotification
                                               object:nil];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
}

- (void)setToolBarStatus {
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

#define NAVBAR_CHANGE_POINT 50
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController setToolbarHidden:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void) update {
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.backgroundColor = kCellBgColor;
    cell.backgroundColor = kMenuBackgroundColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    switch (indexPath.row) {
            
        case 0:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.allItems.count];
            break;
            
        case 1:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.ideaObjModelList.count];
            break;
            
        case 2:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.routineModelList.count];
            break;
            
        case 3:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.sleightObjModelList.count];
            break;
            
        case 4:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.propObjModelList.count];
            break;
            
        case 5:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.linesObjModelList.count];
            break;
            
        case 6:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.allTags.count];
            break;
            
        default:
            break;
    }
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 6) {
        [self performSegueWithIdentifier:kSeguekHomeToTagList sender:nil];
    } else {
        [self performSegueWithIdentifier:kSegueHomeToList sender:indexPath];
        
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id destVC = [segue destinationViewController];
    
    if ([destVC isKindOfClass:[CLListVC class]]) {
        
        CLListVC *vc = (CLListVC *)destVC;
        
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            
            switch (indexPath.row) {
                case 0:
                    vc.listType = kListTypeAll;
                    vc.title = kDefaultTitleAll;
                    
                    break;
                    
                case 1:
                    vc.listType = kListTypeIdea;
                    vc.title = kDefaultTitleIdea;
                    
                    break;
                    
                case 2:
                    vc.listType = kListTypeRoutine;
                    vc.title = kDefaultTitleRoutine;
                    
                    break;
                    
                case 3:
                    vc.listType = kListTypeSleight;
                    vc.title = kDefaultTitleSleight;
                    
                    break;
                    
                case 4:
                    vc.listType = kListTypeProp;
                    vc.title = kDefaultTitleProp;
                    
                    break;
                    
                case 5:
                    vc.listType = kListTypeLines;
                    vc.title = kDefaultTitleLines;
                    
                    break;
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
            vc.ideaObjModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] ideaObjModelList][0];
            
        } else if (self.editingContentType == kEditingContentTypeRoutine) {
            vc.routineModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] routineModelList][0];
        } else if (self.editingContentType == kEditingContentTypeSleight) {
            vc.sleightObjModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sleightObjModelList][0];
        } else if (self.editingContentType == kEditingContentTypeProp) {
            vc.propObjModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList][0];
        } else if (self.editingContentType == kEditingContentTypeLines) {
            vc.linesObjModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] linesObjModelList][0];
        }
    }
}

- (void)addNewEntry {
    
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"新建灵感", @"新建流程", @"新建技巧", @"新建道具", @"新建梗"] buttonStyle:JGActionSheetButtonStyleDefault];
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
                    [self addNewRoutine];
                    break;
                case 2:
                    [self addNewSleight];
                    break;
                case 3:
                    [self addNewProp];
                    break;
                case 4:
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
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] ideaObjModelList] insertObject:model atIndex:0];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] allItems] insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntry sender:nil];
}

- (void)addNewRoutine {
    
    self.editingContentType = kEditingContentTypeRoutine;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLRoutineModel *model = [CLRoutineModel routineModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] routineModelList] insertObject:model atIndex:0];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] allItems] insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntry sender:nil];
}

- (void)addNewSleight {
    self.editingContentType = kEditingContentTypeSleight;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLSleightObjModel *model = [CLSleightObjModel sleightObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] sleightObjModelList] insertObject:model atIndex:0];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] allItems] insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntry sender:nil];
}

- (void)addNewProp {
    self.editingContentType = kEditingContentTypeProp;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLPropObjModel *model = [CLPropObjModel propObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList] insertObject:model atIndex:0];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] allItems] insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntry sender:nil];
}

- (void)addNewLines {
    self.editingContentType = kEditingContentTypeLines;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLLinesObjModel *model = [CLLinesObjModel linesObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] linesObjModelList] insertObject:model atIndex:0];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] allItems] insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntry sender:nil];
}

@end

