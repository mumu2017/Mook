//
//  CLNewShowVC.m
//  Mook
//
//  Created by 陈林 on 15/12/19.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLNewShowVC.h"
#import "CLShowModel.h"
#import "CLDataSaveTool.h"
#import "CLListVC.h"

#import "CLNewShowNavVC.h"
#import "CLEdtingManageVC.h"

#import "CLRoutineModel.h"
#import "CLInfoModel.h"
#import "CLEffectModel.h"

#import "CLNewEntryImageCell.h"
#import "CLNewEntryTextCell.h"
#import "CLTextInputCell.h"

#import "CLTagField.h"
#import "SMTag.h"
#import "SMTagField.h"

#import "CLTagChooseNavVC.h"
#import "CLRoutineChooseVC.h"

#define kTagShowName        0
#define kTagShowDuration    1
#define kTagShowPlace       2
#define kTagShowAudiance    3

@interface CLNewShowVC ()<UITextFieldDelegate, SMTagFieldDelegate, SWTableViewCellDelegate, CLTagChooseNavVCDelegate, CLRoutineChooseVCDelegate>

@property (nonatomic, strong) CLTagField *tagField;
@property (nonatomic, strong) NSMutableArray *allTags;
@property (nonatomic, strong) NSMutableArray *allTagsShow;

@property (nonatomic, strong) NSMutableArray <CLRoutineModel*> *routineModelList;
@property (nonatomic, assign) BOOL newEntryCancelled;
@property (nonatomic, assign) BOOL currentEntryDelteted;
@end

@implementation CLNewShowVC

#pragma mark - 懒加载数据

- (NSMutableArray *)allTags {
    if (!_allTags) _allTags = kDataListTagAll;  return _allTags;
}

- (NSMutableArray *)allTagsShow {
    if (!_allTagsShow) _allTagsShow = kDataListTagShow;  return _allTagsShow;
}

// 懒加载routineModel
- (CLShowModel *)showModel {
    if (!_showModel) {
        _showModel = [CLShowModel showModel];
    }
    return _showModel;
}

- (NSMutableArray<CLRoutineModel *> *)routineModelList {
    if (!_routineModelList) {
        _routineModelList = [self.showModel getRountineModelList];
    }
    return _routineModelList;
}

#pragma mark 懒加载 view
- (CLTagField *)tagField {
    if (!_tagField) {
        _tagField = [CLTagField tagField];
        _tagField.frame = CGRectMake(0, 0, kScreenW, 55);
        
        _tagField.tagField.tagDelegate = self;
        [_tagField.tagField setTags:self.showModel.tags];
    }
    return _tagField;
}


#pragma mark - viewController方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.newEntryCancelled = NO; //加载视图时, 自动设置取消状态为否定
    // 如果是导航控制器是CLNewEntryNavVC, 说明是新建条目,所以提供取消按钮
    if ([self.navigationController isKindOfClass:[CLNewShowNavVC class]]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNewCreation)];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    [self setTableViewStatus];
    
    [self.tableView setEditing:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTagSelection) name:@"cancelTagSelection" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:kUpdateEntryVCNotification object:nil];
}

