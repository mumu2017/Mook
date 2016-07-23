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
//#import "CLListRefreshHeader.h"

//#import "BTNavigationDropdownMenu-Swift.h"
//@class BTNavigationDropdownMenu;


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

//@property (strong, nonatomic) BTNavigationDropdownMenu *menu;

@property (strong, nonatomic) UISegmentedControl *segControl;

@property (nonatomic, strong) CLTableBackView *tableBackView;

@end

@implementation CLMediaVC

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


- (UISegmentedControl *)segControl {
    
    if (!_segControl) {
        _segControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"视频", nil), NSLocalizedString(@"图片", nil)]];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 132, 30)];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:_segControl];
        self.navigationItem.titleView = view;
        
        [_segControl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(view);
        }];
        
        _segControl.selectedSegmentIndex = 0;
        _mediaType = kMediaTypeVideos;
        
        
        _segControl.backgroundColor = [UIColor clearColor];
        _segControl.tintColor = [UIColor whiteColor];
        [_segControl addTarget:self action:@selector(changeList:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segControl;
}

- (void)changeList:(UISegmentedControl *)segControl {
    
    switch (segControl.selectedSegmentIndex) {
//        case 0:
//            _mediaType = kMediaTypeAll;
//            
//            break;
        case 0:
            _mediaType = kMediaTypeVideos;
            
            break;
        case 1:
            _mediaType = kMediaTypeImages;
            break;
        default:
            break;
    }
    
    self.allMedia = nil;
    self.photos = nil;
    self.dataList = nil;
    
    [self allMedia];
    [self photos];
    [self dataList];
    
    [self.collectionView reloadData];
    
    if ([self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0] > 0) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self prepareVisibleCellsForAnimation];
        [self animateVisibleCells];
    });

}

//- (BTNavigationDropdownMenu *)menu {
//    if (!_menu) {
//        
//        NSArray *items = [NSArray arrayWithObjects:NSLocalizedString(@"全部", nil), NSLocalizedString(@"视频", nil), NSLocalizedString(@"图片", nil), nil];
//        _menu = [[BTNavigationDropdownMenu alloc] initWithTitle:items[0] items:items];
//        self.mediaType = kMediaTypeAll;
//        
//        __weak typeof(self) weakself = self;
//
//        [_menu setDidSelectItemAtIndexHandler:^(NSInteger index) {
//            
//            typeof(self) strongself = weakself;
//
//            switch (index) {
//                case 0:
//                    _mediaType = kMediaTypeAll;
//
//                    break;
//                case 1:
//                    _mediaType = kMediaTypeVideos;
//
//                    break;
//                case 2:
//                    _mediaType = kMediaTypeImages;
//                    break;
//                default:
//                    break;
//            }
//            
//            strongself.allMedia = nil;
//            strongself.photos = nil;
//            strongself.dataList = nil;
//            
//            [strongself allMedia];
//            [strongself photos];
//            [strongself dataList];
//            
//            [strongself.collectionView reloadData];
//            
//            if ([strongself.collectionView.dataSource collectionView:strongself.collectionView numberOfItemsInSection:0] > 0) {
//                
//                [strongself.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//            }
//            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [strongself prepareVisibleCellsForAnimation];
//                [strongself animateVisibleCells];
//            });
//
//        }];
//        
//        _menu.cellTextLabelColor = kTintColor;
//        _menu.menuTitleColor = kTintColor;
//        _menu.cellBackgroundColor = kAppThemeColor;
//        _menu.cellSelectionColor = [UIColor whiteColor];
//        _menu.cellSeparatorColor = [UIColor flatGrayColorDark];
//        
//    }
//    return _menu;
//}

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
            }
        }
    }
    return _photos;
}

static NSString * const reuseIdentifier = @"Cell";


#pragma mark - VC 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self segControl];
    
//    self.navigationItem.titleView = self.menu;
    
//    self.collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    
    self.collectionView.backgroundView = self.tableBackView;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CLMediaCollectionCell" bundle: nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:kUpdateDataNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateMookNotification
                                               object:nil];
    
//    [self setRefreshHeader];
}

