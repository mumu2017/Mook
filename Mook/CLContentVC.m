//
//  CLContentVC.m
//  Mook
//
//  Created by 陈林 on 16/3/25.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLContentVC.h"
#import "CLNewEntryVC.h"

#import "CLDataExportTool.h"

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

#import "UIViewController+BlurPresenting.h"

#import "CLTextCell.h"
#import "CLTextAudioCell.h"
#import "CLTextImageCell.h"
#import "CLTextAudioImageCell.h"

#import "QuartzCore/QuartzCore.h"
#import <AVFoundation/AVFoundation.h>
#import "CLAudioPlayTool.h"
#import "CLAudioView.h"


@interface CLContentVC ()<UIDocumentInteractionControllerDelegate, MBProgressHUDDelegate, AVAudioPlayerDelegate>

{
    AVAudioPlayer *_audioPlayer;
    CADisplayLink *_playProgressDisplayLink;
    CLAudioView *_audioView;
    
    UIBarButtonItem *_grid;
    UIBarButtonItem *_flexibleSpace;
    UIBarButtonItem *_action;
    
    UIBarButtonItem *_playItem;
    UIBarButtonItem *_pauseItem;
    UIBarButtonItem *_detailItem;
    UIBarButtonItem *_stopItem;

    UIProgressView *_progressView;

}

// section属性(需要根据model内容进行设置)
@property (nonatomic, assign) NSInteger infoSection;
@property (nonatomic, assign) NSInteger effectSection;
@property (nonatomic, assign) NSInteger propSection;
@property (nonatomic, assign) NSInteger prepSection;
@property (nonatomic, assign) NSInteger performSection;
@property (nonatomic, assign) NSInteger notesSection;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableArray *tags;

// 便于显示内容的模型单元
@property (nonatomic, strong) CLInfoModel *infoModel;
@property (nonatomic, strong) CLEffectModel *effectModel;
@property (nonatomic, strong) NSMutableArray *propModelList;
@property (nonatomic, strong) NSMutableArray *prepModelList;
@property (nonatomic, strong) NSMutableArray *performModelList;
@property (nonatomic, strong) NSMutableArray *notesModelList;

@property (nonatomic, copy) NSAttributedString *titleString;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, copy) NSString *exportPath;

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
    
    return self.infoSection + (self.effectModel.isWithEffect || self.effectModel.isWithImage || self.effectModel.isWithVideo || self.effectModel.isWithAudio);
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
            if (model.isWithPrep || model.isWithImage || model.isWithVideo || model.isWithAudio) {
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
            if (model.isWithPrep || model.isWithImage || model.isWithVideo || model.isWithAudio) {
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
            if (model.isWithPerform || model.isWithImage || model.isWithVideo || model.isWithAudio) {
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
    
    
    // 用了下面两行代码之后, toolBar上方的黑边就去掉了
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    [self setContentTitle];
        
    self.tableView.backgroundColor = kCellBgColor;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.allowsSelection = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[CLTextCell class]
         forCellReuseIdentifier:kTextCell];
    [self.tableView registerClass:[CLTextAudioCell class]
         forCellReuseIdentifier:kTextAudioCell];
    [self.tableView registerClass:[CLTextImageCell class]
         forCellReuseIdentifier:kTextImageCell];
    [self.tableView registerClass:[CLTextAudioImageCell class]
         forCellReuseIdentifier:kTextAudioImageCell];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:kUpdateDataNotification
                                               object:nil];
    
    [self initToolBarItems];
    
}


