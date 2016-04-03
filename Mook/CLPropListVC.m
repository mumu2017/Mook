//
//  CLPropListVC.m
//  Mook
//
//  Created by 陈林 on 15/11/20.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLPropListVC.h"
#import "CLDataSaveTool.h"
#import "CLNewEntryNavVC.h"

#import "CLListTextCell.h"
#import "CLListImageCell.h"

#import "CLNewEntryVC.h"
#import "CLPropObjModel.h"
#import "CLInfoModel.h"
#import "CLEffectModel.h"
#import "CLPrepModel.h"

#import "CLTableBackView.h"

@interface CLPropListVC ()<SWTableViewCellDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) CLTableBackView *tableBackView;

@end

@implementation CLPropListVC

- (NSMutableArray *)propObjModelList {
    if (!_propObjModelList) {
        _propObjModelList = [(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList];
    
    }
    return _propObjModelList;
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


    self.tableView.backgroundView = self.tableBackView;
    self.tableBackView.hidden = !(self.propObjModelList.count == 0);
    
    // 选择模式下,不显示导航栏右边的按钮
    if (self.delegate) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSelection)];
    }

//    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.rowHeight = kListCellHeight;
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"CLListTextCell"
//                                               bundle:nil]
//         forCellReuseIdentifier:kListTextCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListImageCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListTextCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListTextCellID];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:kUpdatePropsNotification object:nil];
}

- (void) update {
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cancelSelection {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"cancelSelection" object:nil]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.viewIsShowing = NO;
//    [self.tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.viewIsShowing = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.propObjModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLPropObjModel *model = self.propObjModelList[indexPath.row];

    NSString *imageName;
//    imageName = [model getThumbnail];
    
    if (imageName != nil) { // 如果没有返回图片名称,则表示模型中没有图片或多媒体
        CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
        
//        cell.imageName = imageName;
        [cell setTitle:[model getTitle] content:[model getContent]];
        
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        
        return cell;
        
    } else {
        CLListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kListTextCellID forIndexPath:indexPath];
        
        [cell setTitle:[model getTitle] content:[model getContent]];
        
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        
        return cell;
    }
    
    return nil;

    
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CLListImageCell *listCell = (CLListImageCell *)cell;
//    
//    NSString *imageName, *date, *name, *effect;
//    BOOL isStarred = NO;
//    
//
//    listCell.picCnt = model.picCnt;
//    listCell.vidCnt = model.vidCnt;
//    listCell.tags = model.tags;
//    
//    imageName = [model getThumbnail];
//    isStarred = model.isStarred;
//    date = model.date;
//    name = model.infoModel.name;
//    
//    
//    if (model.isStarred) {
//        if (model.effectModel.isWithEffect) {
//            effect = [NSString stringWithFormat:@"★%@", model.effectModel.effect];
//        } else {
//            effect = @"★";
//        }
//    } else {
//        effect = model.effectModel.effect;
//    }
//    
//    listCell.imageName = imageName;
//    listCell.dateLabel.text = date;
//    listCell.titleLabel.text = name;
//    
//    listCell.contentLabel.text = effect;
//    
//    listCell.rightUtilityButtons = [self rightButtons];
//    listCell.delegate = self;
//    
//}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:kSwipeCellButtonColor title:@"编辑"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];

    
    //    [rightUtilityButtons sw_addUtilityButtonWithColor:
    //     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
    //                                                title:@"setting"];
    //    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor grayColor] icon:[UIImage imageNamed:@"setting"]];
    
    return rightUtilityButtons;
}


#pragma mark - SWTableViewDelegate

//- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
//{
//    switch (state) {
//        case 0:
//            NSLog(@"utility buttons closed");
//            break;
//        case 2:
//            NSLog(@"right utility buttons open");
//            break;
//        default:
//            break;
//    }
//}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];

    switch (index) {
        
        case 0:
        {

            break;
        }
        case 1:
        {
            
            CLPropObjModel *model = [self.propObjModelList objectAtIndex:path.row];
//            [self deleteMediaFromModel:model];
            
            if (self.tag.length > 0 && self.propObjModelList != [(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList]) {
                [self.propObjModelList removeObject:model];
            }
            
            [[(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList] removeObject:model];
            
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            
            self.tableBackView.hidden = !(self.propObjModelList.count == 0);
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                [NSKeyedArchiver archiveRootObject:[(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList] toFile:kPropPath];
                [CLDataSaveTool deleteProp:model];
            });
            break;
        }
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];

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

#pragma mark - segue 方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate) {
        
        if ([self.delegate respondsToSelector:@selector(propListVC:didSelectProp:)]) {
            [self.delegate propListVC:self didSelectProp:self.propObjModelList[indexPath.row]];
        }
    } else {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:kPropListToPropSegue sender:cell];
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 添加数据

