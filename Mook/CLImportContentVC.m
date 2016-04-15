//
//  CLImportContentVC.m
//  Mook
//
//  Created by 陈林 on 16/4/11.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLImportContentVC.h"
#import "CLMookTabBarController.h"
#import "CLDataImportTool.h"
#import "NSObject+MJKeyValue.h"

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
#import "CLNotesModel.h"

#import "CLOneLabelDisplayCell.h"
#import "CLOneLabelImageDisplayCell.h"
#import "CLImportPasswordInputView.h"

#import "MWPhotoBrowser.h"
@interface CLImportContentVC ()<CLImportPasswordInputViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, assign) ContentType contentType;

@property (nonatomic, strong) CLIdeaObjModel *ideaObjModel;
@property (nonatomic, strong) CLRoutineModel *routineModel;
@property (nonatomic, strong) CLSleightObjModel *sleightObjModel;
@property (nonatomic, strong) CLPropObjModel *propObjModel;
@property (nonatomic, strong) CLLinesObjModel *linesObjModel;

@property (nonatomic, copy) NSString *importPassword;

// section属性(需要根据model内容进行设置)
@property (nonatomic, assign) NSInteger infoSection;
@property (nonatomic, assign) NSInteger effectSection;
@property (nonatomic, assign) NSInteger propSection;
@property (nonatomic, assign) NSInteger prepSection;
@property (nonatomic, assign) NSInteger performSection;
@property (nonatomic, assign) NSInteger notesSection;

// 便于显示内容的模型单元
@property (nonatomic, strong) CLInfoModel *infoModel;
@property (nonatomic, strong) CLEffectModel *effectModel;
@property (nonatomic, strong) NSMutableArray *propModelList;
@property (nonatomic, strong) NSMutableArray *prepModelList;
@property (nonatomic, strong) NSMutableArray *performModelList;
@property (nonatomic, strong) NSMutableArray *notesModelList;

@property (nonatomic, copy) NSAttributedString *titleString;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableArray *tags;

@property (nonatomic, assign) BOOL unlocked; // 输入密码后解锁
@property (nonatomic, strong) CLImportPasswordInputView *importPasswordInputView;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, copy) NSString *passwordString;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end

@implementation CLImportContentVC

- (void)setImportDict:(NSDictionary *)importDict {
    
    _importDict = importDict;
    
    // 从字典中取出模型
    NSString *modelType = [importDict objectForKey:@"type"];
    NSDictionary *modelDict = [importDict objectForKey:@"model"];
    self.importPassword = [importDict objectForKey:@"passWord"];
    
    if (modelDict == nil) { // 如果模型字典为空,则说明导入文件有问题,无法导入.
        
        [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"预览失败", nil) hideAfterDelay:2.0];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissImportContentVC" object:nil];
        
    } else { // 如果模型字典不为空, 则执行数据读取
        
        if ([modelType isEqualToString:kTypeRoutine]) {
            
            CLRoutineModel *model = [CLRoutineModel objectWithKeyValues:modelDict];
            
            if (model != nil) { // 如果模型不为空, 则执行数据读取
                self.contentType = kContentTypeRoutine;
                self.routineModel = model;
                [CLDataImportTool prepareDataWithRoutine:model];
                
            } else { // 如果模型为空, 则退出预览
                
                [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"预览失败", nil) hideAfterDelay:2.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissImportContentVC" object:nil];

            }
            
            
        } else if ([modelType isEqualToString:kTypeIdea]) {
            
            CLIdeaObjModel *model = [CLIdeaObjModel objectWithKeyValues:modelDict];
            
            if (model != nil) {
                
                self.contentType = kContentTypeIdea;
                self.ideaObjModel = model;
                [CLDataImportTool prepareDataWithIdea:model];
                
            } else { // 如果模型为空, 则退出预览
                [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"预览失败", nil) hideAfterDelay:2.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissImportContentVC" object:nil];
                
            }
        } else if ([modelType isEqualToString:kTypeSleight]) {
            
            CLSleightObjModel *model = [CLSleightObjModel objectWithKeyValues:modelDict];
            
            if (model != nil) {
                
                self.contentType = kContentTypeSleight;
                self.sleightObjModel = model;
                [CLDataImportTool prepareDataWithSleight:model];
                
            } else { // 如果模型为空, 则退出预览
                [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"预览失败", nil) hideAfterDelay:2.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissImportContentVC" object:nil];
                
            }
        } else if ([modelType isEqualToString:kTypeProp]) {
            
            CLPropObjModel *model = [CLPropObjModel objectWithKeyValues:modelDict];
            
            if (model != nil) {
                
                self.contentType = kContentTypeProp;
                self.propObjModel = model;
                [CLDataImportTool prepareDataWithProp:model];
                
            } else { // 如果模型为空, 则退出预览
                [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"预览失败", nil) hideAfterDelay:2.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissImportContentVC" object:nil];
                
            }
        } else if ([modelType isEqualToString:kTypeLines]) {
            
            CLLinesObjModel *model = [CLLinesObjModel objectWithKeyValues:modelDict];
            
            if (model != nil) {
                
                self.contentType = kContentTypeLines;
                self.linesObjModel = model;
                [CLDataImportTool prepareDataWithLines:model];
                
            } else { // 如果模型为空, 则退出预览
                [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"预览失败", nil) hideAfterDelay:2.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissImportContentVC" object:nil];
                
            }
        }

    }
}

