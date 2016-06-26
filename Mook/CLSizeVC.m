//
//  CLSizeVC.m
//  Mook
//
//  Created by 陈林 on 16/5/10.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLSizeVC.h"
#import "CLDataSizeTool.h"
#import "CLSizeListVC.h"

@interface CLSizeVC ()

@end

@implementation CLSizeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"储存空间占用", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger number = 0;
    
    if (section == 0) {
        number = 1;
    } else if (section == 1) {
        number = 6;
    } else if (section == 2) {
        number = 2;
    }
    
    return number;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.textLabel.text = NSLocalizedString(@"总共占用", nil);
                cell.detailTextLabel.text = [CLDataSizeTool totalSize];
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"想法", nil);
                    cell.detailTextLabel.text = [CLDataSizeTool sizeOfAllIdeas];
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"演出", nil);
                    cell.detailTextLabel.text = [CLDataSizeTool sizeOfAllShows];
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"流程", nil);
                    cell.detailTextLabel.text = [CLDataSizeTool sizeOfAllRoutines];
                    break;
                case 3:
                    cell.textLabel.text = NSLocalizedString(@"技巧", nil);
                    cell.detailTextLabel.text = [CLDataSizeTool sizeOfAllSleights];
                    break;
                case 4:
                    cell.textLabel.text = NSLocalizedString(@"道具", nil);
                    cell.detailTextLabel.text = [CLDataSizeTool sizeOfAllProps];
                    break;
                case 5:
                    cell.textLabel.text = NSLocalizedString(@"台词", nil);
                    cell.detailTextLabel.text = [CLDataSizeTool sizeOfAllLines];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                cell.textLabel.text = NSLocalizedString(@"备份文件", nil);
                cell.detailTextLabel.text = [CLDataSizeTool sizeOfBackUp];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = NSLocalizedString(@"缓存与临时文件", nil);
                cell.detailTextLabel.text = [CLDataSizeTool sizeOfCacheAndTemporaryData];
            }
            break;
            
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if (indexPath.row == 5) { // 台词不跳转,因为没有多媒体
            return;
        } else {
            [self performSegueWithIdentifier:kSizeListSegue sender:indexPath];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    id destVC = [segue destinationViewController];
    if ([destVC isKindOfClass:[CLSizeListVC class]]) {
        CLSizeListVC *vc = (CLSizeListVC *)destVC;
        
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            switch (indexPath.row) {
                case 0:
                    vc.listType = kListTypeIdea;
                    break;
                    
                case 1:
                    vc.listType = kListTypeShow;
                    break;
                    
                case 2:
                    vc.listType = kListTypeRoutine;

                    break;
                    
                    
                case 3:
                    vc.listType = kListTypeSleight;

                    break;
                    
                case 4:
                    vc.listType = kListTypeProp;
                    break;
                    
                    
                default:
                    break;
            }
        }
    }
}


@end
