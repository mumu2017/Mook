//
//  CLLanguageVC.m
//  Mook
//
//  Created by 陈林 on 16/4/18.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLLanguageVC.h"
#import "IATConfig.h"


@interface CLLanguageVC ()

@property (nonatomic, copy) NSString *voiceLanguage;


@end

@implementation CLLanguageVC


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

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSInteger row = 0;
    
    if ([self.voiceLanguage isEqualToString:kVoiceChinese]) {
        row = 0;
    } else if ([self.voiceLanguage isEqualToString:kVoiceGuangdong]) {
        row = 1;
    }  else if ([self.voiceLanguage isEqualToString:kVoiceEnglish]) {
        row = 2;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSInteger row = 0;
    
    if ([self.voiceLanguage isEqualToString:kVoiceChinese]) {
        row = 0;
    } else if ([self.voiceLanguage isEqualToString:kVoiceGuangdong]) {
        row = 1;
    }  else if ([self.voiceLanguage isEqualToString:kVoiceEnglish]) {
        row = 2;
    }
    
    if (indexPath.row != row && self.navigationItem.rightBarButtonItem == nil) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveLanguage)];
        
        NSLog(@"language changed");
        
    }

    NSLog(@"now what");
}

- (IBAction)dismiss:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveLanguage {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    IATConfig *instance = [IATConfig sharedInstance];
    
    if (indexPath.row == 0) {
        
        [defaults setObject:kVoiceChinese forKey:kVoiceLanguageKey];
        instance.language = [IFlySpeechConstant LANGUAGE_CHINESE];
        instance.accent = [IFlySpeechConstant ACCENT_MANDARIN];
        
    } else if (indexPath.row == 1) {
        
        [defaults setObject:kVoiceGuangdong forKey:kVoiceLanguageKey];
        
        instance.language = [IFlySpeechConstant LANGUAGE_CHINESE];
        instance.accent = [IFlySpeechConstant ACCENT_CANTONESE];
        
    } else if (indexPath.row == 2) {
        
        [defaults setObject:kVoiceEnglish forKey:kVoiceLanguageKey];
        instance.language = [IFlySpeechConstant LANGUAGE_ENGLISH];
    }
    
    [defaults synchronize];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}

@end