- (CLImportPasswordInputView *)importPasswordInputView {
    if (!_importPasswordInputView) {
        _importPasswordInputView = [CLImportPasswordInputView importPasswordInputView];
        _importPasswordInputView.delegate = self;
        self.passwordTF = _importPasswordInputView.passwordTF;
        self.passwordTF.placeholder = NSLocalizedString(@"请输入解锁密码", nil);
        self.passwordTF.delegate = self;
    }
    return _importPasswordInputView;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [self loadPhotos];
    }
    return _photos;
}

- (NSMutableArray *)thumbs {
    if (!_thumbs) {
        _thumbs = [self loadThumbs];
    }
    return _thumbs;
}

#pragma mark - 便于显示内容的模型单元
- (CLInfoModel *)infoModel {
    if (!_infoModel) {
        if (self.contentType == kContentTypeIdea) {
            _infoModel = self.ideaObjModel.infoModel;
            
        } else if (self.contentType == kContentTypeRoutine) {
            _infoModel = self.routineModel.infoModel;
            
        } else if (self.contentType == kContentTypeSleight) {
            _infoModel = self.sleightObjModel.infoModel;
            
        } else if (self.contentType == kContentTypeProp) {
            _infoModel = self.propObjModel.infoModel;
            
        } else if (self.contentType == kContentTypeLines) {
            _infoModel = self.linesObjModel.infoModel;
        }
    }
    
    return _infoModel;
}

- (CLEffectModel *)effectModel {
    if (!_effectModel) {
        if (self.contentType == kContentTypeIdea) {
            _effectModel = self.ideaObjModel.effectModel;
            
        } else if (self.contentType == kContentTypeRoutine) {
            _effectModel = self.routineModel.effectModel;
            
        } else if (self.contentType == kContentTypeSleight) {
            _effectModel = self.sleightObjModel.effectModel;
            
        } else if (self.contentType == kContentTypeProp) {
            _effectModel = self.propObjModel.effectModel;
            
        } else if (self.contentType == kContentTypeLines) {
            _effectModel = self.linesObjModel.effectModel;
        }
    }
    
    return _effectModel;
}

- (NSMutableArray *)propModelList {
    if (!_propModelList) _propModelList = self.routineModel.propModelList;
    return _propModelList;
}

