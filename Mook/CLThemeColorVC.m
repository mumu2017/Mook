//
//  CLThemeColorVC.m
//  Mook
//
//  Created by 陈林 on 16/5/13.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLThemeColorVC.h"

@interface CLThemeColorVC ()

@end

@implementation CLThemeColorVC

static NSString * const reuseIdentifier = @"colorCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    kThemeColorSet lastColorCode = flatWatermelonColorDark;
    return lastColorCode + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.backgroundColor = [self themeColorWithIndex:indexPath.row];
    
    return cell;
}

- (UIColor *)themeColorWithIndex:(NSInteger)index {
    
    UIColor *themeColor;
    
    kThemeColorSet colorCode = (int)index;
    
    switch (colorCode) {
        case flatBlackColorDark:
            themeColor = [UIColor flatBlackColorDark];
            break;
        case flatBlueColorDark:
            themeColor = [UIColor flatBlueColorDark];
            break;
        case flatForestGreenColorDark:
            themeColor = [UIColor flatForestGreenColorDark];
            break;
        case flatGreenColorDark:
            themeColor = [UIColor flatGreenColorDark];
            break;
        case flatMagentaColorDark:
            themeColor = [UIColor flatMagentaColorDark];
            break;
        case flatMaroonColorDark:
            themeColor = [UIColor flatMaroonColorDark];
            break;
        case flatMintColorDark:
            themeColor = [UIColor flatMintColorDark];
            break;
        case flatNavyBlueColorDark:
            themeColor = [UIColor flatNavyBlueColorDark];
            break;
        case flatOrangeColorDark:
            themeColor = [UIColor flatOrangeColorDark];
            break;
        case flatPinkColorDark:
            themeColor = [UIColor flatPinkColorDark];
            break;
        case flatPlumColorDark:
            themeColor = [UIColor flatPlumColorDark];
            break;
        case flatPurpleColorDark:
            themeColor = [UIColor flatPurpleColorDark];
            break;
        case flatRedColorDark:
            themeColor = [UIColor flatRedColorDark];
            break;
        case flatSkyBlueColorDark:
            themeColor = [UIColor flatSkyBlueColorDark];
            break;
        case flatTealColorDark:
            themeColor = [UIColor flatTealColorDark];
            break;
        case flatWatermelonColorDark:
            themeColor = [UIColor flatWatermelonColorDark];
            break;
        default:
            break;
    }
    
    return themeColor;
}

- (IBAction)cancelColorSelection:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width-3)/4, (self.view.frame.size.width-3)/4);
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
    
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:kThemeColorKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [kAppDelegate setAppUI];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:nil];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

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

@end