- (void)updateData {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)cancelNewCreation {

    self.newEntryCancelled = YES;

   [[NSNotificationCenter defaultCenter] postNotificationName:kCancelEntryNotification object:self.showModel];

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)cancelTagSelection {
    if ([self.presentedViewController isKindOfClass:[CLTagChooseNavVC class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.currentEntryDelteted = NO;
}

- (void)setTableViewStatus {
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.rowHeight = 44;

    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.tableHeaderView = self.tagField;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLTextInputCell"
                                               bundle:nil]
         forCellReuseIdentifier:KTextInputCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLNewEntryImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kNewEntryImageCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLNewEntryTextCell"
                                               bundle:nil]
         forCellReuseIdentifier:kNewEntryTextCellID];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.currentEntryDelteted) { // 如果已经删除了当前内容, 直接退出
        return;
    }
    
    if (self.newEntryCancelled) {
        return;
    }
    
    // 不删除也不取消, 则需要保存数据

    if (self.presentedViewController == nil && [self.navigationController.topViewController isKindOfClass:[CLEdtingManageVC class]] == NO) {
        
        [CLDataSaveTool updateShow:self.showModel];

        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger number = 0;
    // 如果是导航控制器是CLNewEntryNavVC, 说明是新建条目,所以提供取消按钮
    if ([self.navigationController isKindOfClass:[CLNewShowNavVC class]]) {
        // 可以取消, 所以不需要删除行
        number = 3;
    } else {
        number = 4;    // 是编辑的情况, 添加删除行
    }
    
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number = 0;
    
    if (section == 0) {
        number = 4;
    } else if (section == 1) {
        number = 1;
    } else if (section == 2) {
        number = self.routineModelList.count + 1;
    } else if (section == 3) {
        number = 1; // 删除行
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"ID";
    
    if (indexPath.section == 0) {
        CLTextInputCell *cell = [tableView dequeueReusableCellWithIdentifier:KTextInputCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.inputTextField.font = kFontSys16;

        if (indexPath.row == 0) {
            
            cell.titleLabel.text = NSLocalizedString(@"演出标题", nil);
            cell.inputTextField.placeholder = NSLocalizedString(@"编辑演出标题", nil);
            cell.inputTextField.text = self.showModel.name;
            cell.inputTextField.tag = kTagShowName;
//            self.titleTF = cell.inputTextField;
            cell.inputTextField.delegate = self;
        } else if (indexPath.row == 1) {
            
            cell.titleLabel.text = NSLocalizedString(@"演出时长", nil);
            cell.inputTextField.placeholder = NSLocalizedString(@"演出时长(分钟)", nil);
            cell.inputTextField.text = self.showModel.duration;
            cell.inputTextField.tag = kTagShowDuration;
            //            self.titleTF = cell.inputTextField;
            cell.inputTextField.delegate = self;
        } else if (indexPath.row == 2) {
            
            cell.titleLabel.text = NSLocalizedString(@"演出场地", nil);
            cell.inputTextField.placeholder = NSLocalizedString(@"编辑演出场地", nil);
            cell.inputTextField.text = self.showModel.place;
            cell.inputTextField.tag = kTagShowPlace;
            //            self.titleTF = cell.inputTextField;
            cell.inputTextField.delegate = self;
        } else if (indexPath.row == 3) {
            
            cell.titleLabel.text = NSLocalizedString(@"观众数量", nil);
            cell.inputTextField.placeholder = NSLocalizedString(@"最佳观众数量", nil);
            cell.inputTextField.text = self.showModel.audianceCount;
            cell.inputTextField.tag = kTagShowAudiance;
            //            self.titleTF = cell.inputTextField;
            cell.inputTextField.delegate = self;
        }
        return cell;
    } else if (indexPath.section == 1) {
        if (self.showModel.effectModel.isWithImage || self.showModel.effectModel.isWithVideo) {
            CLNewEntryImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryImageCellID];
            if (self.showModel.effectModel.isWithImage) {
                [cell.iconView setImage:[self.showModel.effectModel.image getNamedImageThumbnail]];
            } else if (self.showModel.effectModel.isWithVideo) {
                [cell.iconView setImage:[self.showModel.effectModel.video getNamedVideoThumbnail]];
                
            }
            
            cell.contentLabel.font = kFontSys16;
            cell.contentLabel.text = self.showModel.effectModel.effect;
            return cell;
            
        } else {
            
            if (self.showModel.effectModel.isWithEffect) {
                
                CLNewEntryTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryTextCellID];
                
                cell.contentLabel.font = kFontSys16;
                cell.contentLabel.text = self.showModel.effectModel.effect;
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                return cell;
                
            } else {
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                }
                
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.textLabel.font = kBoldFontSys16;
                cell.textLabel.textColor = [UIColor blackColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                cell.textLabel.text = NSLocalizedString(@"演出说明", nil);
                return cell;
            }
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            
            cell.textLabel.text = NSLocalizedString(@"添加流程", nil);
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = kBoldFontSys16;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            return cell;
        } else {
            CLRoutineModel *model = self.routineModelList[indexPath.row - 1];
            UIImage *image = [model getThumbnail];
            if (image) {
                CLNewEntryImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryImageCellID];
                
                [cell.iconView setImage:image];
                cell.contentLabel.text = [model getTitle];
                
                return cell;
            } else {
                CLNewEntryTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryTextCellID];
                
                cell.contentLabel.text = [model getTitle];
                
                return cell;
            }
        }
    } else if (indexPath.section == 3) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cell.backgroundColor = [UIColor redColor];
        cell.textLabel.text = NSLocalizedString(@"删除", nil);
        cell.textLabel.font = kBoldFontSys16;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    return nil;
}


