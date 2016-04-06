//
//  CLListvc.m
//  Mook
//
//  Created by 陈林 on 16/3/25.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLListVC.h"

#import "CLDataSaveTool.h"
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

#import "JGActionSheet.h"

#import "CLTableBackView.h"


@interface CLListVC ()<SWTableViewCellDelegate>


@property (nonatomic, strong) NSMutableArray *allItems;

@property (nonatomic, strong) NSMutableArray *tagList;

@property (nonatomic, strong) CLTableBackView *tableBackView;
@property (nonatomic, assign) EditingContentType editingContentType;

@end

@implementation CLListVC

#pragma mark - 模型数组懒加载
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

#pragma mark - 背景view懒加载
- (CLTableBackView *)tableBackView {
    if (!_tableBackView) {
        _tableBackView = [CLTableBackView tableBackView];
    }
    return _tableBackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.backgroundColor = kMenuBackgroundColor;
    self.tableView.backgroundView = self.tableBackView;
    self.tableView.rowHeight = kListCellHeight;
    self.tableView.tableFooterView = [UIView new];
    
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void) update:(NSNotification *)noti {
    
    if (noti.object == self) {  //如果是自己发出的更新通知,则不刷新.
        return;
    }
    
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
    NSAttributedString *content;
    
    switch (self.listType) {
        case kListTypeAll:
        {
            id modelUnknown = self.allItems[indexPath.row];
            if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
                CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
                image = [model getThumbnail];
                iconName = kIconNameIdea;
                title = [model getTitle];
                content = [model getContent];
            } else if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
                CLShowModel *model = (CLShowModel *)modelUnknown;
                image = [model getThumbnail];
                iconName = kIconNameShow;
                title = [model getTitle];
                content = [model getContent];
            } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
                CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
                image = [model getThumbnail];
                iconName = kIconNameRoutine;
                title = [model getTitle];
                content = [model getContent];
            } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
                CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
                image = [model getThumbnail];
                iconName = kIconNameSleight;
                title = [model getTitle];
                content = [model getContent];
            } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
                CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
                image = [model getThumbnail];
                iconName = kIconNameProp;
                title = [model getTitle];
                content = [model getContent];
            } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
                CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
                iconName = kIconNameLines;
                title = [model getTitle];
                content = [model getContent];
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
    
    if (image != nil) { // 如果返回图片名称,则表示模型中有图片或多媒体
        CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
        cell.iconView.image = image;
        cell.iconName = iconName;
        [cell setTitle:title content:content];
        
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        cell.backgroundColor = [UIColor flatWhiteColor];

        return cell;
        
    } else {
        CLListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kListTextCellID forIndexPath:indexPath];
        cell.iconName = iconName;
        [cell setTitle:title content:content];
        
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        cell.backgroundColor = [UIColor flatWhiteColor];

        return cell;
    }
    
    return nil;
    
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];

    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];

    return rightUtilityButtons;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    if (index == 0) {
        switch (self.listType) {
            case kListTypeAll:
            {
                id modelUnknown = self.allItems[path.row];
                if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
                    CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
                    
                    if (self.tag.length > 0 && self.ideaObjModelList != kDataListIdea) {
                        [self.ideaObjModelList removeObject:model];
                    }
                    
                    [kDataListIdea removeObject:model];
                    [kDataListAll removeObject:model];
                    
                    [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                    
                    [CLDataSaveTool deleteIdea:model];
                    
                } else if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
                    CLShowModel *model = (CLShowModel *)modelUnknown;
                    
                    [kDataListShow removeObject:model];
                    [kDataListAll removeObject:model];
                    
                    if (self.showModelList != kDataListShow) {
                        [self.showModelList removeObject:model];
                    }
                    
                    [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                    
                    [CLDataSaveTool deleteShow:model];
                    
                } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
                    CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
                   
                    [kDataListRoutine removeObject:model];
                    [kDataListAll removeObject:model];
                    
                    if (self.routineModelList != kDataListRoutine) {
                        [self.routineModelList removeObject:model];
                    }
                    
                    [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                    
                    [CLDataSaveTool deleteRoutine:model];
                    
                } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
                    CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
                    
                    if (self.tag.length > 0 && self.sleightObjModelList != kDataListSleight) {
                        [self.sleightObjModelList removeObject:model];
                    }
                    
                    [kDataListSleight removeObject:model];
                    [kDataListAll removeObject:model];
                    
                    [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                    
                    [CLDataSaveTool deleteSleight:model];

                } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
                    CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
                    
                    if (self.tag.length > 0 && self.propObjModelList != kDataListProp) {
                        [self.propObjModelList removeObject:model];
                    }
                    
                    [kDataListProp removeObject:model];
                    [kDataListAll removeObject:model];
                    
                    [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                    
                    [CLDataSaveTool deleteProp:model];
                    
                } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
                    CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
                   
                    if (self.tag.length > 0 && self.linesObjModelList != kDataListLines) {
                        [self.linesObjModelList removeObject:model];
                    }
                    
                    [kDataListLines removeObject:model];
                    [kDataListAll removeObject:model];
                    
                    [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                    
          
                    [CLDataSaveTool deleteLines:model];

                }
                
                self.tableBackView.hidden = !(self.allItems.count == 0);

                break;
            }
            case kListTypeIdea:
            {
                CLIdeaObjModel *model = self.ideaObjModelList[path.row];
               
                if (self.tag.length > 0 && kDataListIdea) {
                    [self.ideaObjModelList removeObject:model];
                }
                
                [kDataListIdea removeObject:model];
                [kDataListAll removeObject:model];
                
                [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                
                self.tableBackView.hidden = !(self.ideaObjModelList.count == 0);
                
                [CLDataSaveTool deleteIdea:model];
                break;
            }
            case kListTypeShow:
            {
                CLShowModel *model = self.showModelList[path.row];

                [kDataListShow removeObject:model];
                [kDataListAll removeObject:model];
                
                if (self.showModelList != kDataListShow) {
                    [self.showModelList removeObject:model];
                }
                
                [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                
                [CLDataSaveTool deleteShow:model];
                
                break;
            }
                
            case kListTypeRoutine:
            {
                CLRoutineModel *model = self.routineModelList[path.row];
               
                [kDataListRoutine removeObject:model];
                [kDataListAll removeObject:model];
                
                if (self.routineModelList != kDataListRoutine) {
                    [self.routineModelList removeObject:model];
                }
                
                [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                
                [CLDataSaveTool deleteRoutine:model];

                break;
            }
            case kListTypeSleight:
            {
                CLSleightObjModel *model = self.sleightObjModelList[path.row];
                [kDataListSleight removeObject:model];
                [kDataListAll removeObject:model];
                
                self.tableBackView.hidden = !(self.sleightObjModelList.count == 0);
                
                [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                
                
                [CLDataSaveTool deleteSleight:model];
                
                break;
            }
                
                
            case kListTypeProp:
            {
                CLPropObjModel *model = self.propObjModelList[path.row];
                if (self.tag.length > 0 && self.propObjModelList != kDataListProp) {
                    [self.propObjModelList removeObject:model];
                }
                
                [kDataListProp removeObject:model];
                [kDataListAll removeObject:model];
                
                [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                
                self.tableBackView.hidden = !(self.propObjModelList.count == 0);
                
                [CLDataSaveTool deleteProp:model];

                
                break;
            }
            case kListTypeLines:
            {
                CLLinesObjModel *model = self.linesObjModelList[path.row];
                if (self.tag.length > 0 && self.linesObjModelList != kDataListLines) {
                    [self.linesObjModelList removeObject:model];
                }
                
                [kDataListLines removeObject:model];
                [kDataListAll removeObject:model];
                
                [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                
                self.tableBackView.hidden = !(self.linesObjModelList.count == 0);
                
                [CLDataSaveTool deleteLines:model];

                
                break;
            }
   
            default:
                break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:self];
    [cell hideUtilityButtonsAnimated:YES];
}

#pragma mark 选中cell跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.listType == kListTypeShow) {
        CLShowModel *model = self.showModelList[indexPath.row];
        [self performSegueWithIdentifier:kSegueListToShow sender:model];
        
    } else if (self.listType == kListTypeAll) {
        id modelUnknown = self.allItems[indexPath.row];
        if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
            [self performSegueWithIdentifier:kSegueListToShow sender:modelUnknown];
        } else {
            
            [self performSegueWithIdentifier:kSegueListToContent sender:indexPath];
        }
        
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
                {
                    id modelUnknown = self.allItems[indexPath.row];
                    if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
                        CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
                        vc.contentType = kContentTypeIdea;
                        vc.ideaObjModel = model;
                        vc.date = model.date;
                        
                    } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
                        CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
                        vc.contentType = kContentTypeRoutine;
                        vc.routineModel = model;
                        vc.date = model.date;
                        
                    } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
                        CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
                        vc.contentType = kContentTypeSleight;
                        vc.sleightObjModel = model;
                        vc.date = model.date;
                        
                    } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
                        CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
                        vc.contentType = kContentTypeProp;
                        vc.propObjModel = model;
                        vc.date = model.date;
                        
                    } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
                        CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
                        vc.contentType = kContentTypeLines;
                        vc.linesObjModel = model;
                        vc.date = model.date;
                    }
                    
                    break;
                }
                case kListTypeIdea:
                {
                    CLIdeaObjModel *model = self.ideaObjModelList[indexPath.row];
                    vc.contentType = kContentTypeIdea;
                    vc.ideaObjModel = model;
                    vc.date = model.date;
                    break;
                }

                case kListTypeRoutine:
                {
                    CLRoutineModel *model = self.routineModelList[indexPath.row];
                    vc.contentType = kContentTypeRoutine;
                    vc.routineModel = model;
                    vc.date = model.date;
                    break;
                }
                case kListTypeSleight:
                {
                    CLSleightObjModel *model = self.sleightObjModelList[indexPath.row];
                    vc.contentType = kContentTypeSleight;
                    vc.sleightObjModel = model;
                    vc.date = model.date;
                    break;
                }
                    
                    
                case kListTypeProp:
                {
                    CLPropObjModel *model = self.propObjModelList[indexPath.row];
                    vc.contentType = kContentTypeProp;
                    vc.propObjModel = model;
                    vc.date = model.date;
                    break;
                }
                case kListTypeLines:
                {
                    CLLinesObjModel *model = self.linesObjModelList[indexPath.row];
                    vc.contentType = kContentTypeLines;
                    vc.linesObjModel = model;
                    vc.date = model.date;
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
    } else if ([destVC isKindOfClass:[CLNewShowNavVC class]]) {
        CLNewShowNavVC *vc = (CLNewShowNavVC *)destVC;
        vc.showModel = kDataListShow[0];
        
    } else if ([destVC isKindOfClass:[CLShowVC class]]) {
        CLShowVC *vc = (CLShowVC *)destVC;
        if ([sender isKindOfClass:[CLShowModel class]]) {
            
            CLShowModel *model = (CLShowModel *)sender;
            vc.showModel = model;
            vc.date = model.date;
        }
    }

}

