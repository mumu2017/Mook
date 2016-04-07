//
//  CLNewRoutineVC.m
//  Mook
//
//  Created by 陈林 on 15/12/7.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLNewEntryVC.h"
#import "CLNewEntryNavVC.h"

#import "CLDataSaveTool.h"

#import "CLTagChooseNavVC.h"

#import "CLPerformModel.h"
#import "CLPrepModel.h"
#import "CLInfoModel.h"
#import "CLEffectModel.h"
#import "CLPropModel.h"
#import "CLNotesModel.h"

#import "CLRoutineModel.h"
#import "CLIdeaObjModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"

#import "CLEditingVC.h"
#import "CLPropInputVC.h"
#import "CLEdtingManageVC.h"

#import "CLNewEntryImageCell.h"
#import "CLNewEntryTextCell.h"
#import "CLTextInputCell.h"

#import "CLTagField.h"
#import "SMTag.h"
#import "SMTagField.h"

@interface CLNewEntryVC()<UITextFieldDelegate, SMTagFieldDelegate, CLEditingVCDelegate, CLPropInputVCDelegate, CLTagChooseNavVCDelegate>

@property (nonatomic, strong) CLTagField *tagField;

@property (nonatomic, strong) NSMutableArray *allTags;
@property (nonatomic, strong) NSMutableArray *allTagsIdea;
@property (nonatomic, strong) NSMutableArray *allTagsRoutine;
@property (nonatomic, strong) NSMutableArray *allTagsSleight;
@property (nonatomic, strong) NSMutableArray *allTagsProp;
@property (nonatomic, strong) NSMutableArray *allTagsLines;

@property (nonatomic, strong) NSMutableArray <NSString*> *tags;

@property (nonatomic, strong) CLInfoModel *infoModel;
@property (nonatomic, strong) CLEffectModel *effectModel;
@property (nonatomic, strong) NSMutableArray <CLPropModel*> *propModelList;
@property (nonatomic, strong) NSMutableArray <CLPrepModel*> *prepModelList;
@property (nonatomic, strong) NSMutableArray <CLPerformModel*> *performModelList;
@property (nonatomic, strong) NSMutableArray <CLNotesModel*> *notesModelList;

@property (nonatomic, strong) UITextField *titleTF;

@property (nonatomic, copy) NSString *entryTitle;

@property (nonatomic, copy) NSString *deleteMessage;

@property (nonatomic, assign) NSInteger prepSection;
@property (nonatomic, assign) BOOL newEntryCancelled;

@end

@implementation CLNewEntryVC

#pragma mark - 懒加载数据

- (NSMutableArray *)allTags {
    if (!_allTags) _allTags = kDataListTagAll;  return _allTags;
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



- (NSString *)entryTitle {
    if (_entryTitle == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _entryTitle = NSLocalizedString(@"编辑流程名称", nil);
                break;
                
            case kEditingContentTypeIdea:
                _entryTitle = NSLocalizedString(@"编辑灵感标题", nil);
                break;
                
            case kEditingContentTypeSleight:
                _entryTitle = NSLocalizedString(@"编辑技巧名称", nil);
                break;
                
            case kEditingContentTypeProp:
                _entryTitle = NSLocalizedString(@"编辑道具名称", nil);
                break;
                
            case kEditingContentTypeLines:
                _entryTitle = NSLocalizedString(@"编辑台词标题", nil);
                break;
                
            default:
                break;
        }
    }
    return _entryTitle;
}

- (NSInteger)prepSection {
    
    if (self.editingContentType == kEditingContentTypeRoutine) {
        _prepSection = 3;
    } else {
        _prepSection = 2;
    }
    
    return _prepSection;
}

- (NSMutableArray<NSString *> *)tags {
    
    if (_tags == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _tags = self.routineModel.tags;
                break;
                
            case kEditingContentTypeIdea:
                _tags = self.ideaObjModel.tags;
                break;
                
            case kEditingContentTypeSleight:
                _tags = self.sleightObjModel.tags;
                break;
                
            case kEditingContentTypeProp:
                _tags = self.propObjModel.tags;
                break;
                
            case kEditingContentTypeLines:
                _tags = self.linesObjModel.tags;
                break;
                
            default:
                break;
        }
    }
    
    return _tags;
}

