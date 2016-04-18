//
//  CLTagListVC.m
//  Mook
//
//  Created by 陈林 on 15/12/15.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLTagListVC.h"
#import "CLDataSaveTool.h"
#import "CLListVC.h"

#import "CLShowModel.h"
#import "CLRoutineModel.h"
#import "CLIdeaObjModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"


#import "CLTableBackView.h"


@interface CLTagListVC ()<SWTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *allTags;
@property (nonatomic, strong) NSMutableArray *allTagsShow;
@property (nonatomic, strong) NSMutableArray *allTagsIdea;
@property (nonatomic, strong) NSMutableArray *allTagsRoutine;
@property (nonatomic, strong) NSMutableArray *allTagsSleight;
@property (nonatomic, strong) NSMutableArray *allTagsProp;
@property (nonatomic, strong) NSMutableArray *allTagsLines;

//@property (nonatomic, strong) CLTableBackView *tableBackView;

@end

@implementation CLTagListVC

- (NSMutableArray *)allTags {
    if (!_allTags) _allTags = kDataListTagAll;  return _allTags;
}

- (NSMutableArray *)allTagsShow {
    if (!_allTagsShow) _allTagsShow = kDataListTagShow;  return _allTagsShow;
}

- (NSMutableArray *)allTagsIdea {
    if (!_allTagsIdea) _allTagsIdea = kDataListTagIdea;  return _allTagsIdea;
}


- (NSMutableArray *)allTagsRoutine {
    if (!_allTagsRoutine) _allTagsRoutine = kDataListTagRoutine;  return _allTagsRoutine;
}

- (NSMutableArray *)allTagsSleight {
    if (!_allTagsSleight) _allTagsSleight = kDataListTagSleight;  return _allTagsSleight;
}

- (NSMutableArray *)allTagsProp {
    if (!_allTagsProp) _allTagsProp = kDataListTagProp;  return _allTagsProp;
}

- (NSMutableArray *)allTagsLines {
    if (!_allTagsLines) _allTagsLines = kDataListTagLines;  return _allTagsLines;
}


#pragma mrak - 流程模型数据懒加载

