//
//  CLShowVC.m
//  Mook
//
//  Created by 陈林 on 15/12/19.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLShowVC.h"
#import "CLShowModel.h"

#import "CLListImageCell.h"

#import "CLNewShowVC.h"

#import "CLRoutineModel.h"
#import "CLInfoModel.h"
#import "CLEffectModel.h"

#import "CLTableBackView.h"

@interface CLShowVC ()<SWTableViewCellDelegate, CLNewShowVCDelegate>

@property (nonatomic, strong) CLTableBackView *tableBackView;

@end

@implementation CLShowVC

- (CLShowModel *)showModel {
    
    if (!_showModel) {
        _showModel = [CLShowModel showModel];
    }
    return _showModel;
}

- (CLTableBackView *)tableBackView {
    if (!_tableBackView) {
        _tableBackView = [CLTableBackView tableBackView];
    }
    return _tableBackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsMultipleSelection = NO;

    self.tableView.rowHeight = kListCellHeight;

    self.tableView.backgroundView = self.tableBackView;
    self.tableBackView.hidden = !(self.showModel.openerShow.count == 0 && self.showModel.middleShow.count == 0 && self.showModel.endingShow.count == 0);
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.backgroundColor = kDisplayBgColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListImageCellID];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number;
    
    switch (section) {
        case 0:
            number = self.showModel.openerShow.count;
            break;
            
        case 1:
            number = self.showModel.middleShow.count;
            break;
            
        case 2:
            number = self.showModel.endingShow.count;
            break;
            
        default:
            break;
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLListImageCell *listCell = (CLListImageCell *)cell;
    
    NSString *imageName, *name, *effect;
    
    CLRoutineModel *model;
    switch (indexPath.section) {
        case 0:
            model = self.showModel.openerShow[indexPath.row];
            break;
            
        case 1:
            model = self.showModel.middleShow[indexPath.row];
            break;
            
        case 2:
            model = self.showModel.endingShow[indexPath.row];
            break;
            
        default:
            break;
    }
    
    listCell.picCnt = model.picCnt;
    listCell.vidCnt = model.vidCnt;
    listCell.tags = model.tags;
    
//    imageName = [model getImage];
    name = model.infoModel.name;
    
    
    if (model.isStarred) {
        if (model.effectModel.isWithEffect) {
            effect = [NSString stringWithFormat:@"★%@", model.effectModel.effect];
        } else {
            effect = @"★";
        }
    } else {
        effect = model.effectModel.effect;
    }
    
//    listCell.imageName = imageName;
//    listCell.dateLabel.text = date;
    listCell.titleLabel.text = name;
    
    listCell.contentLabel.text = effect;
    
    listCell.rightUtilityButtons = [self rightButtons];
    listCell.delegate = self;

}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    //    [rightUtilityButtons sw_addUtilityButtonWithColor:
    //     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
    //                                                title:@"setting"];
    //    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor grayColor] icon:[UIImage imageNamed:@"setting"]];
    
    return rightUtilityButtons;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
        
    } else {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kLabelHeight)];
        view.backgroundColor = [UIColor lightGrayColor];
        view.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
        view.layer.borderWidth = 0.5;
        
        view.alpha = 0.95;
        
        UILabel *label = [[UILabel alloc] init];
        [view addSubview:label];
        
        label.frame = CGRectMake(kPadding, 0, kContentW, kLabelHeight);
        label.textAlignment =NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = kFontSys12;
        
        NSString *sectionTitle;
        if (section == 0) {
            sectionTitle = @"开场表演";
        } else if (section == 1) {
            sectionTitle = @"中场表演";
        } else if (section == 2) {
            sectionTitle = @"终场表演";
        }
        
        label.text = sectionTitle;
        
        return view;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:section] == 0) {
        return 0;
    }
    
    return kLabelHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:kShowToRoutineSegue sender:indexPath];
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSIndexPath *path = [self.tableView indexPathForCell:cell];
            
            switch (path.section) {
                case 0:
                    [self.showModel.openerShow removeObjectAtIndex:path.row];
                    break;
                    
                case 1:
                    [self.showModel.middleShow removeObjectAtIndex:path.row];
                    break;
                    
                case 2:
                    [self.showModel.endingShow removeObjectAtIndex:path.row];
                    break;
                    
                default:
                    break;
            }
            
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
            
            self.tableBackView.hidden = !(self.showModel.openerShow.count == 0 && self.showModel.middleShow.count == 0 && self.showModel.endingShow.count == 0);
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                [NSKeyedArchiver archiveRootObject:[(AppDelegate *)[[UIApplication sharedApplication] delegate] showModelList] toFile:kShowPath];
            });
            
            break;
        }
        case 1:
        {
  
            break;
        }
            
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
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
    
//    id destVC = [segue destinationViewController];
//    if ([destVC isKindOfClass:[CLRoutineVC class]]) {
//        CLRoutineVC *vc = (CLRoutineVC *)destVC;
////        vc.delegate = self;
//        vc.hidesBottomBarWhenPushed = YES;
//        
//        if ([sender isKindOfClass:[NSIndexPath class]]) {
//            NSIndexPath *path = (NSIndexPath *)sender;
//            vc.dataPath = path;
//            
//            CLRoutineModel *model;
//            if (path.section == 0) {
//                model = self.showModel.openerShow[path.row];
//            } else if (path.section == 1) {
//                model = self.showModel.middleShow[path.row];
//            } else if (path.section == 2) {
//                model = self.showModel.endingShow[path.row];
//            }
//            
//            vc.routineModel = model;
//            vc.title = vc.routineModel.infoModel.name;
//        }
//        
//    } else if ([destVC isKindOfClass:[CLNewShowVC class]]) {
//        CLNewShowVC *vc = (CLNewShowVC *)destVC;
//        vc.showModel = self.showModel;
//        vc.delegate = self;
//        vc.hidesBottomBarWhenPushed = YES;
//    }
}

- (void)newShowVC:(CLNewShowVC *)newShowVC didSaveShow:(CLShowModel *)showModel {
    [self.tableView reloadData];
    self.tableBackView.hidden = !(self.showModel.openerShow.count == 0 && self.showModel.middleShow.count == 0 && self.showModel.endingShow.count == 0);

    if ([self.delegate respondsToSelector:@selector(showVCDidFinishEditingShow:withShow:)]) {
        [self.delegate showVCDidFinishEditingShow:self withShow:self.showModel];
    }
}

@end