- (CLInfoModel *)infoModel {
    
    if (_infoModel == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _infoModel = self.routineModel.infoModel;
                break;
                
            case kEditingContentTypeIdea:
                _infoModel = self.ideaObjModel.infoModel;
                break;
                
            case kEditingContentTypeSleight:
                _infoModel = self.sleightObjModel.infoModel;
                break;
                
            case kEditingContentTypeProp:
                _infoModel = self.propObjModel.infoModel;
                break;
                
            case kEditingContentTypeLines:
                _infoModel = self.linesObjModel.infoModel;
                break;
                
            default:
                break;
        }
    }
    
    return _infoModel;
}

- (CLEffectModel *)effectModel {
    
    if (_effectModel == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _effectModel = self.routineModel.effectModel;
                break;
                
            case kEditingContentTypeIdea:
                _effectModel = self.ideaObjModel.effectModel;
                break;
                
            case kEditingContentTypeSleight:
                _effectModel = self.sleightObjModel.effectModel;
                break;
                
            case kEditingContentTypeProp:
                _effectModel = self.propObjModel.effectModel;
                break;
                
            case kEditingContentTypeLines:
                _effectModel = self.linesObjModel.effectModel;
                break;
                
            default:
                break;
        }
        
    }
    
    return _effectModel;
}

- (NSMutableArray  <CLPropModel*>*)propModelList {
    
    if (_propModelList == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _propModelList = self.routineModel.propModelList;
                break;
                
            default:
                break;
        }
    }
    // 如果模型数组中是空的,则自动生成一个空白模型放入数组中.
    if (_propModelList.count == 0) {
        CLPropModel *model = [CLPropModel propModel];
        [_propModelList addObject:model];
    }
    
    return _propModelList;
}

- (NSMutableArray  <CLPrepModel*>*)prepModelList {
    
    if (_prepModelList == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _prepModelList = self.routineModel.prepModelList;
                break;
                
            case kEditingContentTypeIdea:
                _prepModelList = self.ideaObjModel.prepModelList;
                break;
                
            case kEditingContentTypeSleight:
                _prepModelList = self.sleightObjModel.prepModelList;
                break;
                
            case kEditingContentTypeProp:
                _prepModelList = self.propObjModel.prepModelList;
                break;
                
            default:
                break;
        }
    }
    // 如果模型数组中是空的,则自动生成一个空白模型放入数组中.
    if (_prepModelList.count == 0) {
        CLPrepModel *model = [CLPrepModel prepModel];
        [_prepModelList addObject:model];
    }
    return _prepModelList;
}

- (NSMutableArray  <CLPerformModel*>*)performModelList {
    if (_performModelList == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _performModelList = self.routineModel.performModelList;
                break;
                
            default:
                break;
        }
    }
    // 如果模型数组中是空的,则自动生成一个空白模型放入数组中.
    if (_performModelList.count == 0) {
        CLPerformModel *model = [CLPerformModel performModel];
        [_performModelList addObject:model];
    }
    
    return _performModelList;
}

- (NSMutableArray  <CLNotesModel*>*)notesModelList {
    if (_notesModelList == nil) {
        switch (self.editingContentType) {
            case kEditingContentTypeRoutine:
                _notesModelList = self.routineModel.notesModelLsit;
                break;
                
            default:
                break;
        }
    }
    // 如果模型数组中是空的,则自动生成一个空白模型放入数组中.
    if (_notesModelList.count == 0) {
        CLNotesModel *model = [CLNotesModel notesModel];
        [_notesModelList addObject:model];
    }
    
    return _notesModelList;
}

// 懒加载routineModel
- (CLRoutineModel *)routineModel {
    if (!_routineModel) {
        _routineModel = [CLRoutineModel routineModel];
    }
    return _routineModel;
}

- (CLIdeaObjModel *)ideaObjModel {
    if (_ideaObjModel == nil) {
        _ideaObjModel = [CLIdeaObjModel ideaObjModel];
    }
    return _ideaObjModel;
}

- (CLSleightObjModel *)sleightObjModel {
    if (_sleightObjModel == nil) {
        _sleightObjModel = [CLSleightObjModel sleightObjModel];
    }
    return _sleightObjModel;
}

- (CLPropObjModel *)propObjModel {
    if (_propObjModel == nil) {
        _propObjModel = [CLPropObjModel propObjModel];
    }
    return _propObjModel;
}