- (NSMutableArray *)prepModelList {
    if (!_prepModelList) {
        if (self.contentType == kContentTypeIdea) {
            _prepModelList = self.ideaObjModel.prepModelList;
            
        } else if (self.contentType == kContentTypeRoutine) {
            _prepModelList = self.routineModel.prepModelList;
            
        } else if (self.contentType == kContentTypeSleight) {
            _prepModelList = self.sleightObjModel.prepModelList;
            
        } else if (self.contentType == kContentTypeProp) {
            _prepModelList = self.propObjModel.prepModelList;
            
        }
    }
    
    return _prepModelList;
}

- (NSMutableArray *)performModelList {
    if (!_performModelList) _performModelList = self.routineModel.performModelList;
    return _performModelList;
}

- (NSMutableArray *)notesModelList {
    if (!_notesModelList) _notesModelList = self.routineModel.notesModelLsit;
    return _notesModelList;
}

- (NSMutableArray *)tags {
    if (!_tags) {
        if (self.contentType == kContentTypeIdea) {
            _tags = self.ideaObjModel.tags;
            
        } else if (self.contentType == kContentTypeRoutine) {
            _tags = self.routineModel.tags;
            
        } else if (self.contentType == kContentTypeSleight) {
            _tags = self.sleightObjModel.tags;
            
        } else if (self.contentType == kContentTypeProp) {
            _tags = self.propObjModel.tags;
            
        } else if (self.contentType == kContentTypeLines) {
            _tags = self.linesObjModel.tags;
        }
    }
    return _tags;
}

- (NSDate *)date {
    if (!_date) {
        if (self.contentType == kContentTypeIdea) {
            _date = self.ideaObjModel.date;
            
        } else if (self.contentType == kContentTypeRoutine) {
            _date = self.routineModel.date;
            
        } else if (self.contentType == kContentTypeSleight) {
            _date = self.sleightObjModel.date;
            
        } else if (self.contentType == kContentTypeProp) {
            _date = self.propObjModel.date;
            
        } else if (self.contentType == kContentTypeLines) {
            _date = self.linesObjModel.date;
        }
    }
    return _date;
}

- (NSAttributedString *)titleString {
    
    NSString *title;
    if (self.infoModel.isWithName) {
        title = self.infoModel.name;
    } else {
        title = NSLocalizedString(@"请编辑标题", nil);
    }
    
    return [NSString titleString:title withDate:self.date tags:self.tags];
}

#pragma mark - section计算方法
- (NSInteger)infoSection {
    // infoSection必须要有
    return 0;
}

- (NSInteger)effectSection {
    
    return self.infoSection + (self.effectModel.isWithEffect || self.effectModel.isWithImage || self.effectModel.isWithVideo);
}

- (NSInteger)propSection {
    
    NSInteger cnt = 0;
    
    if (self.contentType == kContentTypeRoutine) {
        for (CLPropModel *model in self.propModelList) {
            if (model.isWithProp) {
                cnt = 1;
                break;
            }
        }
        
    } else {
        for (CLPrepModel *model in self.prepModelList) {
            if (model.isWithPrep || model.isWithImage || model.isWithVideo) {
                cnt = 1;
                break;
            }
        }
    }
    
    return self.effectSection + cnt;
}

- (NSInteger)prepSection {
    
    NSInteger cnt = 0;
    if (self.contentType == kContentTypeRoutine) {
        for (CLPrepModel *model in self.prepModelList) {
            if (model.isWithPrep || model.isWithImage || model.isWithVideo) {
                cnt = 1;
                break;
            }
        }
    }
    
    return self.propSection + cnt;
}

- (NSInteger)performSection {
    
    NSInteger cnt = 0;
    if (self.contentType == kContentTypeRoutine) {
        for (CLPerformModel *model in self.performModelList) {
            if (model.isWithPerform || model.isWithImage || model.isWithVideo) {
                cnt = 1;
                break;
            }
        }
    }
    
    return self.prepSection + cnt;
}

