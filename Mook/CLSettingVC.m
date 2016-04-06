//
//  CLSettingVC.m
//  Mook
//
//  Created by 陈林 on 15/11/20.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLSettingVC.h"
#import "CLPasswordVC.h"
//#import "Objective-Zip.h"
#import "CLDataSaveTool.h"
#import "ZipArchive.h"
#import "MBProgressHUD.h"

#import <MessageUI/MFMailComposeViewController.h>

@interface CLSettingVC ()<MBProgressHUDDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *passwordSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *savePhotoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *saveVideoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *touchIDSwitch;

@property (nonatomic, assign) BOOL isCreatBackUp;
@property (nonatomic, assign) BOOL backUpExists;
@end

@implementation CLSettingVC

- (BOOL)backUpExists {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[NSString backUpPath]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserDefaultsData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPasswordCreated) name:@"newPasswordCreated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPasswordCreation) name:@"cancelPasswordCreation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPasswordChange) name:@"cancelPasswordChange" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)getUserDefaultsData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.passwordSwitch.on = [defaults boolForKey:kUsePasswordKey];
    self.touchIDSwitch.on = [defaults boolForKey:kTouchIDKey];

    self.savePhotoSwitch.on = [defaults boolForKey:kSavePhotoKey];
    self.saveVideoSwitch.on = [defaults boolForKey:kSaveVideoKey];
}

- (void)newPasswordCreated {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelPasswordCreation {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.passwordSwitch.on = NO;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kUsePasswordKey];
    [defaults synchronize];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)cancelPasswordChange {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number = 0;
    
    switch (section) {
        case 0:
            
            if (self.backUpExists) {
                number = 4;
            } else {
                number = 2;
            }
            break;
            
        case 1:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey]) {
                number = 3;
            } else {
                number = 1;
            }
            break;
            
        case 2:
            number = 1;
            break;
            
        case 3:
            number = 2;
            break;
            
        case 4:
            number = 2;
            break;
            
        case 5:
            number = 3;
            break;
            
        default:
            break;
    }
    return number;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:HUD];
            
            HUD.delegate = self;
            HUD.labelText = @"正在生成备份文件";

            [HUD showAnimated:YES whileExecutingBlock:^{
                
                // Create
                NSString *backUpName = [NSString backUpPath];
                NSString *mookPath = [NSString mookPath];
                self.isCreatBackUp = [SSZipArchive createZipFileAtPath:backUpName withContentsOfDirectory:mookPath keepParentDirectory:YES];
                
            } onQueue:dispatch_get_main_queue() completionBlock:^{
                
                if (self.isCreatBackUp) {
                    HUD.labelText = @"已成功生成备份文件";
                    [self.tableView reloadData]; // 生成后刷新表格, 显示"恢复备份"
                } else {
                    HUD.labelText = @"生成备份文件失败";
                }
                // Configure for text only and offset down
                HUD.mode = MBProgressHUDModeText;
                HUD.margin = 10.f;
                HUD.yOffset = 150.f;
                HUD.removeFromSuperViewOnHide = YES;
                [HUD show:YES];
                
                
                [HUD hide:YES afterDelay:1];
            }];
            
        } else if (indexPath.row == 1) {
            
            [self performSegueWithIdentifier:kBackUpInfoSegue sender:nil];
            
        } else if (indexPath.row == 2) { // 如果有第三行则表示备份文件存在,可以恢复

            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            HUD.labelText = @"正在加载恢复备份";
            [self.navigationController.view addSubview:HUD];
            [HUD setMode:MBProgressHUDModeDeterminate];   //圆盘的扇形进度显示
            HUD.taskInProgress = YES;
            [HUD show:YES];
            // Unzip
            NSString *backUpName = [NSString backUpPath];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *libraryPath = [paths objectAtIndex:0];
            
            [SSZipArchive unzipFileAtPath:backUpName toDestination:libraryPath overwrite:YES password:nil progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                
                CGFloat progress = entryNumber / total;
                HUD.progress = progress;
                   //显示
                NSLog(@"%ld / %ld", entryNumber, total);
            } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
                NSLog(@"finish unzipping");

                if (succeeded) {
                    HUD.labelText = @"已成功恢复备份文件";
                    
#warning 关于数据刷新的问题(主页几个VC)
                    //  提醒用户退出应用?
//                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] reloadData];
                    
                    
                } else {
                    HUD.labelText = @"恢复备份文件失败";
                }
                
                // Configure for text only and offset down
                HUD.mode = MBProgressHUDModeText;
                HUD.margin = 10.f;
                HUD.yOffset = 150.f;
                HUD.removeFromSuperViewOnHide = YES;
                [HUD show:YES];
                
                
                [HUD hide:YES afterDelay:1];
            }];

            
        }  else if (indexPath.row == 3) { // 删除备份文件
            
            NSFileManager* fileManager=[NSFileManager defaultManager];
            NSString *backUpPath = [NSString backUpPath];
            
            if (self.backUpExists) {
                BOOL fileDeleted= [fileManager removeItemAtPath:backUpPath error:nil];
                
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.mode = MBProgressHUDModeText;
                HUD.removeFromSuperViewOnHide = YES;
                // Configure for text only and offset down
                HUD.margin = 10.f;
                HUD.yOffset = 150.f;
                HUD.delegate = self;
                
                if (fileDeleted) {
                    
                    HUD.labelText = @"已删除备份文件";
                    [self.tableView reloadData];

                } else {
                    HUD.labelText = @"删除备份文件失败";
                }
                
                [HUD show:YES];
                
                [HUD hide:YES afterDelay:1];
            }
            
        }
    } else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            [self displayMailComposerSheet];
        }
    } else if (indexPath.section == 5) {
        if (indexPath.row == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showIntroView" object:nil];
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[CLPasswordVC class]]) {
        CLPasswordVC *vc = (CLPasswordVC *)destVC;
        vc.hidesBottomBarWhenPushed = YES;
        
        if ([sender isKindOfClass:[UISwitch class]]) {
            vc.isCreatingNewPassword = YES;

        } else {
            vc.isChangingPassword = YES;
        }
        
    }
}