- (void)initToolBarItems {
    
    self.navigationController.toolbar.tintColor = kMenuBackgroundColor;
    
    
    // 普通状态
    _grid  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconGrid"] style:UIBarButtonItemStylePlain target:self action:@selector(showGrid)];
    _flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(export)];
    
    // 播放状态
    _stopItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop_playing"] style:UIBarButtonItemStylePlain target:self action:@selector(stopAction)];
    
    _playItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playAction)];
    
    _pauseItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseAction)];
    
    _detailItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(detailAction)];
    
    //进度条
    _progressView = [[UIProgressView alloc] init];
    
    _progressView.backgroundColor = [UIColor clearColor];
    
    _progressView.progressTintColor = kAppThemeColor;
    _progressView.tintColor = [UIColor whiteColor];
    
    [self setToolbarItems:@[_grid, _flexibleSpace, _action]];
    
    for (UIView *view in self.navigationController.toolbar.subviews) {
        if ([view isKindOfClass:[UIProgressView class]]) {
            
            [view removeFromSuperview];
        }
    }
    
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
    
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES];
    
    // 如果要去其他页面, 则停止播放录音
    if (_audioPlayer.isPlaying) {
        
        [self pauseAction];
    }
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
        
        CLTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextCell forIndexPath:indexPath];
        [cell setAttributedString:self.titleString];
        cell.contentLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
        // 效果部分
    } else if (indexPath.section == self.effectSection && self.effectSection != self.infoSection) {
        
        // 只有文字
        if (!self.effectModel.isWithAudio && !self.effectModel.isWithImage && !self.effectModel.isWithVideo) {
            CLTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextCell forIndexPath:indexPath];
            [cell setAttributedString:[self.effectModel.effect styledString]];
            cell.contentLabel.textAlignment = NSTextAlignmentLeft;

            return cell;
            // 有文字和音频
        } else if (self.effectModel.isWithAudio && !self.effectModel.isWithImage && !self.effectModel.isWithVideo) {
            
            CLTextAudioCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextAudioCell forIndexPath:indexPath];
            [cell setAttributedString:[self.effectModel.effect styledString] audioName:self.effectModel.audio playBlock:^(CLAudioView *audioView) {
                
                [self quickPlayWithAudioView:audioView];
                
            } audioBlock:^(NSString *audioName) {
                [self playAudio:audioName];
            }];
            
            [self setAudioViewStatusBeforeDisplay:cell.audioView];
            
            return cell;
            // 有文字,图片/视频
        } else if (!self.effectModel.isWithAudio && (self.effectModel.isWithImage || self.effectModel.isWithVideo)) {
            
            CLTextImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextImageCell forIndexPath:indexPath];
            
            [cell setAttributedString:[self.effectModel.effect styledString] imageName:self.effectModel.image imageBlock:^(NSString *imageName) {
                NSInteger index = 0;
                [self showPhotoBrowser:index];
                
            } videoName:self.effectModel.video videoBlock:^(NSString *videoName) {
                NSInteger index = 0;
                [self showPhotoBrowser:index];
            }];
            
            return cell;
            
            // 有文字, 音频和图片/视频
        } else if (self.effectModel.isWithAudio && (self.effectModel.isWithImage || self.effectModel.isWithVideo)) {
            
            CLTextAudioImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextAudioImageCell forIndexPath:indexPath];
            
            [cell setAttributedString:[self.effectModel.effect styledString] audioName:self.effectModel.audio playBlock:^(CLAudioView *audioView) {
                
                [self quickPlayWithAudioView:audioView];
                
            } audioBlock:^(NSString *audioName) {
                
                [self playAudio:audioName];
                
            } imageName:self.effectModel.image imageBlock:^(NSString *imageName) {
                
                NSInteger index = 0;
                [self showPhotoBrowser:index];
                
            } videoName:self.effectModel.video videoBlock:^(NSString *videoName) {
                
                NSInteger index = 0;
                [self showPhotoBrowser:index];
            }];
            [self setAudioViewStatusBeforeDisplay:cell.audioView];

            return cell;
        }
 
        // 道具部分
    } else if (indexPath.section == self.propSection && self.propSection != self.effectSection) {
        
        if (self.contentType == kContentTypeRoutine) {

            CLPropModel *model = self.propModelList[indexPath.row];
            NSString *prop;
            NSAttributedString *content;
            
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
                
                content = [[NSString attributedStringWithFirstPart:prop secondPart:detail firstPartFont:kFontSys17 firstPartColor:[UIColor blackColor] secondPardFont:kFontSys17 secondPartColor:[UIColor darkGrayColor]] styledString];
                
            } else {
                
                content = [prop styledString];
            }
            
            CLTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextCell forIndexPath:indexPath];
            
            [cell setAttributedString:content];
            cell.contentLabel.textAlignment = NSTextAlignmentLeft;
            
            return cell;
            
        } else {
            CLPrepModel *model = self.prepModelList[indexPath.row];
            
            // 只有文字
            if (!model.isWithAudio && !model.isWithImage && !model.isWithVideo) {
                CLTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextCell forIndexPath:indexPath];
                [cell setAttributedString:[model.prep styledString]];
                cell.contentLabel.textAlignment = NSTextAlignmentLeft;
                
                return cell;
                // 有文字和音频
            } else if (model.isWithAudio && !model.isWithImage && !model.isWithVideo) {
                
                CLTextAudioCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextAudioCell forIndexPath:indexPath];
                [cell setAttributedString:[model.prep styledString] audioName:model.audio playBlock:^(CLAudioView *audioView) {
                    
                    [self quickPlayWithAudioView:audioView];
                    
                } audioBlock:^(NSString *audioName) {
                    [self playAudio:audioName];
                }];
                [self setAudioViewStatusBeforeDisplay:cell.audioView];

                return cell;
                // 有文字,图片/视频
            } else if (!model.isWithAudio && (model.isWithImage || model.isWithVideo)) {
                
                CLTextImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextImageCell forIndexPath:indexPath];
                
                [cell setAttributedString:[model.prep styledString] imageName:model.image imageBlock:^(NSString *imageName) {
                    NSInteger index = [self getButtonTagWithPrepModel:model];
                    [self showPhotoBrowser:index];
                    
                } videoName:model.video videoBlock:^(NSString *videoName) {
                    NSInteger index = [self getButtonTagWithPrepModel:model];
                    [self showPhotoBrowser:index];
                }];
                
                return cell;
                
                // 有文字, 音频和图片/视频
            } else if (model.isWithAudio && (model.isWithImage || model.isWithVideo)) {
                
                CLTextAudioImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextAudioImageCell forIndexPath:indexPath];
                
                [cell setAttributedString:[model.prep styledString] audioName:model.audio playBlock:^(CLAudioView *audioView) {
                    
                    [self quickPlayWithAudioView:audioView];
                    
                } audioBlock:^(NSString *audioName) {
                    
                    [self playAudio:audioName];
                    
                } imageName:model.image imageBlock:^(NSString *imageName) {
                    
                    NSInteger index = [self getButtonTagWithPrepModel:model];
                    [self showPhotoBrowser:index];
                    
                } videoName:model.video videoBlock:^(NSString *videoName) {
                    
                    NSInteger index = [self getButtonTagWithPrepModel:model];
                    [self showPhotoBrowser:index];
                }];
                [self setAudioViewStatusBeforeDisplay:cell.audioView];

                return cell;
            }
        
        }
        
        // 准备部分
    } else if (indexPath.section == self.prepSection && self.prepSection != self.propSection) {
        
        if (self.contentType == kContentTypeRoutine) {
            CLPrepModel *model = self.prepModelList[indexPath.row];
            
            // 只有文字
            if (!model.isWithAudio && !model.isWithImage && !model.isWithVideo) {
                CLTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextCell forIndexPath:indexPath];
                [cell setAttributedString:[model.prep styledString]];
                cell.contentLabel.textAlignment = NSTextAlignmentLeft;
                
                return cell;
                // 有文字和音频
            } else if (model.isWithAudio && !model.isWithImage && !model.isWithVideo) {
                
                CLTextAudioCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextAudioCell forIndexPath:indexPath];
                [cell setAttributedString:[model.prep styledString] audioName:model.audio playBlock:^(CLAudioView *audioView) {
                    
                    [self quickPlayWithAudioView:audioView];
                    
                } audioBlock:^(NSString *audioName) {
                    [self playAudio:audioName];
                }];
                [self setAudioViewStatusBeforeDisplay:cell.audioView];

                return cell;
                // 有文字,图片/视频
            } else if (!model.isWithAudio && (model.isWithImage || model.isWithVideo)) {
                
                CLTextImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextImageCell forIndexPath:indexPath];
                
                [cell setAttributedString:[model.prep styledString] imageName:model.image imageBlock:^(NSString *imageName) {
                    NSInteger index = [self getButtonTagWithPrepModel:model];
                    [self showPhotoBrowser:index];
                    
                } videoName:model.video videoBlock:^(NSString *videoName) {
                    NSInteger index = [self getButtonTagWithPrepModel:model];
                    [self showPhotoBrowser:index];
                }];
                
                return cell;
                
                // 有文字, 音频和图片/视频
            } else if (model.isWithAudio && (model.isWithImage || model.isWithVideo)) {
                
                CLTextAudioImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextAudioImageCell forIndexPath:indexPath];
                
                [cell setAttributedString:[model.prep styledString] audioName:model.audio playBlock:^(CLAudioView *audioView) {
                    
                    [self quickPlayWithAudioView:audioView];
                    
                } audioBlock:^(NSString *audioName) {
                    
                    [self playAudio:audioName];
                    
                } imageName:model.image imageBlock:^(NSString *imageName) {
                    
                    NSInteger index = [self getButtonTagWithPrepModel:model];
                    [self showPhotoBrowser:index];
                    
                } videoName:model.video videoBlock:^(NSString *videoName) {
                    
                    NSInteger index = [self getButtonTagWithPrepModel:model];
                    [self showPhotoBrowser:index];
                }];
                [self setAudioViewStatusBeforeDisplay:cell.audioView];

                return cell;
            }
        }
        // 表演部分
    } else if (indexPath.section == self.performSection && self.performSection != self.prepSection) {
        
        CLPerformModel *model = self.performModelList[indexPath.row];
        
        // 只有文字
        if (!model.isWithAudio && !model.isWithImage && !model.isWithVideo) {
            CLTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextCell forIndexPath:indexPath];
            [cell setAttributedString:[model.perform styledString]];
            cell.contentLabel.textAlignment = NSTextAlignmentLeft;
            
            return cell;
            // 有文字和音频
        } else if (model.isWithAudio && !model.isWithImage && !model.isWithVideo) {
            
            CLTextAudioCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextAudioCell forIndexPath:indexPath];
            [cell setAttributedString:[model.perform styledString] audioName:model.audio playBlock:^(CLAudioView *audioView) {
                
                [self quickPlayWithAudioView:audioView];
                
            } audioBlock:^(NSString *audioName) {
                [self playAudio:audioName];
            }];
            [self setAudioViewStatusBeforeDisplay:cell.audioView];

            return cell;
            // 有文字,图片/视频
        } else if (!model.isWithAudio && (model.isWithImage || model.isWithVideo)) {
            
            CLTextImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextImageCell forIndexPath:indexPath];
            
            [cell setAttributedString:[model.perform styledString] imageName:model.image imageBlock:^(NSString *imageName) {
                NSInteger index = [self getButtonTagWithPerformModel:model];
                [self showPhotoBrowser:index];
                
            } videoName:model.video videoBlock:^(NSString *videoName) {
                NSInteger index = [self getButtonTagWithPerformModel:model];
                [self showPhotoBrowser:index];
            }];
            
            return cell;
            
            // 有文字, 音频和图片/视频
        } else if (model.isWithAudio && (model.isWithImage || model.isWithVideo)) {
            
            CLTextAudioImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextAudioImageCell forIndexPath:indexPath];
            
            [cell setAttributedString:[model.perform styledString] audioName:model.audio playBlock:^(CLAudioView *audioView) {
                
                [self quickPlayWithAudioView:audioView];
                
            } audioBlock:^(NSString *audioName) {
                
                [self playAudio:audioName];
                
            } imageName:model.image imageBlock:^(NSString *imageName) {
                
                NSInteger index = [self getButtonTagWithPerformModel:model];
                [self showPhotoBrowser:index];
                
            } videoName:model.video videoBlock:^(NSString *videoName) {
                
                NSInteger index = [self getButtonTagWithPerformModel:model];
                [self showPhotoBrowser:index];
            }];
            [self setAudioViewStatusBeforeDisplay:cell.audioView];

            return cell;
        }
        // 注意部分
    } else if (indexPath.section == self.notesSection && self.notesSection != self.performSection) {
        
        CLNotesModel *model = self.notesModelList[indexPath.row];
        
        // 只有文字
        if (!model.isWithAudio) {
            CLTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextCell forIndexPath:indexPath];
            [cell setAttributedString:[model.notes styledString]];
            cell.contentLabel.textAlignment = NSTextAlignmentLeft;
            
            return cell;
            // 有文字和音频
        } else if (model.isWithAudio) {
            
            CLTextAudioCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextAudioCell forIndexPath:indexPath];
            [cell setAttributedString:[model.notes styledString] audioName:model.audio playBlock:^(CLAudioView *audioView) {
                
                [self quickPlayWithAudioView:audioView];
                
            } audioBlock:^(NSString *audioName) {
                [self playAudio:audioName];
            }];
            [self setAudioViewStatusBeforeDisplay:cell.audioView];

            return cell;
            // 有文字,图片/视频
        }
        
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
                sectionTitle = NSLocalizedString(@"想法描述", nil);

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