#pragma mark - tableView 编辑方法
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    }
    
    if (indexPath.section == 1) {
        if (self.showModel.effectModel.isWithEffect || self.showModel.effectModel.isWithImage || self.showModel.effectModel.isWithVideo) {
            return YES;
        }
    }
    if (indexPath.section == 2) {
        return (indexPath.row > 0);
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return UITableViewCellEditingStyleDelete;
    
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
   if (editingStyle == UITableViewCellEditingStyleDelete) {
        
       if (indexPath.section == 1) {
           self.showModel.effectModel.effect = nil;
           NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
           [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
           
       } else {
           CLRoutineModel *model = self.routineModelList[indexPath.row - 1];
           NSString *timeStamp = model.timeStamp;
           [self.showModel.routineTimeStampList removeObject:timeStamp];
           [self.routineModelList removeObject:model];
           
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
       }
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    // 如果跨section交换cell,或者将cell换到第一栏,则不进行交换
    if (fromIndexPath.section != toIndexPath.section || toIndexPath.row == 0) {
        [self.tableView reloadData];
        return;
    }
        
    CLRoutineModel *model = self.routineModelList[fromIndexPath.row - 1];
    NSString *timeStamp = self.showModel.routineTimeStampList[fromIndexPath.row - 1];
    if ([timeStamp isEqualToString:model.timeStamp]) { // 如果真的匹配才交换
        [self.showModel.routineTimeStampList removeObjectAtIndex:fromIndexPath.row-1];
        [self.showModel.routineTimeStampList insertObject:timeStamp atIndex:toIndexPath.row - 1];
        [self.routineModelList removeObjectAtIndex:fromIndexPath.row - 1];
        [self.routineModelList insertObject:model atIndex:toIndexPath.row - 1];
    } else { // 如果showModel.routineTimeStampList对应位置的timeStamp与model中的不对应,则不交换.
        return;
    }

}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2 && [self.tableView numberOfRowsInSection:2] >= 2) return YES;
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1 && indexPath.row == 0) {
        [self performSegueWithIdentifier:kSegueNewShowToEditingSegue sender:nil];
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        [self performSegueWithIdentifier:kSegueNewShowToRoutineChoose sender:nil];
    } else if (indexPath.section == 3 && indexPath.row == 0) {
        [self deleteCurrentShow];
    }
}

