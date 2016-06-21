//
//  CLMediaVC.m
//  Mook
//
//  Created by 陈林 on 16/4/3.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLMediaVC.h"
#import "CLMediaCollectionCell.h"
#import "CLDataSaveTool.h"
#import "CLGetMediaTool.h"
#import "CLNewEntryTool.h"

#import "MWPhotoBrowser.h"
#import "Pop.h"

#import "CLContentVC.h"
#import "CLShowVC.h"

#import "CLInfoModel.h"
#import "CLShowModel.h"
#import "CLIdeaObjModel.h"
#import "CLRoutineModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"
#import "CLTableBackView.h"
#import "CLAddView.h"

#import "MASonry.h"

#import "BTNavigationDropdownMenu-Swift.h"
@class BTNavigationDropdownMenu;


typedef enum {
    
    kMediaTypeVideos = 0,
    kMediaTypeImages,
    kMediaTypeAll,

} MediaType;

@interface CLMediaVC ()<MWPhotoBrowserDelegate>
@property (assign, nonatomic) MediaType mediaType;

@property (nonatomic, strong) NSMutableArray *allMedia; // 多媒体数组

@property (nonatomic, strong) NSMutableArray *dataList; // 数据模型数组

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@property (strong, nonatomic) BTNavigationDropdownMenu *menu;

@property (nonatomic, strong) CLTableBackView *tableBackView;

@property (strong, nonatomic) UIButton *addButton;
@property (strong, nonatomic) UIButton *coverButton;

@property (strong, nonatomic) CLAddView *addView;

@end

@implementation CLMediaVC

- (void)setMediaType:(MediaType )mediaType {
    
    if (_mediaType != mediaType) {
        
        _mediaType = mediaType;
        [self update];

    }
}

- (NSMutableArray *)allMedia {
    if (!_allMedia) {
        
        if (_mediaType == kMediaTypeAll) {
            _allMedia = [CLDataSaveTool allMedia];
            
        } else if (_mediaType == kMediaTypeVideos) {
            _allMedia = [CLDataSaveTool allVideos];
            
        } else if (_mediaType == kMediaTypeImages) {
            _allMedia = [CLDataSaveTool allImages];
            
        }
        
    }
    return _allMedia;
}

- (UIButton *)coverButton {
    if (!_coverButton) {
        _coverButton = [[UIButton alloc] initWithFrame:self.navigationController.view.frame];
        [self.navigationController.view addSubview:_coverButton];
        _coverButton.backgroundColor = [UIColor darkGrayColor];
        _coverButton.alpha = 0.0;
        _coverButton.enabled = NO;
        
        [_coverButton addTarget:self action:@selector(toggleAddView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.navigationController.view addSubview:_addButton];
        
        [_addButton addTarget:self action:@selector(toggleAddView) forControlEvents:UIControlEventTouchUpInside];
        //        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.navigationController.view.mas_right).with.offset(-15);
            make.bottom.equalTo(self.navigationController.view.mas_bottom).with.offset(-64);
            make.width.height.equalTo(@kAddButtonHeight);
        }];
        _addButton.layer.cornerRadius = kAddButtonHeight/2;
        _addButton.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
        _addButton.alpha = 1.0f;
        
    }
    
    return _addButton;
}

- (CLAddView *)addView {
    if (!_addView) {
        _addView = [[CLAddView alloc] initWithFrame:CGRectMake(self.addButton.center.x, self.addButton.center.y, 0, 0)];
        [self.navigationController.view addSubview:_addView];
        _addView.hidden = NO;
        
        [_addView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(self.navigationController.view.mas_width).offset( -kAddButtonHeight);
            make.height.equalTo(_addView.mas_width).multipliedBy(1.5);
            make.centerX.equalTo(self.navigationController.view);
            make.top.equalTo(self.navigationController.view.mas_bottom).offset(_addView.frame.size.height);
        }];
        _addView.center = CGPointMake(self.navigationController.view.center.x, CGRectGetMaxY(self.navigationController.view.frame)+self.addView.frame.size.height/2);
        
        _addView.backgroundColor = [UIColor clearColor];
        [_addView initSubViews];
        [_addView updateColor:self.addButton.backgroundColor];
        
        [_addView addTarget:self action:@selector(toggleAddView) forControlEvents:UIControlEventTouchUpInside];
        
        [_addView.ideaBtn addTarget:self action:@selector(addNewIdeaWithVideo) forControlEvents:UIControlEventTouchUpInside];
//        [_addView.showBtn addTarget:self action:@selector(addNewShow) forControlEvents:UIControlEventTouchUpInside];
        [_addView.routineBtn addTarget:self action:@selector(addNewRoutineWithVideo) forControlEvents:UIControlEventTouchUpInside];
        [_addView.sleightBtn addTarget:self action:@selector(addNewSleightWithVideo) forControlEvents:UIControlEventTouchUpInside];
        [_addView.propBtn addTarget:self action:@selector(addNewPropWithVideo) forControlEvents:UIControlEventTouchUpInside];
//        [_addView.linesBtn addTarget:self action:@selector(addNewLines) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addView;
}