#pragma mark - Audio播放方法
- (void)playAudio:(NSString *)audioName {

    if (_audioPlayer.isPlaying) {
        
        [self pauseAction];
    }
    
    [CLAudioPlayTool playAudioFromCurrentController:self audioPath:[audioName getNamedAudio] audioPlayer:_audioPlayer];
    
}

- (void)quickPlayWithAudioView:(CLAudioView *)audioView {
    
    [self toolBarAudioReady];
    
    NSString *audioName = audioView.audioName; //获取音频路径
    
    NSURL *url = [NSURL fileURLWithPath:[audioName getNamedAudio]];
    
    // 检测是否已经正在播放同一份音频
    if ([_audioPlayer.url.absoluteString isEqualToString:url.absoluteString]) { //正在播放同一份音频
        
        [self stopAction]; // 停止播放
        
    } else { //没有播放同一份音频
        
        if (_audioPlayer) { // 音频播放器已存在, 说明可能正在播放, 则停止
            [_audioPlayer stop];
            
            [_audioView setAudioPlayMode:kAudioPlayModeNotLoaded]; //更改上一个音频cell的状态(UI)
            
        }
        
        _audioView = audioView; // 处理完上一个音频view后, 将当前audioView设置为播放的audioView
        [_audioView setAudioPlayMode:kAudioPlayModeLoaded]; //更改音频状态为Loaded
        
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _audioPlayer.delegate = self;
        _audioPlayer.meteringEnabled = YES;
        
        [self playAction];
        
    }
    
}