- (IBAction)addNewEntry:(id)sender {
    
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

}

- (void)addNewEntry {
    
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"新建灵感" , @"新建演出", @"新建流程", @"新建技巧", @"新建道具", @"新建台词"] buttonStyle:JGActionSheetButtonStyleDefault];
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
    
    [sheet showInView:self.tabBarController.view animated:YES];
}

- (void)addNewIdea {
    self.editingContentType = kEditingContentTypeIdea;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLIdeaObjModel *model = [CLIdeaObjModel ideaObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListIdea insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.ideaObjModelList != kDataListIdea) {
        [model.tags addObject:self.tag];
        [self.ideaObjModelList insertObject:model atIndex:0];
    }
    
    [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
}

- (void)addNewShow {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLShowModel *model = [CLShowModel showModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListShow insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.showModelList != kDataListShow) {
        [model.tags addObject:self.tag];
        [self.showModelList insertObject:model atIndex:0];
    }
    
    [self performSegueWithIdentifier:kSegueListToNewShow sender:nil];
}

- (void)addNewRoutine {
    
    self.editingContentType = kEditingContentTypeRoutine;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLRoutineModel *model = [CLRoutineModel routineModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListRoutine insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];

    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.routineModelList != kDataListRoutine) {
        [model.tags addObject:self.tag];
        [self.routineModelList insertObject:model atIndex:0];
    }
    
    [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
}

- (void)addNewSleight {
    self.editingContentType = kEditingContentTypeSleight;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLSleightObjModel *model = [CLSleightObjModel sleightObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListSleight insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];

    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到sleightModelList中
    if (self.tag.length > 0 && self.sleightObjModelList != kDataListSleight) {
        [model.tags addObject:self.tag];
        [self.sleightObjModelList insertObject:model atIndex:0];
    }
    
    [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
}

- (void)addNewProp {
    self.editingContentType = kEditingContentTypeProp;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLPropObjModel *model = [CLPropObjModel propObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListProp insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];

    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.propObjModelList != kDataListProp) {
        [model.tags addObject:self.tag];
        [self.propObjModelList insertObject:model atIndex:0];
    }
    
    [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
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
