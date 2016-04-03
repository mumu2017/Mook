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
#import "MWPhotoBrowser.h"

#import "CLContentVC.h"

#import "CLShowModel.h"
#import "CLIdeaObjModel.h"
#import "CLRoutineModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"

@interface CLMediaVC ()<MWPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray *allMedia;
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end

@implementation CLMediaVC

- (NSMutableArray *)allMedia {
    if (!_allMedia) {
        _allMedia = [CLDataSaveTool allMedia];
    }
    return _allMedia;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
        
        NSString *type, *modelName;
        for (NSDictionary *dict in self.allMedia) {
            type = [dict objectForKey:@"model_type"];
            modelName = [dict objectForKey:@"model_time_stamp"];
            if ([type isEqualToString:kTypeIdea]) {
                CLIdeaObjModel *model = [CLDataSaveTool ideaByName:modelName];
                [_dataList addObject:model];

            } else if ([type isEqualToString:kTypeRoutine]) {
                CLRoutineModel *model = [CLDataSaveTool routineByName:modelName];
                [_dataList addObject:model];

            } else if ([type isEqualToString:kTypeSleight]) {
                CLSleightObjModel *model = [CLDataSaveTool sleightByName:modelName];
                [_dataList addObject:model];

            } else if ([type isEqualToString:kTypeProp]) {
                CLPropObjModel *model = [CLDataSaveTool propByName:modelName];
                [_dataList addObject:model];

            } else if ([type isEqualToString:kTypeLines]) {
                CLLinesObjModel *model = [CLDataSaveTool linesByName:modelName];
                [_dataList addObject:model];

            }
            
        }
    }
    return _dataList;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
        NSString *type, *name, *content, *modelName;
        MWPhoto *photo;
        
        for (NSDictionary *dict in self.allMedia) {
            name = [dict objectForKey:@"name"];
            type = [dict objectForKey:@"type"];
            modelName = [dict objectForKey:@"model_time_stamp"];
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
                NSLog(@"111111");
            }
        }
    }
    return _photos;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[CLMediaCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CLMediaCollectionCell" bundle: nil] forCellWithReuseIdentifier:reuseIdentifier];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateDataNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

- (void) update:(NSNotification *)noti {
    
    if (noti.object == self) {  //如果是自己发出的更新通知,则不刷新.
        return;
    }
    
    self.allMedia = nil;
    self.photos = nil;
    self.dataList = nil;
    [self.collectionView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.allMedia.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CLMediaCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dict = self.allMedia[indexPath.row];
    cell.name = [dict objectForKey:@"name"];
    
    NSString *type, *modelName, *title, *content;

        type = [dict objectForKey:@"model_type"];
        modelName = [dict objectForKey:@"model_time_stamp"];
        if ([type isEqualToString:kTypeIdea]) {
            CLIdeaObjModel *model = [CLDataSaveTool ideaByName:modelName];
            title = kDefaultTitleIdea;
            content = [NSString getDateString:model.date];
            
        } else if ([type isEqualToString:kTypeRoutine]) {
            CLRoutineModel *model = [CLDataSaveTool routineByName:modelName];
            title = kDefaultTitleRoutine;
            content = [NSString getDateString:model.date];
        } else if ([type isEqualToString:kTypeSleight]) {
            CLSleightObjModel *model = [CLDataSaveTool sleightByName:modelName];
            title = kDefaultTitleSleight;
            content = [NSString getDateString:model.date];
        } else if ([type isEqualToString:kTypeProp]) {
            CLPropObjModel *model = [CLDataSaveTool propByName:modelName];
            title = kDefaultTitleProp;
            content = [NSString getDateString:model.date];
        } else if ([type isEqualToString:kTypeLines]) {
            CLLinesObjModel *model = [CLDataSaveTool linesByName:modelName];
            title = kDefaultTitleLines;
            content = [NSString getDateString:model.date];
        }
    
    cell.titleLabel.text = title;
    cell.contentLabel.text = content;
    // Configure the cell
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 150);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
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
    NSLog(@"ACTION!");
    
    id modelUnknown = self.dataList[index];
    
    [self performSegueWithIdentifier:kSegueMediaToContent sender:modelUnknown];
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)modelUnknown {
    
    UIViewController *destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[CLContentVC class]]) {
        CLContentVC *vc = (CLContentVC *)destVC;
        
        if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
            CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
            vc.contentType = kContentTypeIdea;
            vc.ideaObjModel = model;
            vc.date = model.date;
            
        } else if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
            //                        CLShowModel *model = (CLShowModel *)modelUnknown;
            //                imageName = [model getThumbnail];
            //                title = [model getTitle];
            //                content = [model getContent];
        } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
            CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
            vc.contentType = kContentTypeRoutine;
            vc.routineModel = model;
            vc.date = model.date;
            
        } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
            CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
            vc.contentType = kContentTypeSleight;
            vc.sleightObjModel = model;
            vc.date = model.date;
            
        } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
            CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
            vc.contentType = kContentTypeProp;
            vc.propObjModel = model;
            vc.date = model.date;
            
        } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
            CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
            vc.contentType = kContentTypeLines;
            vc.linesObjModel = model;
            vc.date = model.date;
        }
    }
}

@end