#pragma mark -设置 方法

- (IBAction)passwordSwitchChanged:(UISwitch *)controlSwitch {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setBool:controlSwitch.isOn forKey:kUsePasswordKey];
    
    [defaults synchronize];
    
    if (controlSwitch.isOn) {
        [self performSegueWithIdentifier:kSettingToPasswordSegue sender:self.passwordSwitch];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    
    
}

- (IBAction)touchIDSwitchChanged:(UISwitch *)controlSwitch {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:controlSwitch.isOn forKey:kTouchIDKey];
    
    [defaults synchronize];
}

- (IBAction)savePhotoSwitchChanged:(UISwitch *)controlSwitch {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:controlSwitch.isOn forKey:kSavePhotoKey];
    
    [defaults synchronize];
}

- (IBAction)saveVideoSwitchChanged:(UISwitch *)controlSwitch {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:controlSwitch.isOn forKey:kSaveVideoKey];
    
    [defaults synchronize];
}


#pragma mark - Compose Mail/SMS

// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an email composition interface inside the application.
//  Populates all the Mail fields.
// -------------------------------------------------------------------------------
- (void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Mook feedback"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"chenlin7715@163.com"];
    
    [picker setToRecipients:toRecipients];

    // Fill out the email body text
    NSString *emailBody = @"反馈信息:\n";
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//	mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    HUD.removeFromSuperViewOnHide = YES;
    // Configure for text only and offset down
    HUD.margin = 10.f;
    HUD.yOffset = 150.f;
    HUD.delegate = self;
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            HUD.labelText = @"邮件已取消";

//            HUD.labelText = @"Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
            HUD.labelText = @"邮件已保存";

//            HUD.labelText = @"Mail saved";
            break;
        case MFMailComposeResultSent:
            HUD.labelText = @"邮件已发送";

//            HUD.labelText = @"Mail sent";
            break;
        case MFMailComposeResultFailed:
            HUD.labelText = @"邮件发送失败";

//            HUD.labelText = @"Mail sending failed";
            break;
        default:
            HUD.labelText = @"邮件未能发送";

//            HUD.labelText = @"Mail not sent";
            break;
    }
    [HUD show:YES];
    [HUD hide:YES afterDelay:2.0];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