- (void)deleteCurrentShow {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"删除内容", nil) message:NSLocalizedString(@"提示: 删除内容后将无法恢复,确定要删除当前内容吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"delete current entry");
            
            self.currentEntryDelteted = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteEntryNotification object:self.showModel];
            
        });
        
        //This for loop iterates through all the view controllers in navigation stack.
        for (UIViewController* viewController in self.navigationController.viewControllers) {
            
            if ([viewController isKindOfClass:[CLListVC class]] ) {
                
                CLListVC *vc = (CLListVC*)viewController;
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - segue 方法

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id destVC = [segue destinationViewController];
    
    if ([destVC isKindOfClass:[CLEdtingManageVC class]]) {
        CLEdtingManageVC *vc = (CLEdtingManageVC *)destVC;
        vc.showModel = self.showModel;
        vc.editingContentType = kEditingContentTypeShow;
        vc.selectedVCIndex = 0;
        
    } else if ([destVC isKindOfClass:[CLTagChooseNavVC class]]) {
        CLTagChooseNavVC *vc = (CLTagChooseNavVC *)destVC;
        vc.navDelegate = self;
        vc.editingContentType = kEditingContentTypeShow;
    } else if ([destVC isKindOfClass:[CLRoutineChooseVC class]]) {
        CLRoutineChooseVC *vc = (CLRoutineChooseVC *)destVC;
        vc.delegate = self;
    }
}

- (void)routineChooseVC:(CLRoutineChooseVC *)routineChooseVC didPickRoutines:(NSArray *)pickedRoutines {
    
    NSString *timeStamp;
    
    for (CLRoutineModel *model in pickedRoutines) {
        timeStamp = model.timeStamp;
        if ([self.showModel.routineTimeStampList containsObject:timeStamp] == NO) {
            [self.showModel.routineTimeStampList addObject:timeStamp];
            if ([self.routineModelList containsObject:model] == NO) {
                [self.routineModelList addObject:model];
            }
        } else {
            // 如果已经包含有选择的流程,则不做任何操作.
        }
    }
    // 添加完成之后,刷新表格
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:2];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - 保存数据
- (IBAction)saveButtonClicked:(UIBarButtonItem *)sender {
    
    if ([self.navigationController isKindOfClass:[CLNewShowNavVC class]]) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kDismissNewShowNavVCNotification object:nil]];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - textField 代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.textAlignment = NSTextAlignmentLeft;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.textAlignment = NSTextAlignmentRight;
    
    switch (textField.tag) {
        case kTagShowName:
            self.showModel.name = textField.text;
            break;
            
        case kTagShowDuration:
            self.showModel.duration = textField.text;
            break;
            
        case kTagShowPlace:
            self.showModel.place = textField.text;
            break;
            
        case kTagShowAudiance:
            self.showModel.audianceCount = textField.text;
            break;
            
        default:
            break;
    }
}

#pragma mark - tagField 代理方法
- (void)tagField:(SMTagField *)tagField tagAdded:(NSString *)tag {
    
    if ([self.showModel.tags containsObject:tag] == NO) {
        [
         self.showModel.tags addObject: tag];
    }
    
    if ([self.allTags containsObject:tag] == NO) {
        [self.allTags insertObject:tag atIndex:0];
        
    }
    if ([self.allTagsShow containsObject:tag] == NO) {
        [self.allTagsShow insertObject:tag atIndex:0];
    }
    [CLDataSaveTool addTag:tag type:kTypeShow];
}

- (void)tagField:(SMTagField *)tagField tagRemoved:(NSString *)tag {
    if ([self.showModel.tags containsObject:tag]) {
        [self.showModel.tags removeObject: tag];
    }
    
}

- (void)tagField:(SMTagField *)tagField tagsChanged:(NSArray *)tags {
    
}

- (void)tagFieldAddButtonClicked:(SMTagField *)tagField {
    
    [self performSegueWithIdentifier:kNewShowChooseTagSegue sender:nil];
}

#pragma tagchoose 代理方法
- (void)tagChooseNavVC:(CLTagChooseNavVC *)tagChooseNavVC didSelectTag:(NSString *)tag {

    [self dismissViewControllerAnimated:YES completion:^{
        self.tagField.tagField.text = tag;
        
        if(self.tagField.tagField.text.length > 0)
            self.tagField.tagField.text = [self.tagField.tagField.text stringByAppendingString:@" "];
        
        [self.tagField.tagField textFieldDidChange:nil];
    }];
    
}


@end