//- (void)setRefreshHeader {
//    
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    CLListRefreshHeader *header = [CLListRefreshHeader headerWithRefreshingBlock:^{
//        
//        [self.collectionView.mj_header endRefreshing];
//    }];
//    
//    header.endRefreshingCompletionBlock = ^ () {
//        
//        [self showMenu];
//    };
//    
//    // 设置文字
//    [header setTitle:@"下拉可以切换笔记" forState:MJRefreshStateIdle];
//    [header setTitle:@"松开马上切换笔记" forState:MJRefreshStatePulling];
//    [header setTitle:@"" forState:MJRefreshStateRefreshing];
//    
//    // 设置字体
//    header.stateLabel.font = [UIFont systemFontOfSize:16];
//    
//    // 设置颜色
//    header.stateLabel.textColor = [UIColor whiteColor];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    
//    header.automaticallyChangeAlpha = YES;
//    
//    // 设置刷新控件
//    self.collectionView.mj_header = header;
//}

//- (void)showMenu {
//    [self.collectionView.mj_header endRefreshing];
//    [self.menu show];
//}

#pragma mark - Private Cell的动画效果

- (void)prepareVisibleCellsForAnimation {
    
    for (int i = 0; i < [self.collectionView.visibleCells count]; i++) {
        CLMediaCollectionCell * cell = (CLMediaCollectionCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        cell.frame = CGRectMake(CGRectGetMinX(cell.frame)-CGRectGetWidth(self.collectionView.bounds), cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
        cell.alpha = 0.f;
    }
    
//    NSArray *indexArr = [self.collectionView indexPathsForVisibleItems];
//    NSIndexPath *topIndexPath = [indexArr firstObject];
//    NSIndexPath *bottomIndexPath = [indexArr lastObject];
//    
//    for (NSInteger i = topIndexPath.row; i < bottomIndexPath.row+1; i++) {
//        CLMediaCollectionCell * cell = (CLMediaCollectionCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//
//        cell.frame = CGRectMake(-CGRectGetWidth(cell.bounds), cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
//        cell.alpha = 0.f;
//    }
}

- (void)animateVisibleCells {
    
    
    for (int i = 0; i < [self.collectionView.visibleCells count]; i++) {
        CLMediaCollectionCell * cell = (CLMediaCollectionCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        cell.alpha = 1.f;
        [UIView animateWithDuration:0.15f
                              delay:i/3 * 0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.frame = CGRectMake(CGRectGetMinX(cell.frame)+CGRectGetWidth(self.collectionView.bounds), cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
                         }
                         completion:nil];
    }
    
//    NSArray *indexArr = [self.collectionView indexPathsForVisibleItems];
//    NSIndexPath *topIndexPath = [indexArr firstObject];
//    NSIndexPath *bottomIndexPath = [indexArr lastObject];
//    
//    for (NSInteger i = topIndexPath.row; i < bottomIndexPath.row+1; i++) {
//        CLMediaCollectionCell * cell = (CLMediaCollectionCell *) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//        
//        cell.alpha = 1.f;
//        [UIView animateWithDuration:0.2f
//                              delay:(i-topIndexPath.row) * 0.2
//                            options:UIViewAnimationOptionCurveEaseOut
//                         animations:^{
//                             cell.frame = CGRectMake(0.f, cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
//                         }
//                         completion:nil];
//    }
}

- (void) update {

    self.allMedia = nil;
    self.photos = nil;
    self.dataList = nil;
    
    [self allMedia];
    [self photos];
    [self dataList];
        
//    self.menu.cellBackgroundColor = kAppThemeColor;

    [self.collectionView reloadData];
    
//    self.mediaButton.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//    self.menu.cellBackgroundColor = kAppThemeColor;
}

- (void) update:(NSNotification *)noti {
    
    if (noti.object == self) {  //如果是自己发出的更新通知,则不刷新.
        return;
    }
    
    [self update];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.mediaButton.hidden = NO;
    [self.navigationController setToolbarHidden:YES];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
////    self.mediaButton.hidden = YES;
//    [self.menu hide];
//
//}

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

- (IBAction)toggleAddView {
    
    [CLNewEntryTool addNewEntryWithEntryMode:kNewEntryModeMedia inViewController:self listType:kListTypeAll];
}

@end