- (void)setAudioViewStatusBeforeDisplay:(CLAudioView *)audioView {
    
    NSString *audioName = audioView.audioName; //获取音频路径
    
    NSURL *url = [NSURL fileURLWithPath:[audioName getNamedAudio]];
    
    // 检测是否已经正在播放同一份音频
    if ([_audioPlayer.url.absoluteString isEqualToString:url.absoluteString]) { //正在播放同一份音频
        if (_audioView != audioView) { //如果在播放同一份音频, 且控制器的_audioView并不是当前的audioView, 说明是当前audioView的Cell之前被tableView重用, 现在又滑到了相应Model的位置, 因此将两者设置为同一个audioView, 以便更新UI
            _audioView = audioView;
            
            [_audioView setAudioPlayMode:kAudioPlayModeLoaded];

        }
        
    } else { //没有播放同一份音频, 或者audioPlayer没有播放
        
        if (_audioPlayer.url == nil) return;
        
        if (_audioView == audioView) { //如果不是同一份音频, 则说明tableView重用了包含当前audioView的cell,为了防止UI错乱, 将系统的_audioView设为空
            _audioView = nil;
            
            [audioView setAudioPlayMode:kAudioPlayModeNotLoaded]; //更改状态为准备播放

        }
        
    }
}

#pragma mark 播放控件方法