- (CLLinesObjModel *)linesObjModel {
    if (_linesObjModel == nil) {
        _linesObjModel = [CLLinesObjModel linesObjModel];
    }
    return _linesObjModel;
}

#pragma mark 懒加载 view
- (CLTagField *)tagField {
    if (!_tagField) {
        _tagField = [CLTagField tagField];
        _tagField.frame = CGRectMake(0, 0, kScreenW, 55);
        
        _tagField.tagField.tagDelegate = self;
        [_tagField.tagField setTags:self.tags];
    }
    return _tagField;
}


#pragma mark - viewController方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.newEntryCancelled = NO; //加载视图时, 自动设置取消状态为否定
    // 如果是导航控制器是CLNewEntryNavVC, 说明是新建条目,所以提供取消按钮
    if ([self.navigationController isKindOfClass:[CLNewEntryNavVC class]]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelNewCreation)];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }

    
    [self setTableViewStatus];
    
    [self.tableView setEditing:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTagSelection) name:@"cancelTagSelection" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveEntryData) name:kDidMakeChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:kUpdateEntryVCNotification object:nil];

}

- (void)updateData {
    [self.tableView reloadData];

}

- (void)cancelNewCreation {
    
    switch (self.editingContentType) {
        case kEditingContentTypeRoutine:
            
            if ([kDataListRoutine containsObject:self.routineModel]) {
                [kDataListRoutine removeObject:self.routineModel];
            }
            
            if ([kDataListAll containsObject:self.routineModel]) {
                [kDataListAll removeObject:self.routineModel];
            }
            
            break;
            
        case kEditingContentTypeIdea:
            if ([kDataListIdea containsObject:self.ideaObjModel]) {
                [kDataListIdea removeObject:self.ideaObjModel];
            }
            
            if ([kDataListAll containsObject:self.ideaObjModel]) {
                [kDataListAll removeObject:self.ideaObjModel];
            }
            break;
            
        case kEditingContentTypeSleight:
            if ([kDataListSleight containsObject:self.sleightObjModel]) {
                [kDataListSleight removeObject:self.sleightObjModel];
            }
            
            if ([kDataListAll containsObject:self.sleightObjModel]) {
                [kDataListAll removeObject:self.sleightObjModel];
            }
            break;
            
        case kEditingContentTypeProp:
            if ([kDataListProp containsObject:self.propObjModel]) {
                [kDataListProp removeObject:self.propObjModel];
            }
            
            if ([kDataListAll containsObject:self.propObjModel]) {
                [kDataListAll removeObject:self.propObjModel];
            }
            break;
            
        case kEditingContentTypeLines:
            if ([kDataListLines containsObject:self.linesObjModel]) {
                [kDataListLines removeObject:self.linesObjModel];
            }
            
            if ([kDataListAll containsObject:self.linesObjModel]) {
                [kDataListAll removeObject:self.linesObjModel];
            }
            break;
            
        default:
            break;
    }
    
    self.newEntryCancelled = YES;
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

// 隐藏MBProgreeHUD
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)saveEntryData {
    if (self.editingContentType == kEditingContentTypeRoutine) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [CLDataSaveTool updateRoutine:self.routineModel];
        });
        
    } else if (self.editingContentType == kEditingContentTypeIdea) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [CLDataSaveTool updateIdea:self.ideaObjModel];
        });
    } else if (self.editingContentType == kEditingContentTypeSleight) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [CLDataSaveTool updateSleight:self.sleightObjModel];
        });
    } else if (self.editingContentType == kEditingContentTypeProp) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [CLDataSaveTool updateProp:self.propObjModel];
        });
    } else if (self.editingContentType == kEditingContentTypeLines) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [CLDataSaveTool updateLines:self.linesObjModel];
        });
    }

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.newEntryCancelled) { // 如果已经取消了新建项目, 则直接退出, 不再保存数据
        return;
    }
    
    self.infoModel.name = self.titleTF.text;
    if (self.presentedViewController == nil && [self.navigationController.topViewController isKindOfClass:[CLEdtingManageVC class]] == NO) {

        [self saveEntryData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:self];
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger number = 0;
    
    switch (self.editingContentType) {
        case kEditingContentTypeRoutine:
            number = 6;
            break;
            
        case kEditingContentTypeIdea:
            number = 3;
            break;
            
        case kEditingContentTypeSleight:
            number = 3;
            break;
            
        case kEditingContentTypeProp:
            number = 3;
            break;
            
        case kEditingContentTypeLines:
            number = 2;
            break;
            
        default:
            break;
    }
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number = 0;
    
    switch (section) {
            
        case 0:
            number = 1;
            break;
            
        case 1:
            number = 1;
            break;
            
        case 2:
            
            if (self.editingContentType == kEditingContentTypeRoutine) {
                
                if (self.propModelList.count == 1 && !self.propModelList[0].isWithProp && !self.propModelList[0].isWithDetail && !self.propModelList[0].isWithQuantity) {
                    number = 1;
                } else {
                    number = self.propModelList.count + 1;
                }
                
            } else {
                // 如果只有一个模型,而且模型中没有内容,则不显示该行cell,只显示添加模型的cell
                if (self.prepModelList.count == 1 && !self.prepModelList[0].isWithPrep && !self.prepModelList[0].isWithImage && !self.prepModelList[0].isWithVideo) {
                    number = 1;
                } else {
                    number = self.prepModelList.count + 1;
                }
                
            }
            
            break;
            
        case 3:
            if (self.prepModelList.count == 1 && !self.prepModelList[0].isWithPrep && !self.prepModelList[0].isWithImage && !self.prepModelList[0].isWithVideo) {
                number = 1;
            } else {
                number = self.prepModelList.count + 1;
            }
            break;
            
        case 4:
            if (self.performModelList.count == 1 && !self.performModelList[0].isWithPerform && !self.performModelList[0].isWithImage && !self.performModelList[0].isWithVideo) {
                number = 1;
            } else {
                number = self.performModelList.count + 1;
            }
            
            break;
            
        case 5:
            if (self.notesModelList.count == 1 && !self.notesModelList[0].isWithNotes) {
                number = 1;
            } else {
                number = self.notesModelList.count + 1;
            }
            break;
            
        default:
            break;
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"ID";
    
    switch (indexPath.section) {
        case 0:
        {
            {
                CLTextInputCell *cell = [tableView dequeueReusableCellWithIdentifier:KTextInputCellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (indexPath.row == 0) {
                    
                    [cell setEditingContentType:self.editingContentType];
                    cell.inputTextField.font = kFontSys16;
                    cell.inputTextField.placeholder = self.entryTitle;
                    cell.inputTextField.text = self.infoModel.name;
                    cell.inputTextField.tag = 1;
                    self.titleTF = cell.inputTextField;
                    cell.inputTextField.delegate = self;
                }
                return cell;
            }
        case 1:
            {
                if (self.effectModel.isWithImage || self.effectModel.isWithVideo) {
                    CLNewEntryImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryImageCellID];
                    if (self.effectModel.isWithImage) {
                        [cell.iconView setImage:[self.effectModel.image getNamedImageThumbnail]];
                    } else if (self.effectModel.isWithVideo) {
                        [cell.iconView setImage:[self.effectModel.video getNamedVideoThumbnail]];

                    }
                    
                    cell.contentLabel.font = kFontSys16;
                    cell.contentLabel.text = self.effectModel.effect;
                    return cell;
                    
                } else {
                    
                    if (self.effectModel.isWithEffect) {
                        
                        CLNewEntryTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryTextCellID];
                        
                        cell.contentLabel.font = kFontSys16;
                        cell.contentLabel.text = self.effectModel.effect;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        
                        return cell;
                        
                    } else {
                        
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if (cell == nil) {
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                        }
                        
                        cell.textLabel.font = kBoldFontSys16;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                        NSString *effectTitle;
                        
                        if (self.editingContentType == kEditingContentTypeIdea) {
                            effectTitle = NSLocalizedString(@"灵感描述", nil);
                        } else if (self.editingContentType == kEditingContentTypeRoutine) {
                            effectTitle = NSLocalizedString(@"效果描述", nil);
                        } else if (self.editingContentType == kEditingContentTypeSleight) {
                            effectTitle = NSLocalizedString(@"技巧描述", nil);
                        } else if (self.editingContentType == kEditingContentTypeProp) {
                            effectTitle = NSLocalizedString(@"道具描述", nil);
                        } else if (self.editingContentType == kEditingContentTypeLines) {
                            effectTitle = NSLocalizedString(@"台词内容", nil);
                        }
                        cell.textLabel.text = effectTitle;
                        return cell;
                    }
                }
            }
        case 2:
            {
                if (self.editingContentType == kEditingContentTypeRoutine) {
                    
                    if (indexPath.row == 0) {
                        
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if (cell == nil) {
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                        }
                        
                        cell.textLabel.text = NSLocalizedString(@"添加道具", nil);
                        cell.textLabel.font = kBoldFontSys16;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        return cell;
                        
                    } else {
                        
                        CLPropModel *model = self.propModelList[indexPath.row - 1];
                        
                        CLNewEntryTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryTextCellID];
                        
                        cell.contentLabel.text = model.prop;
                        
                        return cell;
                        
                    }
                } else {
                    
                    if (indexPath.row == 0) {
                        
                        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                        if (cell == nil) {
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                        }
                        
                        cell.textLabel.text = NSLocalizedString(@"添加细节", nil);
                        cell.textLabel.font = kBoldFontSys16;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        return cell;
                        
                    } else {
                        
                        CLPrepModel *model = self.prepModelList[indexPath.row - 1];
                        
                        if (model.isWithImage || model.isWithVideo) {
                            
                            CLNewEntryImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryImageCellID];
        
                            if (model.isWithImage) {
                                [cell.iconView setImage:[model.image getNamedImageThumbnail]];
                            } else if (model.isWithVideo) {
                                [cell.iconView setImage:[model.video getNamedVideoThumbnail]];
                                
                            }
                            
                            cell.contentLabel.text = model.prep;
                            
                            return cell;
                        } else {
                            CLNewEntryTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryTextCellID];
                            
                            cell.contentLabel.text = model.prep;
                            NSLog(@"%@", model.prep);
                            return cell;
                        }
                        
                        
                    }
                    
                }
                
            }
        case 3:
            {
                if (indexPath.row == 0) {
                    
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                    }
                    
                    cell.textLabel.text = NSLocalizedString(@"添加准备", nil);
                    cell.textLabel.font = kBoldFontSys16;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                    
                } else {
                    
                    CLPrepModel *model = self.prepModelList[indexPath.row - 1];
                    
                    if (model.isWithImage || model.isWithVideo) {
                        
                        CLNewEntryImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryImageCellID];
                        
                        if (model.isWithImage) {
                            [cell.iconView setImage:[model.image getNamedImageThumbnail]];
                        } else if (model.isWithVideo) {
                            [cell.iconView setImage:[model.video getNamedVideoThumbnail]];
                            
                        }
                        cell.contentLabel.text = model.prep;
                        
                        return cell;
                    } else {
                        CLNewEntryTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryTextCellID];
                        
                        cell.contentLabel.text = model.prep;
                        
                        return cell;
                    }
                    
                    
                }
                
            }
        case 4:
            {
                if (indexPath.row == 0) {
                    
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                    }
                    
                    cell.textLabel.text = NSLocalizedString(@"添加表演", nil);
                    cell.textLabel.font = kBoldFontSys16;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                    
                } else {
                    
                    CLPerformModel *model = self.performModelList[indexPath.row - 1];
                    
                    if (model.isWithImage || model.isWithVideo) {
                        
                        CLNewEntryImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryImageCellID];
                        
                        if (model.isWithImage) {
                            [cell.iconView setImage:[model.image getNamedImageThumbnail]];
                        } else if (model.isWithVideo) {
                            [cell.iconView setImage:[model.video getNamedVideoThumbnail]];
                            
                        }
                        
                        cell.contentLabel.text = model.perform;
                        
                        return cell;
                    } else {
                        
                        CLNewEntryTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryTextCellID];
                        
                        cell.contentLabel.text = model.perform;
                        
                        return cell;
                    }
                    
                    
                }
            }
        case 5:
            {
                if (indexPath.row == 0) {
                    
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
                    }
                    
                    cell.textLabel.text = NSLocalizedString(@"添加注意", nil);
                    cell.textLabel.font = kBoldFontSys16;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                    
                } else {
                    
                    CLNotesModel *model = self.notesModelList[indexPath.row - 1];
                    
                    
                    CLNewEntryTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewEntryTextCellID];
                    
                    cell.contentLabel.text = model.notes;
                    
                    return cell;
                }
                
            }
            
        default:
            break;
        }
            
            
            return nil;
            
    }
    return nil;
}

