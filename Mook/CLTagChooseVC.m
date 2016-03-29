//
//  CLTagChooseVC.m
//  Mook
//
//  Created by 陈林 on 16/1/2.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import "CLTagChooseVC.h"

#import "CLTableBackView.h"

@interface CLTagChooseVC ()

@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, assign) BOOL tagListChanged;

@property (nonatomic, strong) CLTableBackView *tableBackView;


@end

@implementation CLTagChooseVC

#pragma mrak - 流程模型数据懒加载

- (NSMutableArray *)tagChooseList {
    
    if (!_tagChooseList) {
    switch (self.editingContentType) {
        case kEditingContentTypeRoutine:
            _tagChooseList = kDataListTagRoutine;
            
            break;
        case kEditingContentTypeIdea:
   
            _tagChooseList = kDataListTagIdea;
            break;
        case kEditingContentTypeSleight:
            _tagChooseList = kDataListTagSleight;
            
            break;
            
        case kEditingContentTypeProp:
            _tagChooseList = kDataListTagProp;
            
            break;
            
        case kEditingContentTypeLines:
            _tagChooseList = kDataListTagLines;
            
            break;
            
        default:
            break;
        }
    }

    return _tagChooseList;
}

- (CLTableBackView *)tableBackView {
    if (!_tableBackView) {
        _tableBackView = [CLTableBackView tableBackView];
    }
    return _tableBackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsMultipleSelection = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTagSelection)];
  
    self.tableView.backgroundView = self.tableBackView;
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)cancelTagSelection {
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"cancelTagSelection" object:nil]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.tableBackView.hidden = ([self.tagChooseList count] != 0);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.tagChooseList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTagCell forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = kCellBgColor;
    cell.accessoryType = UITableViewCellAccessoryNone;

    cell.textLabel.text = self.tagChooseList[indexPath.row];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *titleArr = @[@"灵感", @"流程", @"技巧", @"道具", @"梗"];
    
    // editingContentType从0-4与数组一一对应,所以可以用下标取title;
    return titleArr[self.editingContentType];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(tagChooseVC:didSelectTag:)]) {
        [self.delegate tagChooseVC:self didSelectTag:self.tagChooseList[indexPath.row]];
    }
}

@end
