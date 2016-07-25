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
        number = 3;
    }
    
    return number;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.detailTextLabel.text = NSLocalizedString(@"计算中...", nil);

    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.textLabel.text = NSLocalizedString(@"总共占用", nil);
                
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    NSString *sizeString = [CLDataSizeTool totalSize]; // 每次重新打开页面就重新计算一次文件尺寸
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                        
                    });
                });
            }
            
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = NSLocalizedString(@"想法", nil);
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        NSString *sizeString = [CLDataSizeTool sizeOfAllIdeas]; // 每次重新打开页面就重新计算一次文件尺寸
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                            
                        });
                    });

                    break;
                }
                case 1:
                {
                    cell.textLabel.text = NSLocalizedString(@"演出", nil);
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        NSString *sizeString = [CLDataSizeTool sizeOfAllShows]; // 每次重新打开页面就重新计算一次文件尺寸
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                            
                        });
                    });

                    break;
                }
                case 2:
                {
                    cell.textLabel.text = NSLocalizedString(@"流程", nil);
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        NSString *sizeString = [CLDataSizeTool sizeOfAllRoutines]; // 每次重新打开页面就重新计算一次文件尺寸
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                            
                        });
                    });
                    break;
                }
                case 3:
                {
                    cell.textLabel.text = NSLocalizedString(@"技巧", nil);
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        NSString *sizeString = [CLDataSizeTool sizeOfAllSleights]; // 每次重新打开页面就重新计算一次文件尺寸
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                            
                        });
                    });

                    break;
                }
                case 4:
                {
                    cell.textLabel.text = NSLocalizedString(@"道具", nil);
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        NSString *sizeString = [CLDataSizeTool sizeOfAllProps]; // 每次重新打开页面就重新计算一次文件尺寸
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                            
                        });
                    });

                    break;
                }
                case 5:
                {
                    cell.textLabel.text = NSLocalizedString(@"台词", nil);
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        NSString *sizeString = [CLDataSizeTool sizeOfAllLines]; // 每次重新打开页面就重新计算一次文件尺寸
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                            
                        });
                    });

                    break;
            }
                default:
                    break;
            }
            break;
        }
        case 2:
            if (indexPath.row == 0) {
                cell.textLabel.text = NSLocalizedString(@"备份文件", nil);
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    NSString *sizeString = [CLDataSizeTool sizeOfBackUp]; // 每次重新打开页面就重新计算一次文件尺寸
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                        
                    });
                });

            } else if (indexPath.row == 1) {
                cell.textLabel.text = NSLocalizedString(@"缓存与临时文件", nil);
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    NSString *sizeString = [CLDataSizeTool sizeOfCacheAndTemporaryData]; // 每次重新打开页面就重新计算一次文件尺寸
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                        
                    });
                });

            } else if (indexPath.row == 2) {
                cell.textLabel.text = NSLocalizedString(@"网络缓存文件", nil);
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    NSString *sizeString = [CLDataSizeTool sizeOfWebCache]; // 每次重新打开页面就重新计算一次文件尺寸
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                        
                    });
                });
                
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
    
    if (indexPath.section == 2 && indexPath.row == 2) {
        
        [self cleanWebCache];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)cleanWebCache {
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除网络缓存", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        __block BOOL flag;
        
        [MBProgressHUD showAnimated:YES whileExecutingBlockOnGloableQueue:^{
            flag = [CLDataSizeTool cleanWebCache];
        } completionBlock:^{
            if (flag) {
        
                [self.tableView reloadData];
            }

        }];

        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
