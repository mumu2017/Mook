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


@interface CLImportContentVC ()

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

@end

@implementation CLImportContentVC

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

- (NSAttributedString *)titleString {
    
    NSString *title;
    if (self.infoModel.isWithName) {
        title = self.infoModel.name;
    } else {
        title = NSLocalizedString(@"请编辑标题", nil);
    }
    
    return [NSString titleString:title withDate:self.date];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:kUpdateDataNotification
                                               object:nil];
    
}

- (void)setContentTitle {
   
    self.navigationItem.title = @"导入预览";

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

    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissImportContentVC" object:nil];

}

- (IBAction)importData:(id)sender {
    switch (self.contentType) {
        case kContentTypeIdea:
            [CLDataImportTool importIdea:self.ideaObjModel];
            break;
            
        case kContentTypeRoutine:
            [CLDataImportTool importRoutine:self.routineModel];
            break;
            
        case kContentTypeSleight:
            [CLDataImportTool importSleight:self.sleightObjModel];
            break;
            
        case kContentTypeProp:
            [CLDataImportTool importProp:self.propObjModel];
            break;
            
        case kContentTypeLines:
            [CLDataImportTool importLines:self.linesObjModel];
            break;
            
        default:
            break;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissImportContentVC" object:nil];


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
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

            [cell setImageWithVideoName:self.effectModel.video];
            
            return cell;
        } else if (self.effectModel.isWithImage) {
            
            CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
            
            cell.contentLabel.attributedText = [self.effectModel.effect styledString];

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

                [cell setImageWithVideoName:model.video];
                
                return cell;
                
            } else if (model.isWithImage) {
                CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
                
                cell.contentLabel.attributedText = [model.prep styledString];

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

                [cell setImageWithVideoName:model.video];
                
                return cell;
                
            } else if (model.isWithImage) {
                
                CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
                
                cell.contentLabel.attributedText = [model.prep styledString];

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

            [cell setImageWithVideoName:model.video];
            
            return cell;
            
        } if (model.isWithImage) {
            CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
            
            cell.contentLabel.attributedText = [perform styledString];

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


@end
