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
#import "FDWaveformView.h"

@interface CLShowVC ()<SWTableViewCellDelegate, MWPhotoBrowserDelegate, AVAudioPlayerDelegate>
{
    AVAudioPlayer *_audioPlayer;
    CADisplayLink *_playProgressDisplayLink;
    FDWaveformView * _waveformView;
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
                
//                [cell setAttributedString:text audioName:self.showModel.effectModel.audio playBlock:^(NSString *audioName, FDWaveformView *waveformView) {
//                    
//                    [self quickPlay:audioName waveformView:waveformView];
//                    
//                }  audioBlock:^(NSString *audioName) {
//                    [self playAudio:audioName];
//                }];
   
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
                
//                [cell setAttributedString:text audioName:self.showModel.effectModel.audio audioBlock:^(NSString *audioName) {
//                    [self playAudio:audioName];
//                    
//                } imageName:self.showModel.effectModel.image imageBlock:^(NSString *imageName) {
//                    
//                    NSInteger index = [self getTagWithMediaName:self.showModel.effectModel.image];
//                    [self showPhotoBrowser:index];
//                    
//                } videoName:self.showModel.effectModel.video videoBlock:^(NSString *videoName) {
//                    
//                    NSInteger index = [self getTagWithMediaName:self.showModel.effectModel.video];
//                    [self showPhotoBrowser:index];
//                }];
                
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

#pragma mark -Audio 方法
- (void)playAudio:(NSString *)audioName {
    
    if (_audioPlayer.isPlaying) {
        [_audioPlayer stop];
        
    }
    [CLAudioPlayTool playAudioFromCurrentController:self audioPath:[audioName getNamedAudio]];
    
}

- (void)quickPlay:(NSString *)audioName waveformView:(FDWaveformView *)waveformView {
    
    _waveformView = waveformView;
    
    NSURL *url = [NSURL fileURLWithPath:[audioName getNamedAudio]];
    
    if ([_audioPlayer.url.absoluteString isEqualToString:url.absoluteString]) {
        
        if (_audioPlayer.isPlaying) {
            [_audioPlayer pause];
            
        } else {
            
            [_audioPlayer play];
        }
        
    } else {
        
        if (_audioPlayer) {
            [_audioPlayer stop];
        }
        
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _audioPlayer.delegate = self;
        _audioPlayer.meteringEnabled = YES;
        
        [_playProgressDisplayLink invalidate];
        _playProgressDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePlayProgress)];
        
        [_playProgressDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        [_audioPlayer prepareToPlay];
        [_audioPlayer play];
    }
    
}

-(void)updatePlayProgress
{
    _waveformView.progressSamples = _waveformView.totalSamples*(_audioPlayer.currentTime/_audioPlayer.duration);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        NSLog(@"播放完毕");
        
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"%@", error);
}

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