#pragma mark - tableView 编辑方法
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if (self.effectModel.isWithEffect || self.effectModel.isWithImage || self.effectModel.isWithVideo) {
            return YES;
        }
    }

    if (indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5) {

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
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self addContentInSection:indexPath.section];
        
    } else if (editingStyle == UITableViewCellEditingStyleDelete) {

        if (indexPath.section == 1) {
            [self.effectModel deleteMedia];
            self.effectModel.effect = nil;
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } else {
            
            switch (indexPath.section) {
                case 2:
                    if (self.editingContentType == kEditingContentTypeRoutine) {
                        
                        [self.propModelList removeObjectAtIndex:indexPath.row-1];
                        
                    } else {
                        [self.prepModelList removeObjectAtIndex:indexPath.row-1];
                        
                    }
                    break;
                    
                case 3:
                    [self.prepModelList[indexPath.row-1] deleteMedia];
                    [self.prepModelList removeObjectAtIndex:indexPath.row-1];
                    break;
                    
                case 4:
                    [self.performModelList removeObjectAtIndex:indexPath.row-1];
                    [self.performModelList[indexPath.row-1] deleteMedia];
                    break;
                    
                case 5:
                    [self.notesModelList removeObjectAtIndex:indexPath.row-1];
                    break;
                    
                default:
                    break;
            }
            
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
    
    // 因为所有section的第一栏都是添加cell的操作栏,所以所有的ModelList中都要在fromIndexPath.row和toIndexPath.row的基础上减1
    switch (fromIndexPath.section) {
        case 2:
        {
            CLPropModel *model = self.propModelList[fromIndexPath.row-1];
            [self.propModelList removeObjectAtIndex:fromIndexPath.row-1];
            [self.propModelList insertObject:model atIndex:toIndexPath.row-1];
            break;
        }
        case 3:
        {
            CLPrepModel *model = self.prepModelList[fromIndexPath.row-1];
            [self.prepModelList removeObjectAtIndex:fromIndexPath.row-1];
            [self.prepModelList insertObject:model atIndex:toIndexPath.row-1];
            break;
        }
            
        case 4:
        {
            CLPerformModel *model = self.performModelList[fromIndexPath.row-1];
            [self.performModelList removeObjectAtIndex:fromIndexPath.row-1];
            [self.performModelList insertObject:model atIndex:toIndexPath.row-1];
            break;
        }
            
        case 5:
        {
            CLNotesModel *model = self.notesModelList[fromIndexPath.row-1];
            [self.notesModelList removeObjectAtIndex:fromIndexPath.row-1];
            [self.notesModelList insertObject:model atIndex:toIndexPath.row-1];
            break;
        }
            
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) return NO;
    
    // 有2行(即添加操作cell和第一个cell)时,不可以交换顺序.
    if ([self.tableView numberOfRowsInSection:indexPath.section] < 3) return NO;
    
    return YES;
}

- (void)addContentInSection:(NSInteger)section {
    
    switch (self.editingContentType) {
        case kEditingContentTypeRoutine:
            switch (section) {
                case 2:
                    [self addProp];
                    break;
                case 3:
                    [self addPrep];
                    break;
                case 4:
                    [self addPerform];
                    break;
                case 5:
                    [self addNotes];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case kEditingContentTypeIdea:
            switch (section) {
                case 2:
                    [self addPrep];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case kEditingContentTypeSleight:
            switch (section) {
                case 2:
                    [self addPrep];
                    break;
                    
                default:
                    break;
            }            break;
            
        case kEditingContentTypeProp:
            switch (section) {
                case 2:
                    [self addPrep];
                    break;
                    
                default:
                    break;
            }            break;
            
        case kEditingContentTypeLines:
            return;
    }
}


#pragma mark 添加数据 方法

- (void)addProp {
    // 添加模型
    CLPropModel *model = [CLPropModel propModel];
    [self.propModelList addObject:model];
    
    // 插入表格
    NSInteger rowNumber = self.propModelList.count;
    NSIndexPath *path = [NSIndexPath indexPathForRow:rowNumber inSection:2];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    
    
    // 编辑内容
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    [self performSegueWithIdentifier:kEditingSegue sender:path];
}

- (void)addPrep {
    // 添加模型
    CLPrepModel *model = [CLPrepModel prepModel];
    [self.prepModelList addObject:model];
    
    // 插入表格
    NSInteger rowNumber = self.prepModelList.count;
    NSIndexPath *path = [NSIndexPath indexPathForRow:rowNumber inSection:self.prepSection];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    
    // 编辑内容
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    [self performSegueWithIdentifier:kEditingSegue sender:path];
}

- (void)addPerform {
    // 添加模型
    CLPerformModel *model = [CLPerformModel performModel];
    [self.performModelList addObject:model];
    
    // 插入表格
    NSInteger rowNumber = self.performModelList.count;
    NSIndexPath *path = [NSIndexPath indexPathForRow:rowNumber inSection:4];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    
    // 编辑内容
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    [self performSegueWithIdentifier:kEditingSegue sender:path];
}

- (void)addNotes {
    // 添加模型
    CLNotesModel *model = [CLNotesModel notesModel];
    [self.notesModelList addObject:model];
    
    // 插入表格
    NSInteger rowNumber = self.notesModelList.count;
    NSIndexPath *path = [NSIndexPath indexPathForRow:rowNumber inSection:5];
    [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    
    // 编辑内容
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    [self performSegueWithIdentifier:kEditingSegue sender:path];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) return;
    
    if (indexPath.section == 1) [self performSegueWithIdentifier:kEditingSegue sender:indexPath];
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) { // 当选中第一行时
            if (self.editingContentType == kEditingContentTypeRoutine) {
                if (self.propModelList.count == 1 && !self.propModelList[0].isWithProp && !self.propModelList[0].isWithDetail && !self.propModelList[0].isWithQuantity) {
                    [self performSegueWithIdentifier:kEditingSegue sender:indexPath];
                } else {
                    [self addProp];
                }
                
            } else {
                if (self.prepModelList.count == 1 && !self.prepModelList[0].isWithPrep && !self.prepModelList[0].isWithImage && !self.prepModelList[0].isWithVideo) {
                    [self performSegueWithIdentifier:kEditingSegue sender:indexPath];
                } else {
                    [self addPrep];
                }
                
            }
        } else { // 当选中其他行时
            [self performSegueWithIdentifier:kEditingSegue sender:indexPath];

        }
    }
    
    if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            if (self.prepModelList.count == 1) {
                CLPrepModel *model = self.prepModelList[0];
                if (!model.isWithPrep && !model.isWithImage && !model.isWithVideo) {
                    [self performSegueWithIdentifier:kEditingSegue sender:indexPath];
                }
            } else {
                [self addPrep];
            }
        } else {
            [self performSegueWithIdentifier:kEditingSegue sender:indexPath];
        }
        
        
    }
    
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            if (self.performModelList.count == 1 && !self.performModelList[0].isWithPerform && !self.performModelList[0].isWithImage && !self.performModelList[0].isWithVideo) {
                [self performSegueWithIdentifier:kEditingSegue sender:indexPath];
            } else {
                [self addPerform];
            }
        } else {
            [self performSegueWithIdentifier:kEditingSegue sender:indexPath];
        }
    }
    
    if (indexPath.section == 5) {
        if (indexPath.row == 0) {
            if (self.notesModelList.count == 1 && !self.notesModelList[0].isWithNotes) {
                [self performSegueWithIdentifier:kEditingSegue sender:indexPath];
            } else {
                [self addNotes];
            }
        } else {
            [self performSegueWithIdentifier:kEditingSegue sender:indexPath];

        }
        
    }
    
}