- (NSInteger)notesSection {
    
    NSInteger cnt = 0;
    if (self.contentType == kContentTypeRoutine) {
        for (CLNotesModel *model in self.notesModelList) {
            if (model.isWithNotes) {
                cnt = 1;
                break;
            }
        }
    }
    
    return self.performSection + cnt;
}

#pragma mark - 控制器方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = self.importPasswordInputView;

    // 设置解锁状态
    if (self.importPassword == nil || self.importPassword.length == 0) {
        self.unlocked = YES;    // 如果没有密码, 则设定为已解锁
    } else {
        self.unlocked = NO;     // 如果有密码, 则设定为未解锁
    }

    // 根据解锁状态设置导航栏按钮状态
    self.navigationItem.rightBarButtonItem.enabled = self.unlocked;
    
    self.importPasswordInputView.hidden = self.unlocked;
    
    [self setContentTitle];
    self.tableView.backgroundColor = kCellBgColor;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.allowsSelection = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLOneLabelImageDisplayCell"
                                               bundle:nil]
         forCellReuseIdentifier:kOneLabelImageDisplayCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLOneLabelDisplayCell"
                                               bundle:nil]
         forCellReuseIdentifier:kOneLabelDisplayCell];
    
}

- (void)setContentTitle {
   
    self.navigationItem.title = NSLocalizedString(@"预览", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.unlocked == NO) {
        [self.passwordTF becomeFirstResponder];
    }
}


#pragma mark - 导入笔记


- (IBAction)importData:(id)sender {
    
    BOOL flag;
    NSString *title;
    
    switch (self.contentType) {
        case kContentTypeIdea:
            flag = [CLDataImportTool importIdea:self.ideaObjModel];
            if (flag) {
                [kDataListAll insertObject:self.ideaObjModel atIndex:0];
                [kDataListIdea insertObject:self.ideaObjModel atIndex:0];
                title = NSLocalizedString(@"导入成功", nil);
            } else {
                title = NSLocalizedString(@"导入失败", nil);
            }

            break;
            
        case kContentTypeRoutine:
            flag = [CLDataImportTool importRoutine:self.routineModel];

            if (flag) {
                [kDataListAll insertObject:self.routineModel atIndex:0];
                [kDataListRoutine insertObject:self.routineModel atIndex:0];
                title = NSLocalizedString(@"导入成功", nil);
            } else {
                title = NSLocalizedString(@"导入失败", nil);
            }
            
            break;
            
        case kContentTypeSleight:
            flag = [CLDataImportTool importSleight:self.sleightObjModel];
            
            if (flag) {
                [kDataListAll insertObject:self.sleightObjModel atIndex:0];
                [kDataListSleight insertObject:self.sleightObjModel atIndex:0];
                title = NSLocalizedString(@"导入成功", nil);
            } else {
                title = NSLocalizedString(@"导入失败", nil);
            }

            break;
            
        case kContentTypeProp:
            flag = [CLDataImportTool importProp:self.propObjModel];
            
            if (flag) {
                [kDataListAll insertObject:self.propObjModel atIndex:0];
                [kDataListProp insertObject:self.propObjModel atIndex:0];
                title = NSLocalizedString(@"导入成功", nil);
            } else {
                title = NSLocalizedString(@"导入失败", nil);
            }

            break;
            
        case kContentTypeLines:
            flag = [CLDataImportTool importLines:self.linesObjModel];
            
            if (flag) {
                [kDataListAll insertObject:self.linesObjModel atIndex:0];
                [kDataListLines insertObject:self.linesObjModel atIndex:0];
                title = NSLocalizedString(@"导入成功", nil);
            } else {
                title = NSLocalizedString(@"导入失败", nil);
            }

            break;
            
        default:
            break;
    }
    
    [MBProgressHUD showGlobalProgressHUDWithTitle:title hideAfterDelay:2.0];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissImportContentVC" object:nil];
}

