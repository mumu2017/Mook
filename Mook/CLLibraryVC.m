//
//  CLLibraryVC.m
//  Mook
//
//  Created by 陈林 on 16/4/4.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLLibraryVC.h"
#import "CLDataSaveTool.h"
#import "CLLibraryCell.h"
#import "CLTagListVC.h"
#import "CLListVC.h"

@interface CLLibraryVC ()

@property (nonatomic, strong) NSMutableArray *ideaObjModelList;
@property (nonatomic, strong) NSMutableArray *showModelList;
@property (nonatomic, strong) NSMutableArray *routineModelList;
@property (nonatomic, strong) NSMutableArray *sleightObjModelList;
@property (nonatomic, strong) NSMutableArray *propObjModelList;
@property (nonatomic, strong) NSMutableArray *linesObjModelList;
@property (nonatomic, strong) NSMutableArray *allTags;

@property (nonatomic, assign) EditingContentType editingContentType;

@end

@implementation CLLibraryVC

static NSString * const reuseIdentifier = @"Cell";


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

- (NSMutableArray *)allTags {
    if (!_allTags) _allTags = kDataListTagAll;
    return _allTags;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"CLLibraryCell" bundle: nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateDataNotification
                                               object:nil];
}

// 不知道为什么, 只能通过willAppear时刷新collectionView的方式来解决删除数据不更新记录数量的bug
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.navigationController.hidesBarsOnSwipe = YES;

    [self.collectionView reloadData];
}
//
//- (void)viewWillDisappear:(BOOL)animated {
//
////    self.navigationController.hidesBarsOnSwipe = NO;
////    self.navigationController.navigationBar.hidden = NO;
//
//    [super viewWillDisappear:animated];
//}

- (void) update:(NSNotification *)noti {
    
    if (noti.object == self) {  //如果是自己发出的更新通知,则不刷新.
        return;
    }

    [self.collectionView reloadData];
}

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CLLibraryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *iconName, *count, *title;
    
    switch (indexPath.row) {
            
        case 0:
            title = NSLocalizedString(@"想法", nil);
            count = [NSString stringWithFormat:@"%ld", (unsigned long)self.ideaObjModelList.count];
            iconName = @"idea.jpg";
            break;
            
        case 1:
            title = NSLocalizedString(@"演出", nil);
            count = [NSString stringWithFormat:@"%ld", (unsigned long)self.showModelList.count];
            iconName = @"show.jpg";
            break;
            
        case 2:
            title = NSLocalizedString(@"流程", nil);
            count = [NSString stringWithFormat:@"%ld", (unsigned long)self.routineModelList.count];
            iconName = @"routine.jpg";
            break;
            
        case 3:
            title = NSLocalizedString(@"技巧", nil);
            count = [NSString stringWithFormat:@"%ld", (unsigned long)self.sleightObjModelList.count];
            iconName = @"sleight.jpg";
            break;
            
        case 4:
            title = NSLocalizedString(@"道具", nil);
            count = [NSString stringWithFormat:@"%ld", (unsigned long)self.propObjModelList.count];
            iconName = @"prop.jpg";
            break;
            
        case 5:
            title = NSLocalizedString(@"台词", nil);
            count = [NSString stringWithFormat:@"%ld", (unsigned long)self.linesObjModelList.count];
            iconName = @"lines.jpg";
            break;

        default:
            break;
    }
    
//    cell.coverView.backgroundColor = kAppThemeColor;
    cell.titleView.backgroundColor = kAppThemeColor;
    cell.titleLabel.text = title;
    cell.contentLabel.text = count;
    cell.imageView.image = [UIImage imageNamed:iconName];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width-15)/2, (self.view.frame.size.height-20)/3);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5; // This is the minimum inter item spacing, can be more
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self performSegueWithIdentifier:kSegueHomeToList sender:indexPath];
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10; // This is the minimum inter item spacing, can be more
//}

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
- (IBAction)goToTags:(id)sender {
    
    [self performSegueWithIdentifier:kSeguekHomeToTagList sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id destVC = [segue destinationViewController];
    UIViewController *vc = (UIViewController *)destVC;
    vc.hidesBottomBarWhenPushed = YES;
    
    if ([destVC isKindOfClass:[CLListVC class]]) {
        
        CLListVC *vc = (CLListVC *)destVC;
        
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            
            switch (indexPath.row) {
                    
                case 0:
                    vc.listType = kListTypeIdea;
                    vc.title = kDefaultTitleIdea;
                    
                    break;
                    
                case 1:
                    vc.listType = kListTypeShow;
                    vc.title = kDefaultTitleShow;
                    
                    break;
                    
                case 2:
                    vc.listType = kListTypeRoutine;
                    vc.title = kDefaultTitleRoutine;
                    
                    break;
                    
                case 3:
                    vc.listType = kListTypeSleight;
                    vc.title = kDefaultTitleSleight;
                    
                    break;
                    
                case 4:
                    vc.listType = kListTypeProp;
                    vc.title = kDefaultTitleProp;
                    
                    break;
                    
                case 5:
                    vc.listType = kListTypeLines;
                    vc.title = kDefaultTitleLines;
                    
                    break;
                    
                default:
                    break;
            }
        }
        
    } else if ([destVC isKindOfClass:[CLTagListVC class]]) {
//        CLTagListVC *vc = (CLTagListVC *)destVC;
        
    }
}

@end
