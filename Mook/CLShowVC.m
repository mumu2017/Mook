//
//  CLShowVC.m
//  Mook
//
//  Created by 陈林 on 15/12/19.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLShowVC.h"
#import "CLShowModel.h"
#import "CLContentVC.h"
#import "CLNewShowVC.h"
#import "CLAudioPlayTool.h"

#import "CLTextCell.h"
#import "CLTextAudioCell.h"
#import "CLTextImageCell.h"
#import "CLTextAudioImageCell.h"

#import "CLNewShowVC.h"
#import "CLRoutineImageCell.h"
#import "CLRoutineTextCell.h"
#import "CLShowInfoCell.h"

#import "CLRoutineModel.h"
#import "CLInfoModel.h"
#import "CLEffectModel.h"
#import "UIViewController+BlurPresenting.h"

#import <AVFoundation/AVFoundation.h>
#import "CLAudioView.h"

@interface CLShowVC ()<SWTableViewCellDelegate, MWPhotoBrowserDelegate, AVAudioPlayerDelegate>
{
    AVAudioPlayer *_audioPlayer;
    CADisplayLink *_playProgressDisplayLink;

    CLAudioView *_audioView;
    
    UIBarButtonItem *_flexibleSpace;
    
    UIBarButtonItem *_playItem;
    UIBarButtonItem *_pauseItem;
    UIBarButtonItem *_detailItem;
    UIBarButtonItem *_stopItem;
    
    UIProgressView *_progressView;
}

@property (nonatomic, strong) NSMutableArray *routineModelList;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end

@implementation CLShowVC

- (CLShowModel *)showModel {
    
    if (!_showModel) {
        _showModel = [CLShowModel showModel];
    }
    return _showModel;
}

- (NSMutableArray *)routineModelList {
    if (!_routineModelList) {
        _routineModelList = [self.showModel getRountineModelList];
    }
    return _routineModelList;
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

// 遍历模型,加载图片
- (NSMutableArray *)loadPhotos {
    
    NSMutableArray *photos = [NSMutableArray array];
    MWPhoto *photo;
    
    if (self.showModel.effectModel.isWithImage) {
        // Photos
        photo = [MWPhoto photoWithImage:[self.showModel.effectModel.image getNamedImage]];
        photo.caption = self.showModel.effectModel.effect;
        [photos addObject:photo];
        
    } else if (self.showModel.effectModel.isWithVideo) {
        
        // Photos
        NSString *path = [[NSString videoPath] stringByAppendingPathComponent:self.showModel.effectModel.video];
        photo = [MWPhoto photoWithImage:[self.showModel.effectModel.video getNamedVideoFrame]];
        photo.videoURL = [NSURL fileURLWithPath:path];
        photo.caption = self.showModel.effectModel.effect;
        
        [photos addObject:photo];
    }
    
    for (CLRoutineModel *model in self.routineModelList) {
        if (model.effectModel.isWithImage) {
            
            // Photos
            photo = [MWPhoto photoWithImage:[model.effectModel.image getNamedImage]];
            photo.caption = model.effectModel.effect;
            [photos addObject:photo];
        } else if (model.effectModel.isWithVideo) {
            NSString *path = [[NSString videoPath] stringByAppendingPathComponent:model.effectModel.video];
            photo = [MWPhoto photoWithImage:[model.effectModel.video getNamedVideoFrame]];
            photo.videoURL = [NSURL fileURLWithPath:path];
            photo.caption = model.effectModel.effect;
            
            [photos addObject:photo];
        }
    }
    return photos;
}

- (NSInteger)getTagWithMediaName:(NSString *)name {
    
    NSInteger tag = -1;
    
    if (self.showModel.effectModel.isWithImage) {
        
        tag ++;
        if ([name isEqualToString:self.showModel.effectModel.image]) {
            return tag;
        }
        
    } else if (self.showModel.effectModel.isWithVideo) {
        
        tag ++;
        if ([name isEqualToString:self.showModel.effectModel.video]) {
            return tag;
        }
    }
    
    for (CLRoutineModel *model in self.routineModelList) {
        if (model.effectModel.isWithImage) {
            
            tag ++;
            if ([name isEqualToString:model.effectModel.image]) {
                return tag;
            }
            
        } else if (model.effectModel.isWithVideo) {
            
            tag ++;
            if ([name isEqualToString:model.effectModel.video]) {
                return tag;
            }
            
        }
    }
    
    return tag;
}

- (NSMutableArray *)loadThumbs {
    
    NSMutableArray *thumbs = [NSMutableArray array];
    
    MWPhoto *thumb;
    
    if (self.showModel.effectModel.isWithImage) {
        thumb = [MWPhoto photoWithImage:[self.showModel.effectModel.image getNamedImageThumbnail]];
        [thumbs addObject:thumb];
        
    } else if (self.showModel.effectModel.isWithVideo) {
        
        thumb = [MWPhoto photoWithImage:[self.showModel.effectModel.video getNamedVideoThumbnail]];
        [thumbs addObject:thumb];
    }
    
    for (CLRoutineModel *model in self.routineModelList) {
        if (model.effectModel.isWithImage) {
            
            thumb = [MWPhoto photoWithImage:[model.effectModel.image getNamedImageThumbnail]];
            [thumbs addObject:thumb];
            
        } else if (model.effectModel.isWithVideo) {
            thumb = [MWPhoto photoWithImage:[model.effectModel.video getNamedVideoThumbnail]];
            [thumbs addObject:thumb];
        }
    }
    
    return thumbs;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 用了下面两行代码之后, toolBar上方的黑边就去掉了
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    self.title = NSLocalizedString(@"演出", nil);
    self.tableView.estimatedRowHeight = 44;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelection = NO;

    self.tableView.backgroundColor = kCellBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerClass:[CLTextCell class]
           forCellReuseIdentifier:kTextCell];
    [self.tableView registerClass:[CLTextAudioCell class]
           forCellReuseIdentifier:kTextAudioCell];
    [self.tableView registerClass:[CLTextImageCell class]
           forCellReuseIdentifier:kTextImageCell];
    [self.tableView registerClass:[CLTextAudioImageCell class]
           forCellReuseIdentifier:kTextAudioImageCell];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLShowInfoCell"
                                               bundle:nil]
         forCellReuseIdentifier:kShowInfoCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLRoutineImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kRoutineImageCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLRoutineTextCell"
                                               bundle:nil]
         forCellReuseIdentifier:kRoutineTextCell];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:kUpdateDataNotification
                                               object:nil];

    [self initToolBarItems];
    
}