- (BTNavigationDropdownMenu *)menu {
    if (!_menu) {
        
        NSArray *items = [NSArray arrayWithObjects:NSLocalizedString(@"视频", nil), NSLocalizedString(@"图片", nil), NSLocalizedString(@"全部", nil), nil];
        _menu = [[BTNavigationDropdownMenu alloc] initWithTitle:items[0] items:items];
        self.mediaType = kMediaTypeVideos;
        [_menu setDidSelectItemAtIndexHandler:^(NSInteger index) {
            switch (index) {
                case 0:
                    _mediaType = kMediaTypeVideos;
                    break;
                case 1:
                    _mediaType = kMediaTypeImages;
                    break;
                case 2:
                    _mediaType = kMediaTypeAll;
                    break;
                default:
                    break;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:nil];
        }];
        
        _menu.cellBackgroundColor = kAppThemeColor;
        _menu.cellSelectionColor = [UIColor whiteColor];
        _menu.cellSeparatorColor = [UIColor flatGrayColorDark];
        
    }
    return _menu;
}

- (CLTableBackView *)tableBackView {
    if (!_tableBackView) {
        _tableBackView = [CLTableBackView tableBackView];
    }
    return _tableBackView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
        
        NSString *type, *modelName, *mediaName, *mediaType;
        for (NSDictionary *dict in self.allMedia) {
            type = [dict objectForKey:@"model_type"];
            modelName = [dict objectForKey:@"model_time_stamp"];
            
            mediaName = [dict objectForKey:@"name"];
            mediaType = [dict objectForKey:@"type"];
            
            if ([type isEqualToString:kTypeIdea]) {
                CLIdeaObjModel *model = [CLDataSaveTool ideaByName:modelName];
                if (model == nil) { // 如果模型为空, 则说明不再媒体表中的媒体所属的模型已经从t_mook表中删除掉了, 所以需要删除该媒体文件和数据表条目
                    if ([mediaType isEqualToString:@"video"]) {
                        [mediaName deleteNamedVideoFromDocument];
                    } else if ([mediaType isEqualToString:@"image"]) {
                        [mediaName deleteNamedImageFromDocument];
                    }
                } else {
                    [_dataList addObject:model];
                }

            }  else if ([type isEqualToString:kTypeShow]) {
                CLShowModel *model = [CLDataSaveTool showByName:modelName];

                if (model == nil) { // 如果模型为空, 则说明不再媒体表中的媒体所属的模型已经从t_mook表中删除掉了, 所以需要删除该媒体文件和数据表条目
                    //                    [self.allMedia removeObject:dict];
                    if ([mediaType isEqualToString:@"video"]) {
                        [mediaName deleteNamedVideoFromDocument];
                    } else if ([mediaType isEqualToString:@"image"]) {
                        [mediaName deleteNamedImageFromDocument];
                    }
                } else {
                    [_dataList addObject:model];
                }
                
            }  else if ([type isEqualToString:kTypeRoutine]) {
                CLRoutineModel *model = [CLDataSaveTool routineByName:modelName];

                if (model == nil) { // 如果模型为空, 则说明不再媒体表中的媒体所属的模型已经从t_mook表中删除掉了, 所以需要删除该媒体文件和数据表条目
                    //                    [self.allMedia removeObject:dict];
                    if ([mediaType isEqualToString:@"video"]) {
                        [mediaName deleteNamedVideoFromDocument];
                    } else if ([mediaType isEqualToString:@"image"]) {
                        [mediaName deleteNamedImageFromDocument];
                    }
                } else {
                    [_dataList addObject:model];
                }
            } else if ([type isEqualToString:kTypeSleight]) {
                CLSleightObjModel *model = [CLDataSaveTool sleightByName:modelName];
                if (model == nil) { // 如果模型为空, 则说明不再媒体表中的媒体所属的模型已经从t_mook表中删除掉了, 所以需要删除该媒体文件和数据表条目
                    //                    [self.allMedia removeObject:dict];
                    if ([mediaType isEqualToString:@"video"]) {
                        [mediaName deleteNamedVideoFromDocument];
                    } else if ([mediaType isEqualToString:@"image"]) {
                        [mediaName deleteNamedImageFromDocument];
                    }
                } else {
                    [_dataList addObject:model];
                }
            } else if ([type isEqualToString:kTypeProp]) {
                CLPropObjModel *model = [CLDataSaveTool propByName:modelName];
                if (model == nil) { // 如果模型为空, 则说明不再媒体表中的媒体所属的模型已经从t_mook表中删除掉了, 所以需要删除该媒体文件和数据表条目
                    //                    [self.allMedia removeObject:dict];
                    if ([mediaType isEqualToString:@"video"]) {
                        [mediaName deleteNamedVideoFromDocument];
                    } else if ([mediaType isEqualToString:@"image"]) {
                        [mediaName deleteNamedImageFromDocument];
                    }
                } else {
                    [_dataList addObject:model];
                }
            } else if ([type isEqualToString:kTypeLines]) {
                CLLinesObjModel *model = [CLDataSaveTool linesByName:modelName];
                if (model == nil) { // 如果模型为空, 则说明不再媒体表中的媒体所属的模型已经从t_mook表中删除掉了, 所以需要删除该媒体文件和数据表条目
                    //                    [self.allMedia removeObject:dict];
                    if ([mediaType isEqualToString:@"video"]) {
                        [mediaName deleteNamedVideoFromDocument];
                    } else if ([mediaType isEqualToString:@"image"]) {
                        [mediaName deleteNamedImageFromDocument];
                    }
                } else {
                    [_dataList addObject:model];
                }
            }
            
        }
    }
    return _dataList;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
        NSString *type, *name, *content;
        MWPhoto *photo;
        
        for (NSDictionary *dict in self.allMedia) { // allMedia中已经从最近到最早排序了
            name = [dict objectForKey:@"name"];
            type = [dict objectForKey:@"type"];
            content = [dict objectForKey:@"content"];
            
            if ([type isEqualToString:@"video"]) {
                NSString *path = [[NSString videoPath] stringByAppendingPathComponent:name];
                photo = [MWPhoto photoWithImage:[name getNamedVideoFrame]];
                photo.videoURL = [NSURL fileURLWithPath:path];
                photo.caption = content;
                
                [_photos addObject:photo];

            } else if ([type isEqualToString:@"image"]) {
                photo = [MWPhoto photoWithImage:[name getNamedImage]];
                photo.caption = content;
                [_photos addObject:photo];
//                NSLog(@"111111");
            }
        }
    }
    return _photos;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self coverButton];
    self.navigationItem.titleView = self.menu;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, kAddButtonHeight, 0);
    self.collectionView.backgroundView = self.tableBackView;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CLMediaCollectionCell" bundle: nil] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:kUpdateDataNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateMookNotification
                                               object:nil];
    
    [self addView];
    [self addButton];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    [self.navigationController setToolbarHidden:YES];
