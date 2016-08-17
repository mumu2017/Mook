//
//  CLRoutineChooseVC.m
//  Mook
//
//  Created by 陈林 on 16/3/31.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLRoutineChooseVC.h"
#import "CLRoutineModel.h"

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
    
    [self.tableView setEditing:YES];

    self.tableView.allowsMultipleSelection = YES;
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishPickRoutines)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
    self.tableView.backgroundView = self.tableBackView;
    self.tableView.rowHeight = kListCellHeight;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListImageCellID];
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

    NSInteger number = self.routineModelList.count;
    self.tableBackView.hidden = !(number == 0);
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
    CLRoutineModel *model = self.routineModelList[indexPath.row];
    [cell setModel:model utilityButtons:nil delegate:nil];
    cell.tintColor = kAppThemeColor;
    
    return cell;
    
}

#pragma mark 选中cell跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLRoutineModel *model = self.routineModelList[indexPath.row];
    if ([self.pickedRoutines containsObject:model] == NO) {
        [self.pickedRoutines addObject:model];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLRoutineModel *model = self.routineModelList[indexPath.row];
    if ([self.pickedRoutines containsObject:model] == YES) {
        [self.pickedRoutines removeObject:model];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

@end
