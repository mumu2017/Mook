//
//  CLPropChooseVC.m
//  Mook
//
//  Created by 陈林 on 16/4/6.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLPropChooseVC.h"
#import "CLPropObjModel.h"

#import "CLListImageCell.h"

#import "CLTableBackView.h"

@interface CLPropChooseVC()

@property (nonatomic, strong) NSMutableArray *propObjModelList;

@property (nonatomic, strong) CLTableBackView *tableBackView;

@end

@implementation CLPropChooseVC

- (NSMutableArray *)propObjModelList {
    if (!_propObjModelList)  _propObjModelList = kDataListProp;
    return _propObjModelList;
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
    
    self.title = kDefaultTitleProp;
    self.tableView.backgroundView = self.tableBackView;
    self.tableBackView.hidden = (self.propObjModelList.count != 0);
    
    self.tableView.rowHeight = kListCellHeight;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListImageCellID];

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.propObjModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
    CLPropObjModel *model = self.propObjModelList[indexPath.row];

    [cell setModel:model utilityButtons:nil delegate:nil];
    
    return cell;
    
}

#pragma mark 选中cell跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.delegate respondsToSelector:@selector(propChooseVC:didSelectProp:)]) {
        
        CLPropObjModel *model = self.propObjModelList[indexPath.row];
        
        [self.delegate propChooseVC:self didSelectProp:model];
    }
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"cancelPropSelection" object:nil]];

}

@end