- (IBAction)addButtonClicked:(id)sender {
    [self addNewProp];
}

- (void)addNewProp {
    
        // 创建一个新的ideaObjModel,传递给newIdeaVC,并添加到ideaObjModelList中
    CLPropObjModel *model = [CLPropObjModel propObjModel];
    
    //        [self.propObjModelList addObject:model];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList] insertObject:model atIndex:0];
    
    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到propModelList中
    if (self.tag.length > 0 && self.propObjModelList != [(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList]) {
        [model.tags addObject:self.tag];
        [self.propObjModelList insertObject:model atIndex:0];
    }
    
    self.tableBackView.hidden = !(self.propObjModelList.count == 0);
    
    [self performSegueWithIdentifier:kPropListToNewPropSegue sender:nil];
}

#pragma mark - segue方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[CLNewEntryNavVC class]]) {
        CLNewEntryNavVC *vc = (CLNewEntryNavVC *)destVC;
        //        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        
        vc.editingContentType = kEditingContentTypeProp;
        
        vc.propObjModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList][0];
    }
        
//        if ([destVC isKindOfClass:[CLNewEntryVC class]]) {
//        CLNewEntryVC *vc = (CLNewEntryVC *)destVC;
//        vc.editingContentType = kEditingContentTypeProp;
////        vc.delegate = self;
//        vc.hidesBottomBarWhenPushed = YES;
//        
//        // 创建一个新的ideaObjModel,传递给newIdeaVC,并添加到ideaObjModelList中
////        CLPropObjModel *model = [CLPropObjModel propObjModel];
//        vc.propObjModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList][0];
//        [self.propObjModelList addObject:model];
//        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList] insertObject:model atIndex:0];
        
//        // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到propModelList中
//        if (self.tag.length > 0 && self.propObjModelList != [(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList]) {
//            [model.tags addObject:self.tag];
//            [self.propObjModelList insertObject:model atIndex:0];
//        }
//    }
}

#pragma mark 新建流程代理方法
//- (void)newEntryVC:(CLNewEntryVC *)vc saveProp:(CLPropObjModel *)propObjModel {
//    
//    [self.tableView reloadData];
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [NSKeyedArchiver archiveRootObject:[(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList] toFile:kPropPath];
//    });
//}

#pragma mark 流程信息页代理方法
//- (void)propVCDidFinishEditingProp:(CLPropVC *)propVC withProp:(CLPropObjModel *)prop {
//    
//    [self.tableView reloadData];
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [NSKeyedArchiver archiveRootObject:[(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList] toFile:kPropPath];
//    });
//    
//}

//- (void)propVCDidDeleteProp:(CLPropVC *)propVC withProp:(CLPropObjModel *)prop {
//    
//    if (self.viewIsShowing) {
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.propObjModelList removeObject:prop];
//            NSIndexPath *path = propVC.dataPath;
//            ;
//            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
//            
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                [NSKeyedArchiver archiveRootObject:[(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList] toFile:kPropPath];
//            });
//        });
//    }
//}

//- (void)deleteMediaFromModel:(CLPropObjModel *)model {
//    //文件名
//    NSString *imageName;
//    NSString *videoName;
//    
//    if (model.effectModel.image.length != 0) {
//        imageName = model.effectModel.image;
//        [imageName deleteNamedFileFromDocument];
//    }
//    
//    if (model.effectModel.video.length != 0) {
//        videoName = model.effectModel.video;
//        [videoName deleteNamedFileFromDocument];
//    }
//    
//    for (CLPrepModel *prepModel in model.prepModelList) {
//        if (prepModel.image.length != 0) {
//            imageName = prepModel.image;
//            [imageName deleteNamedFileFromDocument];
//        }
//        
//        if (prepModel.video.length != 0) {
//            videoName = prepModel.video;
//            [videoName deleteNamedFileFromDocument];
//        }
//    }
//}

@end
