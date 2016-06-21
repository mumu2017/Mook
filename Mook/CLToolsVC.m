//
//  CLToolsVC.m
//  Mook
//
//  Created by 陈林 on 16/6/15.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLToolsVC.h"

#import "CLWebVC.h"
#import "CLDeckVC.h"
#import "CLFullStackVC.h"

@interface CLToolsVC ()

{
//    TOWebViewController *_webVC;
}


@end

@implementation CLToolsVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"工具";
    self.tableView.rowHeight = 50;
    self.tableView.tableFooterView = [UIView new];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"WebSites";

            break;
        case 1:
            cell.textLabel.text = @"Stack";

            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            CLWebVC *webVC = [[CLWebVC alloc] init];
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
        case 1:
        {
//            CLDeckVC *deckVC = [[CLDeckVC alloc] init];
            CLFullStackVC *deckVC = [[CLFullStackVC alloc] init];
            deckVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:deckVC animated:YES];
            break;
        }
        default:
            break;
    }

    

}

@end