//}

- (void) update {

    self.allMedia = nil;
    self.photos = nil;
    self.dataList = nil;
    
    self.menu.cellBackgroundColor = kAppThemeColor;

    [self.collectionView reloadData];
    
    self.addButton.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
    self.menu.cellBackgroundColor = kAppThemeColor;
    [self.addView updateColor:self.addButton.backgroundColor];
}

- (void) update:(NSNotification *)noti {
    
    if (noti.object == self) {  //如果是自己发出的更新通知,则不刷新.
        return;
    }
    
    [self update];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.addButton.hidden = NO;
    [self.navigationController setToolbarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.addButton.hidden = YES;
    [self.menu hide];
    if (self.addView.center.y == self.navigationController.view.center.y) {
        [self toggleAddView];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSInteger number = self.allMedia.count;
    self.tableBackView.hidden = !(number == 0);
    return number;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CLMediaCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dict = self.allMedia[indexPath.row];
    cell.name = [dict objectForKey:@"name"];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake((self.view.frame.size.width-1)/2, (self.view.frame.size.width-1)/2);
    return CGSizeMake((self.view.frame.size.width-2)/3, (self.view.frame.size.width-2)/3);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1; // This is the minimum inter item spacing, can be more
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showPhotoBrowser:indexPath];
//    NSLog(@"~~");
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)showPhotoBrowser:(NSIndexPath *)indexPath {
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
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
    [browser setCurrentPhotoIndex:indexPath.row];
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

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
    
    id modelUnknown = self.dataList[index];
    
    if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
        
        [self performSegueWithIdentifier:kSegueMediaToShow sender:modelUnknown];
    } else {
        [self performSegueWithIdentifier:kSegueMediaToContent sender:modelUnknown];

    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)modelUnknown {
    
    UIViewController *destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[CLContentVC class]]) {
        CLContentVC *vc = (CLContentVC *)destVC;
        
        if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
            CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
            vc.contentType = kContentTypeIdea;
            vc.ideaObjModel = model;
            
        } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
            CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
            vc.contentType = kContentTypeRoutine;
            vc.routineModel = model;
            
        } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
            CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
            vc.contentType = kContentTypeSleight;
            vc.sleightObjModel = model;
            
        } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
            CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
            vc.contentType = kContentTypeProp;
            vc.propObjModel = model;
            
        } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
            CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
            vc.contentType = kContentTypeLines;
            vc.linesObjModel = model;
        }
        
    } else if ([destVC isKindOfClass:[CLShowVC class]]) {
        CLShowVC *vc = (CLShowVC *)destVC;
        if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
            
            CLShowModel *model = (CLShowModel *)modelUnknown;
            vc.showModel = model;
            vc.date = model.date;
        }
    }
}

