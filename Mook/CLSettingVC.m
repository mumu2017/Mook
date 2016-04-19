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

#import <MessageUI/MFMailComposeViewController.h>

@interface CLSettingVC ()<MBProgressHUDDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *passwordSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *savePhotoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *saveVideoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *touchIDSwitch;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *quickStringCntLabel;
@property (nonatomic, copy) NSString *voiceLanguage;

@property (nonatomic, strong) NSMutableArray <NSString*> *quickStringList;
@end

@implementation CLSettingVC

- (NSMutableArray *)quickStringList {

    if ([[NSUserDefaults standardUserDefaults] objectForKey:kQuickStringKey] == nil) {
        _quickStringList = [NSMutableArray array];
        
        [[NSUserDefaults standardUserDefaults] setObject:_quickStringList forKey:kQuickStringKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kQuickStringKey];
        _quickStringList = [array mutableCopy];
    }

    return _quickStringList;
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserDefaultsData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPasswordCreated) name:@"newPasswordCreated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPasswordCreation) name:@"cancelPasswordCreation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPasswordChange) name:@"cancelPasswordChange" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self getUserDefaultsData];
}

- (void)getUserDefaultsData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.passwordSwitch.on = [defaults boolForKey:kUsePasswordKey];
    self.touchIDSwitch.on = [defaults boolForKey:kTouchIDKey];

    self.savePhotoSwitch.on = [defaults boolForKey:kSavePhotoKey];
    self.saveVideoSwitch.on = [defaults boolForKey:kSaveVideoKey];

    NSString *language;
    if ([self.voiceLanguage isEqualToString:kVoiceChinese]) {
        language = NSLocalizedString(@"普通话", nil);
    } else if ([self.voiceLanguage isEqualToString:kVoiceGuangdong]) {
        language = NSLocalizedString(@"粤语", nil);
    }  else if ([self.voiceLanguage isEqualToString:kVoiceEnglish]) {
        language = NSLocalizedString(@"英语", nil);
    }
    
    self.languageLabel.text = language;
    
    self.quickStringCntLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.quickStringList.count];
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

            number = 1;
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
            number = 3;
            break;
            
        default:
            break;
    }
    return number;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        
    } else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            
            // 检测设备能否发送邮件
            if ([MFMailComposeViewController canSendMail]) {
                [self displayMailComposerSheet];
            } else {
                [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"当前无法发送邮件", nil) hideAfterDelay:1.0];
            }
        }
        
    } else if (indexPath.section == 5) {
        if (indexPath.row == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showIntroView" object:nil];
        }
    }
    
    // 自动取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}


#pragma mark - 跳转Segue
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


#pragma mark - 开关操作方法

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

#pragma mark 更改语音识别语言
- (IBAction)languageControlChanged:(UISegmentedControl *)languageControl {
    
   
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
    
    [picker setSubject:@"Mook反馈"];
    
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
    
 
    NSString *title;
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            title = NSLocalizedString(@"邮件已取消", nil);

            break;
        case MFMailComposeResultSaved:
            title = NSLocalizedString(@"邮件已保存", nil);

            break;
        case MFMailComposeResultSent:
            title = NSLocalizedString(@"邮件已发送", nil);

            break;
        case MFMailComposeResultFailed:
            title = NSLocalizedString(@"邮件发送失败", nil);

            break;
        default:
            title = NSLocalizedString(@"邮件未能发送", nil);

            break;
    }

    [MBProgressHUD showGlobalProgressHUDWithTitle:title hideAfterDelay:1.0];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
