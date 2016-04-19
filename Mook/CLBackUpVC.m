//
//  CLBackUpVC.m
//  Mook
//
//  Created by 陈林 on 16/4/18.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLBackUpVC.h"
#import "ZipArchive.h"
#import "FCFileManager.h"

@interface CLBackUpVC ()<UIDocumentInteractionControllerDelegate>


@property (nonatomic, assign) BOOL isCreatBackUp;
@property (nonatomic, assign) BOOL backUpExists;


@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation CLBackUpVC

- (BOOL)backUpExists {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[NSString backUpPath]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        number = 1;
    } else if (section == 2) {
        
        if (self.backUpExists) {
            number = 1;
        } else {
            number = 0;
        }
    }
    
    return number;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        NSString *size = [FCFileManager sizeFormattedOfItemAtPath:[NSString backUpPath]];
        cell.textLabel.text = @"backup.mook";
        cell.detailTextLabel.text = size;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        [self creatBackUp];

    } else if (indexPath.section == 2 && indexPath.row == 0) {
        
        [self dealWithBackUp];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)dealWithBackUp {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* restore = [UIAlertAction actionWithTitle:NSLocalizedString(@"恢复备份", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self restoreBackUp];

    }];
    
    UIAlertAction* export = [UIAlertAction actionWithTitle:NSLocalizedString(@"发送备份", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self exportBackUp];

        
    }];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除备份", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteBackUp];

    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:restore];
    [alert addAction:export];
    [alert addAction:delete];

    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)creatBackUp {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"生成备份", nil) message:NSLocalizedString(@"提示: 生成备份文件后, 请尽快将备份文件导出保存. 为了节省您的存储空间, Mook推荐您在导出备份后删除备份文件. 确定要生成备份文件吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* loadBackUp = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIWindow *window = [[UIApplication sharedApplication] delegate].window;
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
            [window addSubview:HUD];
            
            HUD.labelText = NSLocalizedString(@"正在生成备份文件", nil);
            
            [HUD showAnimated:YES whileExecutingBlock:^{
                
                // Create zip
                NSString *backUpName = [NSString backUpPath];
                NSString *mookPath = [NSString mookPath];
                self.isCreatBackUp = [SSZipArchive createZipFileAtPath:backUpName withContentsOfDirectory:mookPath keepParentDirectory:YES withPassword:kZipPassword];
                
            } onQueue:dispatch_get_global_queue(0, 0) completionBlock:^{
                
                if (self.isCreatBackUp) {
                    [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"已成功生成备份文件", nil) hideAfterDelay:1.0];
                    [self.tableView reloadData]; // 生成后刷新表格, 显示"恢复备份"
                } else {
                    [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"生成备份文件失败", nil) hideAfterDelay:1.0];
                    
                }
                
            }];
            
            
        });
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:loadBackUp];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)restoreBackUp {
    
    // 恢复备份
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"恢复备份", nil) message:NSLocalizedString(@"注意: 恢复备份后, 您当前的Mook数据将被永久性地替换为备份数据. 确定要恢复备份吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* loadBackUp = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIWindow *window = [[UIApplication sharedApplication] delegate].window;
            
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
            HUD.labelText = NSLocalizedString(@"正在恢复备份", nil);
            [window addSubview:HUD];
            [HUD setMode:MBProgressHUDModeDeterminate];   //圆盘的扇形进度显示
            HUD.taskInProgress = YES;
            [HUD show:YES];
            
            // Unzip
            NSString *backUpName = [NSString backUpPath];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *libraryPath = [paths objectAtIndex:0];
            
            [SSZipArchive unzipFileAtPath:backUpName toDestination:libraryPath overwrite:YES password:kZipPassword progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                
                CGFloat progress = entryNumber / total;
                HUD.progress = progress;
                
            } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"已成功恢复备份文件", nil) hideAfterDelay:1.0];
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] reloadData];
                    
                } else {
                    [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"恢复备份文件失败", nil) hideAfterDelay:1.0];
                    
                }
                
            }];
        });
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:loadBackUp];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)deleteBackUp {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"删除备份文件", nil) message:NSLocalizedString(@"确定要删除备份文件吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* loadBackUp = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            NSFileManager* fileManager=[NSFileManager defaultManager];
            NSString *backUpPath = [NSString backUpPath];
            
            if (self.backUpExists) {
                BOOL fileDeleted= [fileManager removeItemAtPath:backUpPath error:nil];
                
                NSString *title;
                if (fileDeleted) {
                    
                    title = NSLocalizedString(@"已删除备份文件", nil);
                    [self.tableView reloadData];
                    
                } else {
                    title = NSLocalizedString(@"删除备份文件失败", nil);
                }
                
                [MBProgressHUD showGlobalProgressHUDWithTitle:title hideAfterDelay:1.0];
                
            }
        });
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:loadBackUp];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)exportBackUp {
    
    NSURL *dataUrl;
    dataUrl = [NSURL fileURLWithPath:[NSString backUpPath]];
    
    CGRect navRect = self.view.frame;
    self.documentInteractionController =[UIDocumentInteractionController interactionControllerWithURL:dataUrl];
    self.documentInteractionController.delegate = self;
    
    [self.documentInteractionController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
}


#pragma mark - UIDocumentInteractionControllerDelegate

//===================================================================
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}

@end