#pragma mark - 新建笔记方法

- (void)toggleAddView {
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    
    //弹性值
    springAnimation.springBounciness = 10.0;
    //弹性速度
    springAnimation.springSpeed = 15.0;
    
    CGPoint point = self.addView.center;
    
    if (point.y == self.navigationController.view.center.y) {
        
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, CGRectGetMaxY(self.navigationController.view.frame)+self.addView.frame.size.height)];
        
        self.coverButton.enabled = NO;
        self.coverButton.alpha = 0.0;
        [self.addView pop_addAnimation:springAnimation forKey:@"changeposition"];
        
        [_addButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
        
    }
    else{
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, self.navigationController.view.center.y)];
        [self.addView pop_addAnimation:springAnimation forKey:@"changeposition"];
        
        self.coverButton.enabled = YES;
        self.coverButton.alpha = 0.9;
        [_addButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    }
    
}

- (void)addNewIdeaWithVideo {
    
    [[CLGetMediaTool getInstance] recordVideoFromCurrentController:self maximumDuration:30.0 resultBlock:^(NSURL *videoURL) {
        
        [CLNewEntryTool addNewIdeaFromCurrentController:self withVideo:videoURL];
    }];
}

- (void)addNewRoutineWithVideo {
    
    [[CLGetMediaTool getInstance] recordVideoFromCurrentController:self maximumDuration:30.0 resultBlock:^(NSURL *videoURL) {
        
        [CLNewEntryTool addNewRoutineFromCurrentController:self withVideo:videoURL];
    }];
}

- (void)addNewSleightWithVideo {
    
    [[CLGetMediaTool getInstance] recordVideoFromCurrentController:self maximumDuration:30.0 resultBlock:^(NSURL *videoURL) {
        
        [CLNewEntryTool addNewSleightFromCurrentController:self withVideo:videoURL];
    }];
}

- (void)addNewPropWithVideo {
    
    [[CLGetMediaTool getInstance] recordVideoFromCurrentController:self maximumDuration:30.0 resultBlock:^(NSURL *videoURL) {
        
        [CLNewEntryTool addNewPropFromCurrentController:self withVideo:videoURL];
    }];
}



@end
