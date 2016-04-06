//
//  CLPropChooseVC.m
//  Mook
//
//  Created by 陈林 on 16/4/6.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLPropChooseVC.h"
#import "CLPropObjModel.h"

#import "CLListTextCell.h"
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListTextCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListTextCellID];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.propObjModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *iconName, *title;
    UIImage *image;
    NSAttributedString *content;
    
    CLPropObjModel *model = self.propObjModelList[indexPath.row];
    image = [model getThumbnail];
    iconName = kIconNameProp;
    title = [model getTitle];
    content = [model getContent];
    
    if (image != nil) { // 如果返回图片名称,则表示模型中有图片或多媒体
        CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
        cell.iconView.image = image;
        cell.iconName = iconName;
        [cell setTitle:title content:content];
        
        return cell;
        
    } else {
        CLListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kListTextCellID forIndexPath:indexPath];
        cell.iconName = iconName;
        [cell setTitle:title content:content];
        
        return cell;
    }
    
    return nil;
    
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
