//
//  CLSettingVC.m
//  Mook
//
//  Created by 陈林 on 15/11/20.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLSettingVC.h"
#import "CLPasswordVC.h"
#import "CLDataSaveTool.h"
#import "ZipArchive.h"
#import "MBProgressHUD.h"

#import "IATConfig.h"

#import <MessageUI/MFMailComposeViewController.h>

@interface CLSettingVC ()<MBProgressHUDDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *passwordSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *savePhotoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *saveVideoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *touchIDSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *languageControl;

@property (nonatomic, assign) BOOL isCreatBackUp;
@property (nonatomic, assign) BOOL backUpExists;
@property (nonatomic, copy) NSString *voiceLanguage;

@end

@implementation CLSettingVC

- (NSString *)voiceLanguage {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _voiceLanguage = [defaults stringForKey:kVoiceLanguageKey];
    if (_voiceLanguage == nil) {
        _voiceLanguage = kVoiceChinese;
        [defaults setObject:_voiceLanguage forKey:kVoiceLanguageKey];
        [defaults synchronize];
    }
    
    return _voiceLanguage;
}

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
    
    if ([self.voiceLanguage isEqualToString:kVoiceChinese]) {
        self.languageControl.selectedSegmentIndex = 0;
    } else if ([self.voiceLanguage isEqualToString:kVoiceGuangdong]) {
        self.languageControl.selectedSegmentIndex = 1;
    }  else if ([self.voiceLanguage isEqualToString:kVoiceEnglish]) {
        self.languageControl.selectedSegmentIndex = 2;
    }
    NSLog(@"%@", self.voiceLanguage);
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
            number = 2;
            break;
            
        case 3:
            number = 2;
            break;
            
        case 4:
            number = 2;
            break;
            
        case 5:
            number = 4;
            break;
            
        default:
            break;
    }
    return number;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"生成备份", nil) message:NSLocalizedString(@"提示: 生成备份文件后, 请尽快通过iTunes将备份文件导出到您的PC或者Mac中. 为了节省您的存储空间, Mook推荐您在导出备份后删除备份文件. 确定要生成备份文件吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* loadBackUp = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
                    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    [self.navigationController.view addSubview:HUD];
                    
                    HUD.delegate = self;
                    HUD.labelText = NSLocalizedString(@"正在生成备份文件", nil);
                    
                    [HUD showAnimated:YES whileExecutingBlock:^{
                        
                        // Create
                        NSString *backUpName = [NSString backUpPath];
                        NSString *mookPath = [NSString mookPath];
                        self.isCreatBackUp = [SSZipArchive createZipFileAtPath:backUpName withContentsOfDirectory:mookPath keepParentDirectory:YES];
                        
                    } onQueue:dispatch_get_main_queue() completionBlock:^{
                        
                        if (self.isCreatBackUp) {
                            HUD.labelText = NSLocalizedString(@"已成功生成备份文件", nil);
                            [self.tableView reloadData]; // 生成后刷新表格, 显示"恢复备份"
                        } else {
                            HUD.labelText = NSLocalizedString(@"生成备份文件失败", nil);
                        }
                        // Configure for text only and offset down
                        HUD.mode = MBProgressHUDModeText;
                        HUD.margin = 10.f;
                        HUD.yOffset = 150.f;
                        HUD.removeFromSuperViewOnHide = YES;
                        [HUD show:YES];
                        
                        
                        [HUD hide:YES afterDelay:1];
                    }];

                    
                });
                    
            }];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            }];
            
            [alert addAction:loadBackUp];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if (indexPath.row == 1) {
            
            [self performSegueWithIdentifier:kBackUpInfoSegue sender:nil];
            
        } else if (indexPath.row == 2) { // 如果有第三行则表示备份文件存在,可以恢复

            // 恢复备份
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"恢复备份", nil) message:NSLocalizedString(@"注意: 恢复备份后, 您当前的Mook数据将被永久性地替换为备份数据. 确定要恢复备份吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* loadBackUp = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    
                    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                    HUD.labelText = NSLocalizedString(@"正在加载恢复备份", nil);
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
                            HUD.labelText = NSLocalizedString(@"已成功恢复备份文件", nil);
                            
#warning 关于数据刷新的问题(主页几个VC)
                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] reloadData];
                            
                            
                        } else {
                            HUD.labelText = NSLocalizedString(@"恢复备份文件失败", nil);
                        }
                        
                        // Configure for text only and offset down
                        HUD.mode = MBProgressHUDModeText;
                        HUD.margin = 10.f;
                        HUD.yOffset = 150.f;
                        HUD.removeFromSuperViewOnHide = YES;
                        [HUD show:YES];
                        
                        
                        [HUD hide:YES afterDelay:1];
                    }];
                });
                
            }];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            }];
            
            [alert addAction:loadBackUp];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
    
            
        }  else if (indexPath.row == 3) { // 删除备份文件
            
            // 恢复备份
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"删除备份文件", nil) message:NSLocalizedString(@"确定要删除备份文件吗?", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* loadBackUp = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    
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
                            
                            HUD.labelText = NSLocalizedString(@"已删除备份文件", nil);
                            [self.tableView reloadData];
                            
                        } else {
                            HUD.labelText = NSLocalizedString(@"删除备份文件失败", nil);
                        }
                        
                        [HUD show:YES];
                        
                        [HUD hide:YES afterDelay:1];
                    }
                });
                
            }];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            }];
            
            [alert addAction:loadBackUp];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    } else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            
            if ([MFMailComposeViewController canSendMail])
                // The device can send email.
            {
                [self displayMailComposerSheet];
            }
            else
                // The device can not send email.
            {
                MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                [self.navigationController.view addSubview:HUD];
                HUD.mode = MBProgressHUDModeText;
                HUD.removeFromSuperViewOnHide = YES;
                // Configure for text only and offset down
                HUD.margin = 10.f;
                HUD.yOffset = 150.f;
                HUD.delegate = self;
                
                HUD.labelText = NSLocalizedString(@"当前无法发送邮件", nil);
            
                [HUD show:YES];
                [HUD hide:YES afterDelay:2.0];

            }
        }
    } else if (indexPath.section == 5) {
        if (indexPath.row == 2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showIntroView" object:nil];
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    UIViewController *vc = (UIViewController *)destVC;
    vc.hidesBottomBarWhenPushed = YES;
    
    if ([destVC isKindOfClass:[CLPasswordVC class]]) {
        CLPasswordVC *vc = (CLPasswordVC *)destVC;
        
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

- (IBAction)languageControlChanged:(UISegmentedControl *)languageControl {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    IATConfig *instance = [IATConfig sharedInstance];

    if (languageControl.selectedSegmentIndex == 0) {
        
        [defaults setObject:kVoiceChinese forKey:kVoiceLanguageKey];
        instance.language = [IFlySpeechConstant LANGUAGE_CHINESE];
        instance.accent = [IFlySpeechConstant ACCENT_MANDARIN];
        
    } else if (languageControl.selectedSegmentIndex == 1) {
        
        [defaults setObject:kVoiceGuangdong forKey:kVoiceLanguageKey];
        
        instance.language = [IFlySpeechConstant LANGUAGE_CHINESE];
        instance.accent = [IFlySpeechConstant ACCENT_CANTONESE];
        
    } else if (languageControl.selectedSegmentIndex == 2) {
        
        [defaults setObject:kVoiceEnglish forKey:kVoiceLanguageKey];
        instance.language = [IFlySpeechConstant LANGUAGE_ENGLISH];
    }
    
    [defaults synchronize];
    NSLog(@"now what");
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
    NSString *emailBody = NSLocalizedString(@"反馈信息:\n", nil);
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
            HUD.labelText = NSLocalizedString(@"邮件已取消", nil);

//            HUD.labelText = @"Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
            HUD.labelText = NSLocalizedString(@"邮件已保存", nil);

//            HUD.labelText = @"Mail saved";
            break;
        case MFMailComposeResultSent:
            HUD.labelText = NSLocalizedString(@"邮件已发送", nil);

//            HUD.labelText = @"Mail sent";
            break;
        case MFMailComposeResultFailed:
            HUD.labelText = NSLocalizedString(@"邮件发送失败", nil);

//            HUD.labelText = @"Mail sending failed";
            break;
        default:
            HUD.labelText = NSLocalizedString(@"邮件未能发送", nil);

//            HUD.labelText = @"Mail not sent";
            break;
    }
    [HUD show:YES];
    [HUD hide:YES afterDelay:2.0];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
