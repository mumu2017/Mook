//
//  CLContentVC.m
//  Mook
//
//  Created by 陈林 on 16/3/25.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLContentVC.h"
#import "CLNewEntryVC.h"

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

#import "QuartzCore/QuartzCore.h"
#import <AVFoundation/AVFoundation.h>

@interface CLContentVC ()

@property (nonatomic, strong) NSMutableArray *allItems;
@property (nonatomic, strong) NSMutableArray *ideaObjModelList;
@property (nonatomic, strong) NSMutableArray *showModelList;
@property (nonatomic, strong) NSMutableArray *routineModelList;
@property (nonatomic, strong) NSMutableArray *sleightObjModelList;
@property (nonatomic, strong) NSMutableArray *propObjModelList;
@property (nonatomic, strong) NSMutableArray *linesObjModelList;

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


@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end

@implementation CLContentVC

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

- (NSAttributedString *)titleString {
    
    NSString *title;
    if (self.infoModel.isWithName) {
        title = self.infoModel.name;
    } else {
        title = @"请编辑标题";
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

#pragma mark - 控制器方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setContentTitle];
    self.tableView.backgroundColor = [UIColor whiteColor];
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
    switch (self.contentType) {
        case kContentTypeIdea:
            self.navigationItem.title = kDefaultTitleIdea;
            break;
            
        case kContentTypeRoutine:
            self.navigationItem.title = kDefaultTitleRoutine;

            break;
            
        case kContentTypeSleight:
            self.navigationItem.title = kDefaultTitleSleight;

            break;
            
        case kContentTypeProp:
            self.navigationItem.title = kDefaultTitleProp;

            break;
            
        case kContentTypeLines:
            self.navigationItem.title = kDefaultTitleLines;

            break;
            
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void) update {
    // 重新刷新所有数据
    [self.tableView reloadData];
    // 设置图片数组为nil, 这样在懒加载的时候就可以重新刷新图片
    self.photos = nil;
    self.thumbs = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
            NSString *prop, *index;
            index = [NSString stringWithFormat:@"%ld.  ", (unsigned long)(indexPath.row+1)];
            
            if (model.isWithProp) {
                prop = [index stringByAppendingString:model.prop];
            } else {
                prop = [index stringByAppendingString:@"新建道具"];
            }
            
            if (model.isWithQuantity) {
                prop = [prop stringByAppendingString:[NSString stringWithFormat:@" x %@", model.quantity]];
            }
            
            if (model.isWithDetail) {
                prop = [prop stringByAppendingString:[NSString stringWithFormat:@"\n   %@", model.propDetail]];
            }
            
            cell.contentLabel.attributedText = [prop styledString];
            
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
        
        NSString *perform;
        if (model.isWithPerform) {
            perform = [NSString stringWithFormat:@"第%ld步 :  %@", (long)indexPath.row+1, model.perform];
        } else {
            perform = [NSString stringWithFormat:@"第%ld步 :  ", (long)indexPath.row+1];
        }
        
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
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        [view addSubview:label];
        label.frame = CGRectMake(kPadding, 0, kContentW, kLabelHeight);
        label.textAlignment =NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.alpha = 0.99;
        label.font = kBoldFontSys16;
        
        NSString *sectionTitle;
        if (section == self.infoSection) {
            sectionTitle = nil;
        } else if (section == self.effectSection && self.effectSection != self.infoSection) {
            if (self.contentType == kContentTypeRoutine) {
                sectionTitle = @"效果描述";
            } else if (self.contentType == kContentTypeIdea) {
                sectionTitle = @"灵感内容";

            } else if (self.contentType == kContentTypeSleight) {
                sectionTitle = @"技巧描述";

            } else if (self.contentType == kContentTypeProp) {
                sectionTitle = @"道具描述";

            } else if (self.contentType == kContentTypeLines) {
                sectionTitle = @"台词内容";

            }
        } else if (section == self.propSection && self.propSection != self.effectSection) {
            if (self.contentType == kContentTypeRoutine) {
                sectionTitle = @"道具清单";
            } else {
                sectionTitle = @"细节描述";
            }
        } else if (section == self.prepSection && self.prepSection != self.propSection) {
            if (self.contentType == kContentTypeRoutine) {
                sectionTitle = @"事前准备";
            }
        } else if (section == self.performSection && self.performSection != self.prepSection) {
            sectionTitle = @"表演细节";
        } else if (section == self.notesSection && self.notesSection != self.performSection) {
            sectionTitle = @"注意事项";
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
    BOOL autoPlayOnAppear = NO;
    
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
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
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
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - segue 方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[CLNewEntryVC class]]) {
        CLNewEntryVC *vc = (CLNewEntryVC *)destVC;
        
        
        if (self.contentType == kContentTypeIdea) {
            vc.editingContentType = kEditingContentTypeIdea;
            vc.ideaObjModel = self.ideaObjModel;

        } else if (self.contentType == kContentTypeRoutine) {
            vc.editingContentType = kEditingContentTypeRoutine;
            vc.routineModel = self.routineModel;

        } else if (self.contentType == kContentTypeSleight) {
            vc.editingContentType = kEditingContentTypeSleight;
            vc.sleightObjModel = self.sleightObjModel;

        } else if (self.contentType == kContentTypeProp) {
            vc.editingContentType = kEditingContentTypeProp;
            vc.propObjModel = self.propObjModel;

        } else if (self.contentType == kContentTypeLines) {
            vc.editingContentType = kEditingContentTypeLines;
            vc.linesObjModel = self.linesObjModel;

        }
        
        vc.title = @"编辑";
    }
}

@end