- (IBAction)cancelImport:(id)sender {
    
    switch (self.contentType) {
        case kContentTypeIdea:
            [CLDataImportTool cancelImportIdea:self.ideaObjModel];
            break;
            
        case kContentTypeRoutine:
            [CLDataImportTool cancelImportRoutine:self.routineModel];
            
            break;
            
        case kContentTypeSleight:
            [CLDataImportTool cancelImportSleight:self.sleightObjModel];
            break;
            
        case kContentTypeProp:
            [CLDataImportTool cancelImportProp:self.propObjModel];
            break;
            
        case kContentTypeLines:
            [CLDataImportTool cancelImportLines:self.linesObjModel];
            
            break;
            
        default:
            break;
    }
    
    [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"导入取消", nil) hideAfterDelay:2.0];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissImportContentVC" object:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.unlocked == NO) {
        self.importPasswordInputView.hidden = NO;
        
        return 0;
        
    } else {
        
        self.importPasswordInputView.hidden = YES;

        self.navigationItem.rightBarButtonItem.enabled = self.unlocked;
    }
    
    if (self.contentType == kContentTypeRoutine) {
        return  self.notesSection + 1;
        
    } else if (self.contentType == kContentTypeLines) {
        
        return self.effectSection + 1;
    }
    
    return self.propSection + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == self.infoSection) {
        return 1;
    } else if (section == self.effectSection && self.effectSection != self.infoSection) {
        return 1;
    } else if (section == self.propSection && self.propSection != self.effectSection) {
        if (self.contentType == kContentTypeRoutine) {
            return self.propModelList.count;
        } else {
            return self.prepModelList.count;
        }
    } else if (section == self.prepSection && self.prepSection != self.propSection) {
        if (self.contentType == kContentTypeRoutine) {
            return self.prepModelList.count;
        }
    } else if (section == self.performSection && self.performSection != self.prepSection) {
        return self.routineModel.performModelList.count;
    } else if (section == self.notesSection && self.notesSection != self.performSection) {
        return self.routineModel.notesModelLsit.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 标题buff
    if (indexPath.section == self.infoSection) {
        
        CLOneLabelDisplayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelDisplayCell forIndexPath:indexPath];
        
        cell.contentLabel.attributedText = self.titleString;
        cell.contentLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
        
        // 效果部分
    } else if (indexPath.section == self.effectSection && self.effectSection != self.infoSection) {
        
        if (self.effectModel.isWithVideo) {
            
            CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
            
            cell.contentLabel.attributedText = [self.effectModel.effect styledString];
            [cell.imageButton addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
            cell.imageButton.tag = 0; // effectModel肯定是第一张图片或视频,所以作为图片数组中的Index,tag = 0;
            [cell setImageWithVideoName:self.effectModel.video];
            
            return cell;
        } else if (self.effectModel.isWithImage) {
            
            CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
            
            cell.contentLabel.attributedText = [self.effectModel.effect styledString];
            [cell.imageButton addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
            cell.imageButton.tag = 0;
            [cell setImageWithName:self.effectModel.image];
            
            return cell;
            
        } else {
            CLOneLabelDisplayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelDisplayCell forIndexPath:indexPath];
            
            cell.contentLabel.attributedText = [self.effectModel.effect styledString];
            
            return cell;
        }
        
        // 道具部分
    } else if (indexPath.section == self.propSection && self.propSection != self.effectSection) {
        if (self.contentType == kContentTypeRoutine) {
            CLOneLabelDisplayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelDisplayCell forIndexPath:indexPath];
            
            CLPropModel *model = self.propModelList[indexPath.row];
            NSString *prop;
            
            if (model.isWithProp) {
                prop = model.prop;
            } else {
                
                prop = NSLocalizedString(@"新建道具", nil);
            }
            
            if (model.isWithQuantity) {
                prop = [prop stringByAppendingString:[NSString stringWithFormat:@" ( x %@ )", model.quantity]];
            }
            
            if (model.isWithDetail) {
                NSString *detail = [NSString stringWithFormat:@"  ( %@ )", model.propDetail];
                cell.contentLabel.attributedText = [[NSString attributedStringWithFirstPart:prop secondPart:detail firstPartFont:kFontSys17 firstPartColor:[UIColor blackColor] secondPardFont:kFontSys17 secondPartColor:[UIColor darkGrayColor]] styledString];
            } else {
                cell.contentLabel.text = prop;
            }
            
            return cell;
        } else {
            CLPrepModel *model = self.prepModelList[indexPath.row];
            
            if (model.isWithVideo) {
                
                CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
                
                cell.contentLabel.attributedText = [model.prep styledString];
                [cell.imageButton addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
                cell.imageButton.tag = [self getButtonTagWithPrepModel:model];
                [cell setImageWithVideoName:model.video];
                
                return cell;
                
            } else if (model.isWithImage) {
                CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
                
                cell.contentLabel.attributedText = [model.prep styledString];
                [cell.imageButton addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
                cell.imageButton.tag = [self getButtonTagWithPrepModel:model];
                [cell setImageWithName:model.image];
                
                return cell;
                
            } else {
                CLOneLabelDisplayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelDisplayCell forIndexPath:indexPath];
                
                cell.contentLabel.attributedText = [model.prep styledString];
                
                return cell;
            }
            
        }
        
        // 准备部分
    } else if (indexPath.section == self.prepSection && self.prepSection != self.propSection) {
        
        if (self.contentType == kContentTypeRoutine) {
            CLPrepModel *model = self.prepModelList[indexPath.row];
            
            if (model.isWithVideo) {
                
                CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
                
                cell.contentLabel.attributedText = [model.prep styledString];
                [cell.imageButton addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
                cell.imageButton.tag = [self getButtonTagWithPrepModel:model];
                [cell setImageWithVideoName:model.video];
                
                return cell;
                
            } else if (model.isWithImage) {
                
                CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
                
                cell.contentLabel.attributedText = [model.prep styledString];
                [cell.imageButton addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
                cell.imageButton.tag = [self getButtonTagWithPrepModel:model];
                [cell setImageWithName:model.image];
                
                return cell;
                
            } else {
                CLOneLabelDisplayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelDisplayCell forIndexPath:indexPath];
                
                cell.contentLabel.attributedText = [model.prep styledString];
                
                return cell;
            }
        }
        
        // 表演部分
    } else if (indexPath.section == self.performSection && self.performSection != self.prepSection) {
        
        CLPerformModel *model = self.performModelList[indexPath.row];
        NSString *perform = model.perform;
        
        if (model.isWithVideo) {
            
            CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
            
            cell.contentLabel.attributedText = [perform styledString];
            [cell.imageButton addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
            cell.imageButton.tag = [self getButtonTagWithPerformModel:model];
            [cell setImageWithVideoName:model.video];
            
            return cell;
            
        } if (model.isWithImage) {
            CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
            
            cell.contentLabel.attributedText = [perform styledString];
            [cell.imageButton addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
            cell.imageButton.tag = [self getButtonTagWithPerformModel:model];
            [cell setImageWithName:model.image];
            
            return cell;
            
        } else {
            CLOneLabelDisplayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelDisplayCell forIndexPath:indexPath];
            
            cell.contentLabel.attributedText = [perform styledString];
            
            return cell;
        }
        
        // 注意部分
    } else if (indexPath.section == self.notesSection && self.notesSection != self.performSection) {
        
        CLNotesModel *model = self.notesModelList[indexPath.row];
        
        CLOneLabelDisplayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelDisplayCell forIndexPath:indexPath];
        
        cell.contentLabel.attributedText = [model.notes styledString];
        
        return cell;
        
    }
    
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    } else {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kLabelHeight)];
        view.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] init];
        [view addSubview:label];
        label.frame = CGRectMake(20.0, 0, kScreenW-40.0, kLabelHeight);
        label.textAlignment =NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.alpha = 0.99;
        label.font = kBoldFontSys17;
        
        NSString *sectionTitle;
        if (section == self.infoSection) {
            sectionTitle = nil;
        } else if (section == self.effectSection && self.effectSection != self.infoSection) {
            if (self.contentType == kContentTypeRoutine) {
                sectionTitle = NSLocalizedString(@"效果描述", nil);
            } else if (self.contentType == kContentTypeIdea) {
                sectionTitle = NSLocalizedString(@"灵感内容", nil);
                
            } else if (self.contentType == kContentTypeSleight) {
                sectionTitle = NSLocalizedString(@"技巧描述", nil);
                
            } else if (self.contentType == kContentTypeProp) {
                sectionTitle = NSLocalizedString(@"道具描述", nil);
                
            } else if (self.contentType == kContentTypeLines) {
                sectionTitle = NSLocalizedString(@"台词内容", nil);
                
            }
        } else if (section == self.propSection && self.propSection != self.effectSection) {
            if (self.contentType == kContentTypeRoutine) {
                sectionTitle = NSLocalizedString(@"道具清单", nil);
            } else {
                sectionTitle = NSLocalizedString(@"细节描述", nil);
            }
        } else if (section == self.prepSection && self.prepSection != self.propSection) {
            if (self.contentType == kContentTypeRoutine) {
                sectionTitle = NSLocalizedString(@"事前准备", nil);
            }
        } else if (section == self.performSection && self.performSection != self.prepSection) {
            sectionTitle = NSLocalizedString(@"表演细节", nil);
        } else if (section == self.notesSection && self.notesSection != self.performSection) {
            sectionTitle = NSLocalizedString(@"注意事项", nil);
        }
        
        label.text = sectionTitle;
        
        return view;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == self.infoSection) {
        return 15;
    }
    return kLabelHeight;
}