- (void)initToolBarItems {
    
    self.navigationController.toolbar.tintColor = kMenuBackgroundColor;
    
    _flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
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
    
}


- (void) update {
    // 重新刷新所有数据
    self.routineModelList = nil;
    [self.tableView reloadData];
//    // 设置图片数组为nil, 这样在懒加载的时候就可以重新刷新图片
//    self.photos = nil;
//    self.thumbs = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES];
    
    // 如果要去其他页面, 则停止播放录音
    if (_audioPlayer.isPlaying) {
        
        [_audioPlayer stop];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = 1;
            break;
          
        case 1:
            number = 3;
            break;
            
        case 2:
            number = 1;
            break;
            
        case 3:
            number = self.routineModelList.count;
            break;
            
        default:
            break;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            
            CLTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextCell forIndexPath:indexPath];
            NSString *title;
            if (self.showModel.name.length > 0) {
                title = self.showModel.name;
            } else {
                title = NSLocalizedString(@"请编辑标题", nil);
            }
            
            NSAttributedString *titleString = [NSString titleString:title withDate:self.showModel.date tags:self.showModel.tags];

            [cell setAttributedString:titleString];
            cell.contentLabel.textAlignment = NSTextAlignmentCenter;
            
            return cell;
        }
        case 1:
        {
            CLShowInfoCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kShowInfoCell forIndexPath:indexPath];
            
            NSString *title, *content;
            if (indexPath.row == 0) {
                title = NSLocalizedString(@"演出时长", nil);
                content = [self.showModel getDurationText];
            } else if (indexPath.row == 1) {
                title = NSLocalizedString(@"演出场地", nil);
                content = [self.showModel getPlaceText];
            } else if (indexPath.row == 2) {
                title = NSLocalizedString(@"观众数量", nil);
                content = [self.showModel getAudianceCountText];
            }
            cell.titleLabel.text = title;
            cell.contentLabel.text = content;
            
            return cell;
        }
        case 2:
        {
            
            NSAttributedString *text = [[NSString attributedStringWithFirstPart:NSLocalizedString(@"演出说明\n", nil) secondPart:[self.showModel getEffectText] firstPartFont:kBoldFontSys17 firstPartColor:[UIColor blackColor] secondPardFont:kFontSys17 secondPartColor:[UIColor blackColor]] styledString];;
            
            // 只有文字
            if (!self.showModel.effectModel.isWithAudio && !self.showModel.effectModel.isWithImage && !self.showModel.effectModel.isWithVideo) {
                CLTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextCell forIndexPath:indexPath];
                [cell setAttributedString:text];
                cell.contentLabel.textAlignment = NSTextAlignmentLeft;
                
                return cell;
                // 有文字和音频
            } else if (self.showModel.effectModel.isWithAudio && !self.showModel.effectModel.isWithImage && !self.showModel.effectModel.isWithVideo) {
                
                CLTextAudioCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextAudioCell forIndexPath:indexPath];
                
                [cell setAttributedString:text audioName:self.showModel.effectModel.audio playBlock:^(CLAudioView *audioView) {
                    
                    [self quickPlayWithAudioView:audioView];
                    
                } audioBlock:^(NSString *audioName) {
                    [self playAudio:audioName];
                }];
                
                [self setAudioViewStatusBeforeDisplay:cell.audioView];

   
                return cell;
                // 有文字,图片/视频
            } else if (!self.showModel.effectModel.isWithAudio && (self.showModel.effectModel.isWithImage || self.showModel.effectModel.isWithVideo)) {
                
                CLTextImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextImageCell forIndexPath:indexPath];
                
                [cell setAttributedString:text imageName:self.showModel.effectModel.image imageBlock:^(NSString *imageName) {
                    NSInteger index = [self getTagWithMediaName:self.showModel.effectModel.image];
                    [self showPhotoBrowser:index];
                    
                } videoName:self.showModel.effectModel.video videoBlock:^(NSString *videoName) {
                    NSInteger index = [self getTagWithMediaName:self.showModel.effectModel.video];
                    [self showPhotoBrowser:index];
                }];
                
                return cell;
                
                // 有文字, 音频和图片/视频
            } else if (self.showModel.effectModel.isWithAudio && (self.showModel.effectModel.isWithImage || self.showModel.effectModel.isWithVideo)) {
                
                CLTextAudioImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTextAudioImageCell forIndexPath:indexPath];
                
                [cell setAttributedString:text audioName:self.showModel.effectModel.audio playBlock:^(CLAudioView *audioView) {
                    
                    [self quickPlayWithAudioView:audioView];
                    
                } audioBlock:^(NSString *audioName) {
                    
                    [self playAudio:audioName];
                    
                } imageName:self.showModel.effectModel.image imageBlock:^(NSString *imageName) {
                    
                    NSInteger index = 0;
                    [self showPhotoBrowser:index];
                    
                } videoName:self.showModel.effectModel.video videoBlock:^(NSString *videoName) {
                    
                    NSInteger index = 0;
                    [self showPhotoBrowser:index];
                }];

                
                [self setAudioViewStatusBeforeDisplay:cell.audioView];
                
                return cell;
            }

            break;
        }
        case 3:
        {
            CLRoutineModel *model = self.routineModelList[indexPath.row];
            CLEffectModel *effectModel = model.effectModel;
            
            if (effectModel.isWithVideo) {
                
                CLRoutineImageCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kRoutineImageCell forIndexPath:indexPath];
                
                NSString *count = [NSString stringWithFormat:NSLocalizedString(@"流程 %ld  ", nil), indexPath.row+1];
                cell.titleLabel.text = [count stringByAppendingString:[model getTitle]];
                
                cell.effectLabel.attributedText = [[NSString attributedStringWithFirstPart:NSLocalizedString(@"效果  ", nil) secondPart:model.effectModel.effect firstPartFont:kBoldFontSys17 firstPartColor:[UIColor blackColor] secondPardFont:kFontSys17 secondPartColor:[UIColor blackColor]] styledString];
                
                cell.infoButton.tag = indexPath.row;
                [cell.infoButton addTarget:self action:@selector(showRoutineDetail:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.iconButton addTarget:self action:@selector(showPhotoBrowserWithButton:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.iconButton.tag = [self getTagWithMediaName:effectModel.video];

                [cell setImageWithVideoName:effectModel.video];
                
                cell.tintColor = kMenuBackgroundColor;
            
                return cell;
            } else if (effectModel.isWithImage) {
                
                CLRoutineImageCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kRoutineImageCell forIndexPath:indexPath];
                
                NSString *count = [NSString stringWithFormat:NSLocalizedString(@"流程 %ld  ", nil), indexPath.row+1];
                cell.titleLabel.text = [count stringByAppendingString:[model getTitle]];

                cell.effectLabel.attributedText = [[NSString attributedStringWithFirstPart:NSLocalizedString(@"效果  ", nil) secondPart:model.effectModel.effect firstPartFont:kBoldFontSys17 firstPartColor:[UIColor blackColor] secondPardFont:kFontSys17 secondPartColor:[UIColor blackColor]] styledString];
                
                cell.infoButton.tag = indexPath.row;
                [cell.infoButton addTarget:self action:@selector(showRoutineDetail:) forControlEvents:UIControlEventTouchUpInside];

                [cell.iconButton addTarget:self action:@selector(showPhotoBrowserWithButton:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.iconButton.tag = [self getTagWithMediaName:effectModel.image];
                
                [cell setImageWithName:effectModel.image];
                
                cell.tintColor = kMenuBackgroundColor;

                return cell;
                
            } else {
                CLRoutineTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kRoutineTextCell forIndexPath:indexPath];
                
                NSString *count = [NSString stringWithFormat:NSLocalizedString(@"流程 %ld  ", nil), indexPath.row+1];
                cell.titleLabel.text = [count stringByAppendingString:[model getTitle]];

                cell.effectLabel.attributedText = [[NSString attributedStringWithFirstPart:NSLocalizedString(@"效果  ", nil) secondPart:model.effectModel.effect firstPartFont:kBoldFontSys17 firstPartColor:[UIColor blackColor] secondPardFont:kFontSys17 secondPartColor:[UIColor blackColor]] styledString];
                cell.infoButton.tag = indexPath.row;
                [cell.infoButton addTarget:self action:@selector(showRoutineDetail:) forControlEvents:UIControlEventTouchUpInside];

                cell.tintColor = kMenuBackgroundColor;

                return cell;
            }

            break;
        }
        default:
            break;
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
        
        
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) return 15.0f;
    
    return 0;
}

