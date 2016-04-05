//
//  CLSettingVC.m
//  Mook
//
//  Created by 陈林 on 15/11/20.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLSettingVC.h"
#import "CLPasswordVC.h"
#import "SSZipArchive.h"

@interface CLSettingVC ()

@property (weak, nonatomic) IBOutlet UISwitch *passwordSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *savePhotoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *saveVideoSwitch;

@end

@implementation CLSettingVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getUserDefaultsData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPasswordCreated) name:@"newPasswordCreated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPasswordCreation) name:@"cancelPasswordCreation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPasswordChange) name:@"cancelPasswordChange" object:nil];
}

- (void)getUserDefaultsData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.passwordSwitch.on = [defaults boolForKey:kUsePasswordKey];
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
            number = 2;
            break;
            
        case 1:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey]) {
                number = 2;
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
            // Create
//            [SSZipArchive createZipFileAtPath:[NSString backUpPath] withContentsOfDirectory:[NSString mookPath]];
            NSLog(@"creating");
            NSLog(@"%@", [NSString mookPath]);
#warning zip后压缩文件中没有任何内容
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            
            NSString *libraryPath = [paths objectAtIndex:0];
            
//                BOOL flag = [SSZipArchive createZipFileAtPath:[NSString backUpPath] withContentsOfDirectory:libraryPath keepParentDirectory:YES];
            NSString *mookPath = [NSString mookPath];
            // 拼接文件名
            NSString *filePath = [mookPath stringByAppendingPathComponent:@"mook.sqlite"];
            
            BOOL flag = [SSZipArchive createZipFileAtPath:[NSString backUpPath] withFilesAtPaths:@[filePath]];
                if (flag) {
                    NSLog(@"sucess");
                    
                } else {
                    NSLog(@"failed");
                    
                }
      

            
            
            
//            + (BOOL)unzipFileAtPath:(NSString *)path
//        toDestination:(NSString *)destination
//        progressHandler:(void (^)(NSString *entry, unz_file_info zipInfo, long entryNumber, long total))progressHandler
//        completionHandler:(void (^)(NSString *path, BOOL succeeded, NSError *error))completionHandler;
            
        } else if (indexPath.row == 1) {
            // Unzip
//            NSError *error;

//            [SSZipArchive unzipFileAtPath:[NSString backUpPath] toDestination: [NSString mookPath]];
            NSLog(@"unzipping");

            [SSZipArchive unzipFileAtPath:[NSString backUpPath] toDestination:[NSString mookPath] overwrite:YES password:nil error:nil];
            
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

@end