#pragma mark - textField 代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.passwordString = textField.text;
}

#pragma mark - CLImportPasswordInputViewDelegate 方法

- (void)importPasswordInputViewdidClickUnlockButton:(CLImportPasswordInputView *)view {
    
    [self.view endEditing:YES];

    if ([self.passwordString isEqualToString:self.importPassword]) {
        self.unlocked = YES;
        
        [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"解锁成功", nil) hideAfterDelay:2.0];

        [self.tableView reloadData];
    } else {
        [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"解锁失败", nil) hideAfterDelay:2.0];

    }
}


#pragma mark - PhotoBrowser方法
// 遍历模型,加载图片
- (NSMutableArray *)loadPhotos {
    
    NSMutableArray *photos = [NSMutableArray array];
    MWPhoto *photo;
    
    if (self.effectModel.isWithImage) {
        // Photos
        photo = [MWPhoto photoWithImage:[self.effectModel.image getNamedImage]];
        photo.caption = self.effectModel.effect;
        [photos addObject:photo];
        
    } else if (self.effectModel.isWithVideo) {
        
        // Photos
        NSString *path = [[NSString videoPath] stringByAppendingPathComponent:self.effectModel.video];
        photo = [MWPhoto photoWithImage:[self.effectModel.video getNamedVideoFrame]];
        photo.videoURL = [NSURL fileURLWithPath:path];
        photo.caption = self.effectModel.effect;
        
        [photos addObject:photo];
    }
    
    
    for (CLPrepModel *model in self.prepModelList) {
        if (model.isWithImage) {
            // Photos
            photo = [MWPhoto photoWithImage:[model.image getNamedImage]];
            photo.caption = model.prep;
            [photos addObject:photo];
            
        }
    }
    
    
    for (CLPrepModel *model in self.prepModelList) {
        if (model.isWithVideo) {
            // Photos
            NSString *path = [[NSString videoPath] stringByAppendingPathComponent:model.video];
            photo = [MWPhoto photoWithImage:[model.video getNamedVideoFrame]];
            photo.videoURL = [NSURL fileURLWithPath:path];
            photo.caption = model.prep;
            
            [photos addObject:photo];
        }
    }
    
    for (CLPerformModel *model in self.performModelList) {
        if (model.isWithImage) {
            
            // Photos
            photo = [MWPhoto photoWithImage:[model.image getNamedImage]];
            photo.caption = model.perform;
            [photos addObject:photo];
        }
    }
    
    
    for (CLPerformModel *model in self.performModelList) {
        if (model.isWithVideo) {
            // Photos
            NSString *path = [[NSString videoPath] stringByAppendingPathComponent:model.video];
            photo = [MWPhoto photoWithImage:[model.video getNamedVideoFrame]];
            photo.videoURL = [NSURL fileURLWithPath:path];
            photo.caption = model.perform;
            
            [photos addObject:photo];
        }
    }
    
    return photos;
}