- (void)playAction {
    
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    
    //UI Update
    [self toolBarAudioPlaying];
    
    {
        [_playProgressDisplayLink invalidate];
        _playProgressDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePlayProgress)];
        [_playProgressDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }

}

- (void)pauseAction {
    
    [_audioPlayer pause];
    [self toolBarAudioReady];
}

- (void)stopAction {
    
    [self toolBarNormalAction];
    _audioPlayer = nil;
    [_audioView setAudioPlayMode:kAudioPlayModeNotLoaded];

}

- (void)detailAction {
    
    [self playAudio:_audioView.audioName];
}



- (void)toolBarAudioReady {
    
    [self setToolbarItems:@[_stopItem,_flexibleSpace, _playItem,_flexibleSpace,_detailItem] animated:YES];
    
    if ([self.navigationController.toolbar.subviews containsObject:_progressView] == NO) {
        
        [self.navigationController.toolbar addSubview:_progressView];
        _progressView.frame = CGRectMake(0, 0, self.navigationController.toolbar.frame.size.width, 5);
    }
    
}

- (void)toolBarAudioPlaying {
    
    [self setToolbarItems:@[_stopItem,_flexibleSpace, _pauseItem,_flexibleSpace,_detailItem] animated:YES];
    
    if ([self.navigationController.toolbar.subviews containsObject:_progressView] == NO) {
        
        [self.navigationController.toolbar addSubview:_progressView];
        _progressView.frame = CGRectMake(0, 0, self.navigationController.toolbar.frame.size.width, 5);
    }

    
}