#pragma mark - segue 方法

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id destVC = [segue destinationViewController];
    
    if ([destVC isKindOfClass:[CLEdtingManageVC class]]) {
        
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            CLEdtingManageVC *vc = (CLEdtingManageVC *)destVC;
            
            NSIndexPath *path = (NSIndexPath *)sender;
            NSUInteger selectedVCIndex = 0;
            
            for (int i=1; i<=path.section; i++) {
                
                if (i != path.section) {
                    
                    if (i == 1) { // effectSection
                        selectedVCIndex += 1;
                        
                    } else if (i == 2) { // propSection
                        
                        if (self.editingContentType == kEditingContentTypeRoutine) {
                            selectedVCIndex += self.propModelList.count;
                        } else {
                            selectedVCIndex += self.prepModelList.count;
                        }
                        
                    } else if (i == 3) { // prepSection
                        selectedVCIndex += self.prepModelList.count;

                    } else if (i == 4) { // performSection
                        selectedVCIndex += self.performModelList.count;

                    } else if (i == 5) { // notesSection
                        selectedVCIndex += self.notesModelList.count;

                    }
                    
                } else if (i == path.section) {
                    if (i == 1) { // effectSection
                        selectedVCIndex = 0;
                    } else { // effectSection下面的内容
                        if (path.row == 0) { // 如果是第一行, 则表明是当模型数组只有一个且模型中无内容时跳转,所以直接用上面的selectedVCIndex
                            selectedVCIndex += 0;
                            
                        } else { // 如果不是第一行,说明该section没有隐藏cell, 可以直接用row来进行计算
                            
                            selectedVCIndex += (path.row-1);
                        }
                    }
                    
                }
                
            }
            switch (self.editingContentType) {
                case kEditingContentTypeRoutine:
                    vc.routineModel = self.routineModel;
                    break;
                case kEditingContentTypeIdea:
                    vc.ideaObjModel = self.ideaObjModel;
                    break;
                case kEditingContentTypeSleight:
                    vc.sleightObjModel = self.sleightObjModel;
                    break;
                case kEditingContentTypeProp:
                    vc.propObjModel = self.propObjModel;
                    break;
                case kEditingContentTypeLines:
                    vc.linesObjModel = self.linesObjModel;
                    break;
                default:
                    break;
            }
            
            vc.editingContentType = self.editingContentType;
            vc.selectedVCIndex = selectedVCIndex;
        }
        
        
    } else if ([destVC isKindOfClass:[CLTagChooseNavVC class]]) {
        CLTagChooseNavVC *vc = (CLTagChooseNavVC *)destVC;
        vc.navDelegate = self;
        vc.editingContentType = self.editingContentType;
    }
}