- (NSMutableArray *)loadThumbs {
    
    NSMutableArray *thumbs = [NSMutableArray array];
    
    MWPhoto *thumb;
    if (self.effectModel.isWithImage) {
        
        thumb = [MWPhoto photoWithImage:[self.effectModel.image getNamedImageThumbnail]];
        [thumbs addObject:thumb];
        
    } else if (self.effectModel.isWithVideo) {
        
        thumb = [MWPhoto photoWithImage:[self.effectModel.video getNamedVideoThumbnail]];
        [thumbs addObject:thumb];
        
    }
    
    
    for (CLPrepModel *model in self.prepModelList) {
        if (model.isWithImage) {
            // Photos
            thumb = [MWPhoto photoWithImage:[model.image getNamedImageThumbnail]];
            [thumbs addObject:thumb];
            
        }
    }
    
    for (CLPrepModel *model in self.prepModelList) {
        if (model.isWithVideo) {
            thumb = [MWPhoto photoWithImage:[model.video getNamedVideoThumbnail]];
            [thumbs addObject:thumb];
        }
    }
    
    for (CLPerformModel *model in self.performModelList) {
        if (model.isWithImage) {
            thumb = [MWPhoto photoWithImage:[model.image getNamedImageThumbnail]];
            [thumbs addObject:thumb];
        }
    }
    
    for (CLPerformModel *model in self.performModelList) {
        if (model.isWithVideo) {
            thumb = [MWPhoto photoWithImage:[model.video getNamedVideoThumbnail]];
            [thumbs addObject:thumb];
        }
    }
    
    return thumbs;
}

