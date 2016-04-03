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

#import "CLOneLabelDisplayCell.h"
#import "CLOneLabelImageDisplayCell.h"
#import "CLNewShowVC.h"

#import "CLRoutineModel.h"
#import "CLInfoModel.h"
#import "CLEffectModel.h"

@interface CLShowVC ()<SWTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *routineModelList;


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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"演出";
    self.tableView.estimatedRowHeight = 44;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelection = NO;

    self.tableView.backgroundColor = [UIColor whiteColor];
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

- (void) update {
    // 重新刷新所有数据
    [self.tableView reloadData];
//    // 设置图片数组为nil, 这样在懒加载的时候就可以重新刷新图片
//    self.photos = nil;
//    self.thumbs = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number;
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
            CLOneLabelDisplayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelDisplayCell forIndexPath:indexPath];
            
            NSString *title;
            if (self.showModel.name.length > 0) {
                title = self.showModel.name;
            } else {
                title = @"请编辑标题";
            }
            
            NSAttributedString *titleString = [NSString titleString:title withDate:self.date];

            cell.contentLabel.attributedText = titleString;
            cell.contentLabel.textAlignment = NSTextAlignmentCenter;
            
            return cell;
        }
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            return cell;
        }
        case 2:
        {
            if (self.showModel.effectModel.isWithVideo) {
                
                CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
                
                cell.contentLabel.attributedText = [self.showModel.effectModel.effect styledString];
                [cell.imageButton addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
                cell.imageButton.tag = 0; // effectModel肯定是第一张图片或视频,所以作为图片数组中的Index,tag = 0;
                [cell setImageWithVideoName:self.showModel.effectModel.video];
                
                return cell;
            } else if (self.showModel.effectModel.isWithImage) {
                
                CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
                
                cell.contentLabel.attributedText = [self.showModel.effectModel.effect styledString];
                [cell.imageButton addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
                cell.imageButton.tag = 0;
                [cell setImageWithName:self.showModel.effectModel.image];
                
                return cell;
                
            } else {
                CLOneLabelDisplayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelDisplayCell forIndexPath:indexPath];
                
                cell.contentLabel.attributedText = [self.showModel.effectModel.effect styledString];
                
                return cell;
            }

            break;
        }
        case 3:
        {
            CLRoutineModel *model = self.routineModelList[indexPath.row];
            CLEffectModel *effectModel = model.effectModel;
            
            if (effectModel.isWithVideo) {
                
                CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
                
                cell.contentLabel.attributedText = [effectModel.effect styledString];
                [cell.imageButton addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
                cell.imageButton.tag = 0; // effectModel肯定是第一张图片或视频,所以作为图片数组中的Index,tag = 0;
                [cell setImageWithVideoName:effectModel.video];
                
                cell.tintColor = kMenuBackgroundColor;
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
            
                return cell;
            } else if (effectModel.isWithImage) {
                
                CLOneLabelImageDisplayCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelImageDisplayCell];
                
                cell.contentLabel.attributedText = [effectModel.effect styledString];
                [cell.imageButton addTarget:self action:@selector(showPhotoBrowser:) forControlEvents:UIControlEventTouchUpInside];
                cell.imageButton.tag = 0;
                [cell setImageWithName:effectModel.image];
                
                cell.tintColor = kMenuBackgroundColor;
                cell.accessoryType = UITableViewCellAccessoryDetailButton;

                return cell;
                
            } else {
                CLOneLabelDisplayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kOneLabelDisplayCell forIndexPath:indexPath];
                
                cell.contentLabel.attributedText = [effectModel.effect styledString];
                
                cell.tintColor = kMenuBackgroundColor;
                cell.accessoryType = UITableViewCellAccessoryDetailButton;

                return cell;
            }

            break;
        }
        default:
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    // show full routine
    [self performSegueWithIdentifier:kShowToRoutineSegue sender:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
        
    } else {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kLabelHeight)];
        view.backgroundColor = [UIColor lightGrayColor];
        view.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
        view.layer.borderWidth = 0.5;
        
        view.alpha = 0.95;
        
        UILabel *label = [[UILabel alloc] init];
        [view addSubview:label];
        
        label.frame = CGRectMake(kPadding, 0, kContentW, kLabelHeight);
        label.textAlignment =NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = kFontSys12;
        
        NSString *sectionTitle;
        if (section == 0) {
            sectionTitle = @"演出名称";
        } else if (section == 1) {
            sectionTitle = @"演出信息";
        } else if (section == 2) {
            sectionTitle = @"演出说明";
        } else if (section == 3) {
            sectionTitle = @"演出流程";
        }
        
        label.text = sectionTitle;
        
        return view;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:section] == 0) {
        return 0;
    }
    
    return kLabelHeight;
}

#pragma mark - SWTableViewDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id destVC = [segue destinationViewController];
    if ([destVC isKindOfClass:[CLContentVC class]]) {
        CLContentVC *vc = (CLContentVC *)destVC;

        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *path = (NSIndexPath *)sender;
            CLRoutineModel *model = self.routineModelList[path.row];
            vc.contentType = kContentTypeRoutine;
            vc.routineModel = model;
            vc.date = model.date;
        }
    } else if ([destVC isKindOfClass:[CLNewShowVC class]]) {
        CLNewShowVC *vc = (CLNewShowVC *)destVC;
        vc.showModel = self.showModel;
    }
}

@end
