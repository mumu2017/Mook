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
    
    [self setTableViewStatus];
    
    self.title = self.showModel.name;
    [self.tableView setEditing:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTagSelection) name:@"cancelTagSelection" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:kUpdateEntryVCNotification object:nil];
}

- (void)updateData {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)cancelTagSelection {
    if ([self.presentedViewController isKindOfClass:[CLTagChooseNavVC class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    if (self.presentedViewController == nil && [self.navigationController.topViewController isKindOfClass:[CLEdtingManageVC class]] == NO) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:self];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [CLDataSaveTool updateShow:self.showModel];
        });
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number = 0;
    
    if (section == 0) {
        number = 4;
    } else if (section == 1) {
        number = 1;
    } else if (section == 2) {
        number = self.routineModelList.count + 1;
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
            
            cell.titleLabel.text = @"演出标题";
            cell.inputTextField.placeholder = @"编辑演出标题";
            cell.inputTextField.text = self.showModel.name;
            cell.inputTextField.tag = kTagShowName;
//            self.titleTF = cell.inputTextField;
            cell.inputTextField.delegate = self;
        } else if (indexPath.row == 1) {
            
            cell.titleLabel.text = @"演出时长";
            cell.inputTextField.placeholder = @"演出时长(分钟)";
            cell.inputTextField.text = self.showModel.duration;
            cell.inputTextField.tag = kTagShowDuration;
            //            self.titleTF = cell.inputTextField;
            cell.inputTextField.delegate = self;
        } else if (indexPath.row == 2) {
            
            cell.titleLabel.text = @"演出场地";
            cell.inputTextField.placeholder = @"编辑演出场地";
            cell.inputTextField.text = self.showModel.duration;
            cell.inputTextField.tag = kTagShowPlace;
            //            self.titleTF = cell.inputTextField;
            cell.inputTextField.delegate = self;
        } else if (indexPath.row == 3) {
            
            cell.titleLabel.text = @"观众数量";
            cell.inputTextField.placeholder = @"最佳观众数量";
            cell.inputTextField.text = self.showModel.duration;
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
                
                cell.textLabel.font = kBoldFontSys16;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"演出说明";
                return cell;
            }
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            
            cell.textLabel.text = @"添加流程";
            cell.textLabel.font = kBoldFontSys16;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        } else {
            CLRoutineModel *model = self.routineModelList[indexPath.row - 1];
            UIImage *image = [model getImage];
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
    }
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textField 代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.textAlignment = NSTextAlignmentLeft;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.textAlignment = NSTextAlignmentRight;
    self.showModel.name = textField.text;
    
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