#pragma mark - 控制器方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsMultipleSelection = NO;
    
    self.tableView.tableFooterView = [UIView new];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number = 0;
    
    if (section == 0) {
        number = self.allTagsIdea.count;
    } else if (section == 1) {
        number = self.allTagsShow.count;
    } else if (section == 2) {
        number = self.allTagsRoutine.count;
    } else if (section == 3) {
        number = self.allTagsSleight.count;
    } else if (section == 4) {
        number = self.allTagsProp.count;
    } else if (section == 5) {
        number = self.allTagsLines.count;
    }
    
    if (number == 0) {  //如果没有标签,则显示一行cell,提示用户没有标签
        number = 1;
    }

    return number;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTagCell forIndexPath:indexPath];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    cell.backgroundColor = kCellBgColor;
    
    NSString *tag, *tagCount;
    NSInteger tagItemCount = 0;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
            
        case 0:
            
            if (self.allTagsIdea.count == 0) {
                tag = NSLocalizedString(@"无标签", nil);;
                tagCount = @"";
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.rightUtilityButtons = nil;

            } else {
                tag = self.allTagsIdea[indexPath.row];
                for (CLIdeaObjModel *model in kDataListIdea) {
                    
                    if ([model.tags containsObject:tag]) {
                        tagItemCount++;
                    }
                }
                tagCount = [NSString stringWithFormat:@"%ld", (long)tagItemCount];
                
            }
            
            break;
            
        case 1:
            
            if (self.allTagsShow.count == 0) {
                tag = NSLocalizedString(@"无标签", nil);;
                tagCount = @"";
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.rightUtilityButtons = nil;

            } else {
                tag = self.allTagsShow[indexPath.row];
                for (CLShowModel *model in kDataListShow) {
                    
                    if ([model.tags containsObject:tag]) {
                        tagItemCount++;
                    }
                }
                tagCount = [NSString stringWithFormat:@"%ld", (long)tagItemCount];
                
            }
            
            break;
            
            
        case 2:
            
            if (self.allTagsRoutine.count == 0) {
                tag = NSLocalizedString(@"无标签", nil);;
                tagCount = @"";
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.rightUtilityButtons = nil;
                
            } else {
                tag = self.allTagsRoutine[indexPath.row];
                for (CLRoutineModel *model in kDataListRoutine) {
                    
                    if ([model.tags containsObject:tag]) {
                        tagItemCount++;
                    }
                }
                tagCount = [NSString stringWithFormat:@"%ld", (long)tagItemCount];
                
            }
            
            break;
            
        case 3:
            if (self.allTagsSleight.count == 0) {
                tag = NSLocalizedString(@"无标签", nil);;
                tagCount = @"";
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.rightUtilityButtons = nil;

            } else {
                tag = self.allTagsSleight[indexPath.row];
                
                for (CLSleightObjModel *model in kDataListSleight) {
                    
                    if ([model.tags containsObject:tag]) {
                        tagItemCount++;
                    }
                }
                tagCount = [NSString stringWithFormat:@"%ld", (long)tagItemCount];
                
            }
            
            break;
        case 4:
            if (self.allTagsProp.count == 0) {
                tag = NSLocalizedString(@"无标签", nil);;
                tagCount = @"";
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.rightUtilityButtons = nil;

            } else {
                tag = self.allTagsProp[indexPath.row];
                
                for (CLPropObjModel *model in kDataListProp) {
                    
                    if ([model.tags containsObject:tag]) {
                        tagItemCount++;
                    }
                }
                tagCount = [NSString stringWithFormat:@"%ld", (long)tagItemCount];
                
            }
            
            break;
        case 5:
            if (self.allTagsLines.count == 0) {
                tag = NSLocalizedString(@"无标签", nil);;
                tagCount = @"";
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.rightUtilityButtons = nil;

            } else {
                tag = self.allTagsLines[indexPath.row];
                
                for (CLLinesObjModel *model in kDataListLines) {
                    
                    if ([model.tags containsObject:tag]) {
                        tagItemCount++;
                    }
                }
                tagCount = [NSString stringWithFormat:@"%ld", (long)tagItemCount];
                
            }
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = tag;
    cell.detailTextLabel.text = tagCount;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *titleArr = @[NSLocalizedString(@"灵感", nil), NSLocalizedString(@"演出", nil), NSLocalizedString(@"流程", nil), NSLocalizedString(@"技巧", nil), NSLocalizedString(@"道具", nil), NSLocalizedString(@"台词", nil)];

    return titleArr[section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger number = 0;
    if (indexPath.section == 0) {
        number = self.allTagsIdea.count;
    } else if (indexPath.section == 1) {
        number = self.allTagsShow.count;
    } else if (indexPath.section == 2) {
        number = self.allTagsRoutine.count;
    } else if (indexPath.section == 3) {
        number = self.allTagsSleight.count;
    } else if (indexPath.section == 4) {
        number = self.allTagsProp.count;
    } else if (indexPath.section == 5) {
        number = self.allTagsLines.count;
    }
    
    if (number == 0) {  //如果没有标签,则不跳转
        return;
    }
    
    [self performSegueWithIdentifier:kSegueTagToListSegue sender:indexPath];
    
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor flatRedColor] title:NSLocalizedString(@"删除", nil)];
    
    return rightUtilityButtons;
}


