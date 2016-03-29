//
//  CLShowListVC.m
//  Mook
//
//  Created by 陈林 on 15/12/19.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLShowListVC.h"
#import "CLShowModel.h"

#import "CLShowVC.h"
#import "CLNewShowVC.h"

#import "CLListImageCell.h"

#import "CLTableBackView.h"

@interface CLShowListVC ()<CLNewShowVCDelegate, SWTableViewCellDelegate, CLShowVCDelegate>

@property (nonatomic, strong) CLTableBackView *tableBackView;

@end

@implementation CLShowListVC

- (NSMutableArray *)showModelList {
    if (!_showModelList) {
        _showModelList = [(AppDelegate *)[[UIApplication sharedApplication] delegate] showModelList];
        
    }
    return _showModelList;
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

    //    self.extendedLayoutIncludesOpaqueBars = YES;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.backgroundColor = kDisplayBgColor;
    
    self.tableView.backgroundView = self.tableBackView;
    self.tableBackView.hidden = !(self.showModelList.count == 0);
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.rowHeight = kListCellHeight;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListImageCellID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
}

- (IBAction)addButtonClicked:(id)sender {
    [self addNewShow];
}

- (void)addNewShow {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加演出" message:@"请输入演出名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"演出名称";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;

        textField.font = kFontSys16;
//        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];

    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"演出时长(分钟)";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;

        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.font = kFontSys16;
//        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *nameTF = alertController.textFields[0];
        UITextField *timeTF = alertController.textFields[1];
        
        // 创建一个新的Model,传递给newShowVC,并添加到ModelList中
        CLShowModel *model = [CLShowModel showModel];
        model.name = nameTF.text;
        model.time = timeTF.text;
        
        // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] showModelList] insertObject:model atIndex:0];
        
        self.tableBackView.hidden = !(self.showModelList.count == 0);
        // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tagModelList中
        if (self.tag.length > 0 && self.showModelList != [(AppDelegate *)[[UIApplication sharedApplication] delegate] showModelList]) {
            [model.tags addObject:self.tag];
            [self.showModelList insertObject:model atIndex:0];
        }

        [self performSegueWithIdentifier:kShowListAddNewShowSegue sender:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];

    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];

    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = NO;
    }];
}

- (void)editNameWithIndexPath:(NSIndexPath *)path {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"编辑名称" message:@"请输入演出名称" preferredStyle:UIAlertControllerStyleAlert];
    
    CLShowModel *model = self.showModelList[path.row];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"演出名称";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;

        textField.font = kFontSys16;
//        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        textField.text = model.name;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"演出时长(分钟)";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;

        textField.font = kFontSys16;
//        textField.borderStyle = UITextBorderStyleRoundedRect;

        textField.text = model.time;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *nameTF = alertController.textFields.firstObject;
        UITextField *timeTF = alertController.textFields[1];

        model.name = nameTF.text;
        model.time = timeTF.text;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];

    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        UITextField *nameTF = alertController.textFields[0];
        UITextField *timeTF = alertController.textFields[1];
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = nameTF.text.length > 0 && timeTF.text.length > 0;
    }];

}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *nameTF = alertController.textFields[0];
        UITextField *timeTF = alertController.textFields[1];
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = nameTF.text.length > 0 && timeTF.text.length > 0;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.showModelList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLListImageCell *listCell = (CLListImageCell *)cell;
    
    NSString *imageName, *name, *effect;
    
    CLShowModel *model = self.showModelList[indexPath.row];
    
    listCell.picCnt = model.picCnt;
    listCell.vidCnt = model.vidCnt;
    listCell.tags = model.tags;
    
    imageName = [model getImage];
    
    NSString *time = [model.time stringByAppendingString:@"分钟"];
    NSInteger count = model.openerShow.count + model.middleShow.count + model.endingShow.count;
    
    if (model.isStarred) {
        effect = [NSString stringWithFormat:@"★时长:%@  流程数:%ld个", time, (long)count];
    } else {
        effect = [NSString stringWithFormat:@"时长:%@  流程数:%ld个", time, (long)count];
        
    }
    
    name = model.name;
    
    
//    listCell.imageName = imageName;
//    listCell.dateLabel.text = date;
    listCell.titleLabel.text = name;
    
    listCell.contentLabel.text = effect;
    
    listCell.rightUtilityButtons = [self rightButtons];
    listCell.delegate = self;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:kShowListToShowSegue sender:cell];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:kSwipeCellButtonColor title:@"编辑"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    
    return rightUtilityButtons;
}

#pragma mark - SWTableViewDelegate


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];

    switch (index) {
        case 0:
        {
            [self editNameWithIndexPath:path];
            break;
        }
        case 1:
        {
            CLShowModel *model = self.showModelList[path.row];
            
            if (self.tag.length > 0 && self.showModelList != [(AppDelegate *)[[UIApplication sharedApplication] delegate] showModelList]) {
                [self.showModelList removeObject:model];
            }
            
            [[(AppDelegate *)[[UIApplication sharedApplication] delegate] showModelList] removeObject:model];
            
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            
            self.tableBackView.hidden = !(self.showModelList.count == 0);

            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                [NSKeyedArchiver archiveRootObject:[(AppDelegate *)[[UIApplication sharedApplication] delegate] showModelList] toFile:kShowPath];
            });
            
            if ([self.delegate respondsToSelector:@selector(showListVCDidEdit:)]) {
                [self.delegate showListVCDidEdit:self];
            }
            
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


#pragma mark - segue方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[CLShowVC class]]) {
        CLShowVC *vc = (CLShowVC *)destVC;
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;

        if ([sender isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell *)sender;
            NSIndexPath *path = [self.tableView indexPathForCell:cell];
            vc.dataPath = path;
            vc.showModel = self.showModelList[path.row];
            vc.title = vc.showModel.name;
        }
        
    } else if ([destVC isKindOfClass:[CLNewShowVC class]]) {
        CLNewShowVC *vc = (CLNewShowVC *)destVC;
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        
        vc.showModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] showModelList][0];

    }

}

- (void)newShowVC:(CLNewShowVC *)newShowVC didSaveShow:(CLShowModel *)showModel {
    
    [self.tableView reloadData];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [NSKeyedArchiver archiveRootObject:[(AppDelegate *)[[UIApplication sharedApplication] delegate] showModelList] toFile:kShowPath];
    });
    
    if ([self.delegate respondsToSelector:@selector(showListVCDidEdit:)]) {
        [self.delegate showListVCDidEdit:self];
    }
}

- (void)showVCDidFinishEditingShow:(CLShowVC *)showVC withShow:(CLShowModel *)show {
    
    [self.tableView reloadData];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [NSKeyedArchiver archiveRootObject:[(AppDelegate *)[[UIApplication sharedApplication] delegate] showModelList] toFile:kShowPath];
    });
}



@end