- (void)showRoutineDetail:(UIButton *)button {
    
    [self performSegueWithIdentifier:kShowToRoutineSegue sender:button];

}

#pragma mark - Audio播放方法
- (void)playAudio:(NSString *)audioName {
    
    if (_audioPlayer.isPlaying) {
        
        [self pauseAction];
    }
    
    [CLAudioPlayTool playAudioFromCurrentController:self audioPath:[audioName getNamedAudio] audioPlayer:_audioPlayer];
    
}

- (void)quickPlayWithAudioView:(CLAudioView *)audioView {
    
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
    
    [self.navigationController setToolbarHidden:NO];

    [self setToolbarItems:@[_stopItem,_flexibleSpace, _playItem,_flexibleSpace,_detailItem] animated:YES];
    
    if ([self.navigationController.toolbar.subviews containsObject:_progressView] == NO) {
        
        [self.navigationController.toolbar addSubview:_progressView];
        _progressView.frame = CGRectMake(0, 0, self.navigationController.toolbar.frame.size.width, 5);
    }
    
}

- (void)toolBarAudioPlaying {
    
    [self.navigationController setToolbarHidden:NO];
    
    [self setToolbarItems:@[_stopItem,_flexibleSpace, _pauseItem,_flexibleSpace,_detailItem] animated:YES];
    
    if ([self.navigationController.toolbar.subviews containsObject:_progressView] == NO) {
        
        [self.navigationController.toolbar addSubview:_progressView];
        _progressView.frame = CGRectMake(0, 0, self.navigationController.toolbar.frame.size.width, 5);
    }
    
    
}

- (void)toolBarNormalAction {
    
    [self.navigationController setToolbarHidden:YES];
    [self setToolbarItems:nil];
    
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

#pragma mark - 导航方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[CLContentVC class]]) {
        CLContentVC *vc = (CLContentVC *)destVC;
        
        if ([sender isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)sender;
            
            CLRoutineModel *model = self.routineModelList[btn.tag];
            vc.contentType = kContentTypeRoutine;
            vc.routineModel = model;
            
        }
    } else if ([destVC isKindOfClass:[CLNewShowVC class]]) {
        CLNewShowVC *vc = (CLNewShowVC *)destVC;
        vc.showModel = self.showModel;
        vc.title = NSLocalizedString(@"编辑", nil);
    }
 
}

- (void)showPhotoBrowserWithButton:(UIButton *)button {
    
    [self showPhotoBrowser:button.tag];
}

- (void)showPhotoBrowser:(NSInteger)index {
    
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
    [browser setCurrentPhotoIndex:index];
    // Show
//    [self.navigationController pushViewController:browser animated:YES];
    [self presentNavigationViewControllerAnimated:browser];

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
