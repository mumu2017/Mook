//
//  CLRoutineChooseVC.m
//  Mook
//
//  Created by 陈林 on 16/3/31.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLRoutineChooseVC.h"
#import "CLRoutineModel.h"

#import "CLListTextCell.h"
#import "CLListImageCell.h"

#import "CLTableBackView.h"

@interface CLRoutineChooseVC ()

@property (nonatomic, strong) NSMutableArray *routineModelList;

@property (nonatomic, strong) NSMutableArray *pickedRoutines;

@property (nonatomic, strong) CLTableBackView *tableBackView;

@end

@implementation CLRoutineChooseVC

- (NSMutableArray *)routineModelList {
    if (!_routineModelList)  _routineModelList = kDataListRoutine;
    return _routineModelList;
}

- (NSMutableArray *)pickedRoutines {
    if (!_pickedRoutines) {
        _pickedRoutines = [NSMutableArray array];
    }
    return _pickedRoutines;
}

#pragma mark - 背景view懒加载
- (CLTableBackView *)tableBackView {
    if (!_tableBackView) {
        _tableBackView = [CLTableBackView tableBackView];
    }
    return _tableBackView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelection = YES;
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishPickRoutines)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
    self.tableView.backgroundView = self.tableBackView;
    self.tableView.rowHeight = kListCellHeight;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListImageCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListTextCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListTextCellID];
}

- (void) finishPickRoutines {
    if ([self.delegate respondsToSelector:@selector(routineChooseVC:didPickRoutines:)]) {
        [self.delegate routineChooseVC:self didPickRoutines:self.pickedRoutines];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.routineModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *iconName, *title;
    UIImage *image;
    NSAttributedString *content;
    
    CLRoutineModel *model = self.routineModelList[indexPath.row];
    image = [model getThumbnail];
    iconName = kIconNameRoutine;
    title = [model getTitle];
    content = [model getContent];

    if (image != nil) { // 如果返回图片名称,则表示模型中有图片或多媒体
        CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
        cell.iconView.image = image;
        cell.iconName = iconName;
        [cell setTitle:title content:content];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if (!cell.isSelected) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.tintColor = kTintColor;
        return cell;
        
    } else {
        CLListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kListTextCellID forIndexPath:indexPath];
        cell.iconName = iconName;
        [cell setTitle:title content:content];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if (!cell.isSelected) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.tintColor = kTintColor;

        return cell;
    }
    
    return nil;
    
}

#pragma mark 选中cell跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = kMenuBackgroundColor;

    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 1.0;
    cell.layer.cornerRadius = 0.0;
    cell.layer.masksToBounds = YES;
    
    CLRoutineModel *model = self.routineModelList[indexPath.row];
    if ([self.pickedRoutines containsObject:model] == NO) {
        [self.pickedRoutines addObject:model];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = nil;
    cell.layer.borderColor = nil;
    cell.layer.borderWidth = 0.0;
    cell.layer.cornerRadius = 0.0;
    cell.layer.masksToBounds = YES;
    
    CLRoutineModel *model = self.routineModelList[indexPath.row];
    if ([self.pickedRoutines containsObject:model] == YES) {
        [self.pickedRoutines removeObject:model];
    }
}

@end