#pragma mark - SWTableViewDelegate


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSIndexPath *path = [self.tableView indexPathForCell:cell];
            NSString *tag, *type;
            switch (path.section) {
                case 0:
                {
                    type = kTypeIdea;
                    tag = self.allTagsIdea[path.row];
                    for (CLIdeaObjModel *model in kDataListIdea) {
                        if ([model.tags containsObject:tag]) {
                            [model.tags removeObject:tag];
                        }
                    }
                    [self.allTagsIdea removeObject:tag];
                    if (self.allTagsIdea.count == 0) {
                        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                    } else {
                        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    break;
                }
                    
                case 1:
                {
                    type = kTypeShow;
                    tag = self.allTagsShow[path.row];
                    for (CLShowModel *model in kDataListShow) {
                        if ([model.tags containsObject:tag]) {
                            [model.tags removeObject:tag];
                        }
                    }
                    [self.allTagsShow removeObject:tag];
                    if (self.allTagsShow.count == 0) {
                        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                    } else {
                        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    break;
                }
                    
                case 2:
                {
                    type = kTypeRoutine;
                    tag = self.allTagsRoutine[path.row];
                    for (CLRoutineModel *model in kDataListRoutine) {
                        if ([model.tags containsObject:tag]) {
                            [model.tags removeObject:tag];
                        }
                    }
                    [self.allTagsRoutine removeObject:tag];
                    if (self.allTagsRoutine.count == 0) {
                        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                    } else {
                        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    break;
                }

                case 3:
                {
                    type = kTypeSleight;
                    tag = self.allTagsSleight[path.row];
                    for (CLSleightObjModel *model in kDataListSleight) {
                        if ([model.tags containsObject:tag]) {
                            [model.tags removeObject:tag];
                        }
                    }
                    [self.allTagsSleight removeObject:tag];

                    if (self.allTagsSleight.count == 0) {
                        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                    } else {
                        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    break;
                }
                    
                case 4:
                {
                    type = kTypeProp;
                    tag = self.allTagsProp[path.row];
                    for (CLPropObjModel *model in kDataListProp) {
                        if ([model.tags containsObject:tag]) {
                            [model.tags removeObject:tag];
                        }
                    }
                    [self.allTagsProp removeObject:tag];

                    if (self.allTagsProp.count == 0) {
                        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                    } else {
                        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    break;
                }
                    
                case 5:
                {
                    type = kTypeLines;
                    tag = self.allTagsLines[path.row];
                    for (CLLinesObjModel *model in kDataListLines) {
                        if ([model.tags containsObject:tag]) {
                            [model.tags removeObject:tag];
                        }
                    }
                    [self.allTagsLines removeObject:tag];

                    if (self.allTagsLines.count == 0) {
                        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
                    } else {
                        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    break;
                }
                    
                default:
                    break;
            }
            [self.allTags removeObject:tag];
            
            [CLDataSaveTool deleteTag:tag type:type];
            
            break;
        }
            
        default:
            break;
    }
    
    [cell hideUtilityButtonsAnimated:YES];

}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id destVC = [segue destinationViewController];
    
    if ([destVC isKindOfClass:[CLListVC class]]) {
        
        CLListVC *vc = (CLListVC *)destVC;
        
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            
            switch (indexPath.section) {
                case 0:
                {
                    vc.listType = kListTypeIdea;
                    vc.title = kDefaultTitleIdea;
                    
                    vc.tag = self.allTagsIdea[indexPath.row];
                    
                    NSMutableArray *arrayM = [NSMutableArray array];
                    for (CLIdeaObjModel *model in kDataListIdea) {
                        
                        if ([model.tags containsObject:vc.tag]) {
                            [arrayM addObject:model];
                        }
                    }
                    vc.ideaObjModelList = arrayM;
                    break;
                }
                    
                case 1:
                {
                    vc.listType = kListTypeShow;
                    vc.title = kDefaultTitleShow;
                    
                    vc.tag = self.allTagsShow[indexPath.row];
                    
                    NSMutableArray *arrayM = [NSMutableArray array];
                    for (CLShowModel *model in kDataListShow) {
                        
                        if ([model.tags containsObject:vc.tag]) {
                            [arrayM addObject:model];
                        }
                    }
                    
                    vc.showModelList = arrayM;
                    break;
                }

                case 2:
                {
                    vc.listType = kListTypeRoutine;
                    vc.title = kDefaultTitleRoutine;
                    
                    vc.tag = self.allTagsRoutine[indexPath.row];
                    
                    NSMutableArray *arrayM = [NSMutableArray array];
                    for (CLRoutineModel *model in kDataListRoutine) {
                        
                        if ([model.tags containsObject:vc.tag]) {
                            [arrayM addObject:model];
                        }
                    }
                    
                    vc.routineModelList = arrayM;
                    break;
                }
                case 3:
                {
                    vc.listType = kListTypeSleight;
                    vc.title = kDefaultTitleSleight;
                    
                    vc.tag = self.allTagsSleight[indexPath.row];
                    
                    NSMutableArray *arrayM = [NSMutableArray array];
                    for (CLSleightObjModel *model in kDataListSleight) {
                        
                        if ([model.tags containsObject:vc.tag]) {
                            [arrayM addObject:model];
                        }
                    }
                    
                    vc.sleightObjModelList = arrayM;
                    break;
                }
                case 4:
                {
                    vc.listType = kListTypeProp;
                    vc.title = kDefaultTitleProp;
                    
                    vc.tag = self.allTagsProp[indexPath.row];
                    
                    NSMutableArray *arrayM = [NSMutableArray array];
                    for (CLPropObjModel *model in kDataListProp) {
                        
                        if ([model.tags containsObject:vc.tag]) {
                            [arrayM addObject:model];
                        }
                    }
                    
                    vc.propObjModelList = arrayM;
                    break;
                }
                case 5:
                {
                    vc.listType = kListTypeLines;
                    vc.title = kDefaultTitleLines;
                    
                    vc.tag = self.allTagsLines[indexPath.row];
                    
                    NSMutableArray *arrayM = [NSMutableArray array];
                    for (CLLinesObjModel *model in kDataListLines) {
                        
                        if ([model.tags containsObject:vc.tag]) {
                            [arrayM addObject:model];
                        }
                    }
                    
                    vc.linesObjModelList = arrayM;
                    break;
                }
                default:
                    break;
            }
        }
        
    }
}

@end