- (NSInteger)getButtonTagWithPrepModel:(CLPrepModel *)prepModel {
    NSInteger tag = 0;
    
    if (!self.effectModel.isWithImage && !self.effectModel.isWithVideo) {
        tag = -1;   // 如果effectModel中没有多媒体, 则tag要减一,这样真正的第一张图片出现时就可以从0开始
    }
    
    for (CLPrepModel *model in self.prepModelList) {
        if (model == prepModel) {
            tag += 1;
            return tag;
        } else {
            if (model.isWithImage || model.isWithVideo) {
                tag += 1;
                
            }
        }
    }
    
    return tag;
}

- (NSInteger)getButtonTagWithPerformModel:(CLPerformModel *)performModel {
    
    NSInteger tag = 0;
    
    if (!self.effectModel.isWithImage && !self.effectModel.isWithVideo) {
        tag = -1;   // 如果effectModel中没有多媒体, 则tag要减一,这样真正的第一张图片出现时就可以从0开始
    }
    
    for (CLPrepModel *model in self.prepModelList) {
        
        if (model.isWithImage || model.isWithVideo) {
            tag += 1;
        }
    }
    
    for (CLPerformModel *model in self.performModelList) {
        if (model == performModel) {
            tag += 1;
            return tag;
        } else {
            if (model.isWithImage || model.isWithVideo) {
                tag += 1;
            }
        }
    }
    
    return tag;
}

- (void)showPhotoBrowser:(UIButton *)button {
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = YES;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:button.tag];
    // Show
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < self.thumbs.count)
        return [self.thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
//    return [[_selections objectAtIndex:index] boolValue];
//}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}
//
//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
//}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
//    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
