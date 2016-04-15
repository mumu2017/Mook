//
//  CLMookTabBarController.m
//  Mook
//
//  Created by 陈林 on 15/12/31.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLMookTabBarController.h"
#import "EAIntroView.h"
#import "CLImportContentNavVC.h"
#import "CLDataSaveTool.h"

#import "CLShowModel.h"
#import "CLIdeaObjModel.h"
#import "CLRoutineModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"

@interface CLMookTabBarController ()<EAIntroDelegate>

@property (nonatomic, assign) BOOL isLaunched;

@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) EAIntroView *introView;

@property (nonatomic, assign) BOOL isNotFirstTimeLaunch;
@property (nonatomic, assign) BOOL isImportingData;
@property (nonatomic, strong) NSDictionary *importDict;

@end

@implementation CLMookTabBarController


- (BOOL)isNotFirstTimeLaunch {

    return [[NSUserDefaults standardUserDefaults] boolForKey:kNotFirstTimeLaunchKey];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rootView = self.view;
    
    self.isLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteEntry:) name:kDeleteEntryNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelEntry:) name:kCancelEntryNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordMatch) name:@"passwordMatch" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showIntroWithCrossDissolve) name:@"showIntroView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importStart:) name:@"importStart" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importFinish) name:@"dismissImportContentVC" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputPassword) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if (self.isNotFirstTimeLaunch) {
        // 如果不是第一次打开, 那就不用显示欢迎界面
    } else {
        [self showIntroWithCrossDissolve];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNotFirstTimeLaunchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)importStart:(NSNotification *)noti {
    self.isImportingData = YES;
    self.importDict = noti.userInfo;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey]) {
        
        // 如果需要输入密码, 那么不需要做任何操作, 密码填写正确后会在block中进行segue跳转
    } else {    // 如果不需要输入密码, 则直接进行跳转
        
        if (self.importDict) {
            [self performSegueWithIdentifier:kSegueImportContent sender:self.importDict];
            self.isImportingData = NO;
        }
    }
}

- (void)importFinish {
    self.isImportingData = NO;
    self.importDict = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelEntry:(NSNotification *)noti {
    if (noti.object == nil) {
        NSLog(@"error : cancel object == nil");
        return;
    } else {
        id modelUnknown = noti.object;
        if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
            CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
            
            [kDataListIdea removeObject:model];
            [kDataListAll removeObject:model];
            
        } else if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
            CLShowModel *model = (CLShowModel *)modelUnknown;
            
            [kDataListShow removeObject:model];
            [kDataListAll removeObject:model];
            
        } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
            CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
            
            [kDataListRoutine removeObject:model];
            [kDataListAll removeObject:model];
            
        } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
            CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
            
            [kDataListSleight removeObject:model];
            [kDataListAll removeObject:model];
            
        } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
            CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
            
            [kDataListProp removeObject:model];
            [kDataListAll removeObject:model];
            
        } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
            CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
            
            [kDataListLines removeObject:model];
            [kDataListAll removeObject:model];
            
        }
        
        NSLog(@"cancel entry sucess!");
    }
    
}

- (void)deleteEntry:(NSNotification *)noti {
    if (noti.object == nil) {
        NSLog(@"error : delete object == nil");
        return;
    } else {
        id modelUnknown = noti.object;
        if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
            CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
            
            [CLDataSaveTool deleteIdea:model];
            
            [kDataListIdea removeObject:model];
            [kDataListAll removeObject:model];
            
        } else if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
            CLShowModel *model = (CLShowModel *)modelUnknown;
            
            [CLDataSaveTool deleteShow:model];
            
            [kDataListShow removeObject:model];
            [kDataListAll removeObject:model];
            
        } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
            CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
            
            [CLDataSaveTool deleteRoutine:model];
            
            [kDataListRoutine removeObject:model];
            [kDataListAll removeObject:model];
            
        } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
            CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
            
            [kDataListSleight removeObject:model];
            [kDataListAll removeObject:model];
            
        } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
            CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
            
            [CLDataSaveTool deleteProp:model];
            
            [kDataListProp removeObject:model];
            [kDataListAll removeObject:model];
            
        } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
            CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
            
            [CLDataSaveTool deleteLines:model];
            
            [kDataListLines removeObject:model];
            [kDataListAll removeObject:model];
            
        }
        
        NSLog(@"delete entry sucess!");
    }
}

- (void)showIntroWithCrossDissolve {
    
    NSString *sampleDescription1 = NSLocalizedString(@"随时随地记录灵感,让创作无处不在", nil);
    NSString *sampleDescription2 = NSLocalizedString(@"私人订制魔术库,触手可及", nil);
    NSString *sampleDescription3 = NSLocalizedString(@"视频,图片,语音...魔术记录从未如此简单", nil);
    NSString *sampleDescription4 = NSLocalizedString(@"从今天起,做一个更好的魔术师", nil);
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Mook";
    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"idea.jpg"];
    page1.titleIconView = nil;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = NSLocalizedString(@"您的私人魔术图书馆", nil);
    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"prop.jpg"];
    page2.titleIconView = nil;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = NSLocalizedString(@"多媒体记录", nil);
    page3.desc = sampleDescription3; 
    page3.bgImage = [UIImage imageNamed:@"routine.jpg"];
    page3.titleIconView = nil;
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = NSLocalizedString(@"欢迎使用", nil);
    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"show.jpg"];
    page4.titleIconView = nil;
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.rootView.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    
    [intro showInView:self.rootView animateDuration:0.3];
}

- (void)inputPassword {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kCheckIfShouldPasswordKey]) {
        [self performSegueWithIdentifier:kMookToPasswordSegue sender:nil];
    }
}

- (void)passwordMatch {
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.isImportingData) {
            if (self.importDict) {
                [self performSegueWithIdentifier:kSegueImportContent sender:self.importDict];
                self.isImportingData = NO;
            }
        }
    }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isLaunched) {
        
        [self performSegueWithIdentifier:kMookToPasswordSegue sender:nil];
        self.isLaunched = NO;
    }

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)modelUnknown {
    
    id destVC = segue.destinationViewController;
    
    if ([destVC isKindOfClass:[CLImportContentNavVC class]]) {
        CLImportContentNavVC *vc = (CLImportContentNavVC *)destVC;
        vc.hidesBottomBarWhenPushed = YES;
        vc.importDict = self.importDict;
        
    }
}


@end