#pragma mark - 保存数据
- (IBAction)saveButtonClicked:(UIBarButtonItem *)sender {
    
    if ([self.navigationController isKindOfClass:[CLNewEntryNavVC class]]) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kDismissNewEntryNavVCNotification object:nil]];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
//    
//    if (self.isCreatingNewEntry) {
//        
//        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"saveNewCreation" object:nil]];
//        
//    } else {
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    }
}

#pragma mark - textField 代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.textAlignment = NSTextAlignmentLeft;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.textAlignment = NSTextAlignmentRight;
    
    self.infoModel.name = textField.text;
}

#pragma mark - tagField 代理方法
- (void)tagField:(SMTagField *)tagField tagAdded:(NSString *)tag {
    
    if ([self.tags containsObject:tag] == NO) {
        [
         self.tags addObject: tag];
    }
    
    if ([self.allTags containsObject:tag] == NO) {
        [self.allTags insertObject:tag atIndex:0];

    }
    
    NSString *type;
    switch (self.editingContentType) {
        case kEditingContentTypeRoutine:
            type = kTypeRoutine;
            if ([self.allTagsRoutine containsObject:tag] == NO) {
                [self.allTagsRoutine insertObject:tag atIndex:0];
            }
            
            break;
        case kEditingContentTypeIdea:
            type = kTypeIdea;
            if ([self.allTagsIdea containsObject:tag] == NO) {
                [self.allTagsIdea insertObject:tag atIndex:0];
            }
            break;
        case kEditingContentTypeSleight:
            type = kTypeSleight;
            if ([self.allTagsSleight containsObject:tag] == NO) {
                [self.allTagsSleight insertObject:tag atIndex:0];
            }
            break;
            
        case kEditingContentTypeProp:
            type = kTypeProp;
            if ([self.allTagsProp containsObject:tag] == NO) {
                [self.allTagsProp insertObject:tag atIndex:0];
            }
            break;
            
        case kEditingContentTypeLines:
            type = kTypeLines;
            if ([self.allTagsLines containsObject:tag] == NO) {
                [self.allTagsLines insertObject:tag atIndex:0];
            }
            break;
            
        default:
            break;
    }

    [CLDataSaveTool addTag:tag type:type];
}

- (void)tagField:(SMTagField *)tagField tagRemoved:(NSString *)tag {
    if ([self.tags containsObject:tag]) {
        [self.tags removeObject: tag];
    }
    
}

- (void)tagField:(SMTagField *)tagField tagsChanged:(NSArray *)tags {
    
}

- (void)tagFieldAddButtonClicked:(SMTagField *)tagField {
    
    [self performSegueWithIdentifier:kNewEntryChooseTagSegue sender:nil];
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