- (void)toolBarNormalAction {
    
    [self setToolbarItems:@[_grid, _flexibleSpace, _action] animated:YES];
    
    if ([self.navigationController.toolbar.subviews containsObject:_progressView]) {
        
        [_progressView removeFromSuperview];
    }
}

-(void)updatePlayProgress
{
    // 更新进度
    if (_progressView) {
        
        [_progressView setProgress:_audioPlayer.currentTime/_audioPlayer.duration];
    }

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        NSLog(@"播放完毕");
        [self toolBarAudioReady];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"%@", error);
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

- (void)showPhotoBrowser:(NSInteger)index {
    
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
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:index];
    // Show
//    [self.navigationController pushViewController:browser animated:YES];
    [self presentNavigationViewControllerAnimated:browser];
}

- (void)showGrid {
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    BOOL autoPlayOnAppear = NO;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // 手势返回的触发宽度(距离屏幕左边)只占screenWidth的1/10
//    browser.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = kScreenW/10;
    
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:0];
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
        
        vc.title = NSLocalizedString(@"编辑", nil);
    }
}

#pragma mark - 导出笔记
// 导出笔记 (选择是否密码导出)
- (void)export {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"导出笔记", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* exportWithPassword = [UIAlertAction actionWithTitle:NSLocalizedString(@"密码导出", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self passwordExport];
        
    }];
    
    UIAlertAction* exportWithoutPassword = [UIAlertAction actionWithTitle:NSLocalizedString(@"直接导出", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self exportCurrentEntryWithPassword:@""];
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:exportWithPassword];
    [alert addAction:exportWithoutPassword];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

// 密码导出
- (void)passwordExport {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"设置导出密码", nil) message:NSLocalizedString(@"请输入笔记密码", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"导出密码", nil);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.font = kFontSys16;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"导出", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *passwordTF = alertController.textFields.firstObject;
        
        NSString *exportPassword = passwordTF.text;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
        [self exportCurrentEntryWithPassword:exportPassword];
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        UITextField *passwordTF = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = passwordTF.text.length > 0;
    }];
    
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *nameTF = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = nameTF.text.length > 0;
    }
}


- (void)exportCurrentEntryWithPassword:(NSString *)importPassword {
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
    [self.tabBarController.view addSubview:HUD];
    
    HUD.delegate = self;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        
        switch (self.contentType) {
            case kContentTypeIdea:
                self.exportPath = [CLDataExportTool makeDataPackageWithIdea:self.ideaObjModel passWord:importPassword];
                break;
                
            case kContentTypeRoutine:
                self.exportPath = [CLDataExportTool makeDataPackageWithRoutine:self.routineModel passWord:importPassword];
                
                break;
                
            case kContentTypeSleight:
                self.exportPath = [CLDataExportTool makeDataPackageWithSleight:self.sleightObjModel passWord:importPassword];
                
                break;
                
            case kContentTypeProp:
                self.exportPath = [CLDataExportTool makeDataPackageWithProp:self.propObjModel passWord:importPassword];
                
                break;
                
            case kContentTypeLines:
                self.exportPath = [CLDataExportTool makeDataPackageWithLines:self.linesObjModel passWord:importPassword];
                
                break;
                
            default:
                break;
        }
        
    } onQueue:dispatch_get_main_queue() completionBlock:^{
        
        if (self.exportPath != nil) {
            NSURL *dataUrl;
            dataUrl = [NSURL fileURLWithPath:self.exportPath];
            
            CGRect navRect = self.view.frame;
            self.documentInteractionController =[UIDocumentInteractionController interactionControllerWithURL:dataUrl];
            self.documentInteractionController.delegate = self;
            
            [self.documentInteractionController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
        } else {
            
            [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"导出失败", nil) hideAfterDelay:1.0];

        }
    }];
    
}

#pragma mark - UIDocumentInteractionControllerDelegate

//===================================================================
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}


@end
