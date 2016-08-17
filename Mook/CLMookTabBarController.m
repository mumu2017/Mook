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
#import "CLPasswordVC.h"

#import "CLShowModel.h"
#import "CLIdeaObjModel.h"
#import "CLRoutineModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"
#import "CLNewEntryTool.h"

@interface CLMookTabBarController ()<EAIntroDelegate>

@property (nonatomic, assign) BOOL isLaunched;

@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) EAIntroView *introView;

@property (nonatomic, assign) BOOL isNotFirstTimeLaunch;
@property (nonatomic, assign) BOOL isImportingData;
@property (nonatomic, strong) NSDictionary *importDict;

@property(strong,nonatomic)NSTimer *passwordTimer;

// 直接跳过密码页面(默认为NO)
@property (nonatomic, assign) BOOL showContentWithoutPassword;

@end

@implementation CLMookTabBarController

#pragma - 定时器

/**
 *  开启定时器
 */
-(void)startTimer
{
    if(self.passwordTimer == nil){
        
        // 30秒钟之内,如果用户退出页面, 则可以不用输入密码而进入应用
        self.passwordTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(setPassowrdSkipping) userInfo:nil repeats:YES];
        
        //如果不添加下面这条语句，在UITableView拖动的时候，会阻塞定时器的调用
        [[NSRunLoop currentRunLoop] addTimer:self.passwordTimer forMode:UITrackingRunLoopMode];
    }
}
/**
 *  关闭定时器
 */
-(void)closeTimer
{
    if (self.passwordTimer) {

        [self.passwordTimer invalidate];
        self.passwordTimer = nil;
    }
}

- (void)setPassowrdSkipping {
    
    self.showContentWithoutPassword = NO;
    
    [self closeTimer];
}

#pragma mark - 工厂方法

//- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes {
//    if (self = [super initWithViewControllers:viewControllers tabBarItemsAttributes:tabBarItemsAttributes]) {
//        
//        self.tabBarItemsAttributes = tabBarItemsAttributes;
//        self.viewControllers = viewControllers;
//    }
//    return self;
//}
//
//+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes {
//    CLMookTabBarController *tabBarController = [[CLMookTabBarController alloc] initWithViewControllers:viewControllers tabBarItemsAttributes:tabBarItemsAttributes];
//    
//    return tabBarController;
//}

- (BOOL)isNotFirstTimeLaunch { // 检测是否是第一次启动应用

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


// 开始导入操作
- (void)importStart:(NSNotification *)noti {
    self.isImportingData = YES;
    self.importDict = noti.userInfo;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey]) {
        
        // 如果需要输入密码, 那么不需要做任何操作, 密码填写正确后会在block中进行segue跳转
        // 如果可以跳过密码, 则打开导入页面
        if (self.showContentWithoutPassword) {
            
            // 如果需要导入, 则打开导入页面
            if (self.importDict) {
                [self openImportVC];
                self.isImportingData = NO;
            }
            
        }
    } else {    // 如果不需要输入密码, 则直接进行跳转
        
        if (self.importDict) {
            [self openImportVC];
            self.isImportingData = NO;
        }
    }
}

- (void)openImportVC {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CLImportContentNavVC *navVC =  [sb instantiateViewControllerWithIdentifier:@"importNavVC"];
    navVC.importDict = self.importDict;
    
    [self presentViewController:navVC animated:YES completion:nil];
    
}

- (void)openPasswordVC {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:[NSBundle mainBundle]];
    CLPasswordVC *vc =  [sb instantiateViewControllerWithIdentifier:@"passwordVC"];
    
    [[kAppDelegate window] setRootViewController:vc];

}

- (void)importFinish { // 导入完成
    self.isImportingData = NO;
    self.importDict = nil;
}

// 取消新建笔记
- (void)cancelEntry:(NSNotification *)noti {
    if (noti.object == nil) {
//        NSLog(@"error : cancel object == nil");
        return;
    } else {
        id modelUnknown = noti.object;
        [CLNewEntryTool cancelNewEntry:modelUnknown];
    }
    
}

// 删除笔记操作(所有的删除和取消都以通知的方式在本控制器进行操作)
- (void)deleteEntry:(NSNotification *)noti {
    if (noti.object == nil) {
//        NSLog(@"error : delete object == nil");
        return;
    } else {
        id modelUnknown = noti.object;
        [CLNewEntryTool deleteEntry:modelUnknown];

    }
}

// 展示欢迎界面
- (void)showIntroWithCrossDissolve {
    
    NSString *sampleDescription1 = NSLocalizedString(@"随时随地记录想法,让创作无处不在", nil);
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

// 显示密码输入界面
- (void)inputPassword {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kCheckIfShouldPasswordKey]) {
        // 如果可以跳过密码, 则跳过
        if (self.showContentWithoutPassword) {
            
        } else { //否则, 展示密码页
            
            [self openPasswordVC];

        }
    }
}

// 密码核对正确后的操作
- (void)passwordMatch {
    
    [[kAppDelegate window] setRootViewController:[kAppDelegate mainController]];
    
    self.showContentWithoutPassword = YES;

    [self startTimer];
    
    if (self.isImportingData) {
        if (self.importDict) {
            [self openImportVC];
            self.isImportingData = NO;
        }
    }
    
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
        
        [self openPasswordVC];
        self.isLaunched = NO;
    }

}
//
//#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)modelUnknown {
//    
//    id destVC = segue.destinationViewController;
//    
//    if ([destVC isKindOfClass:[CLImportContentNavVC class]]) {
//        CLImportContentNavVC *vc = (CLImportContentNavVC *)destVC;
//        vc.hidesBottomBarWhenPushed = YES;
//        
//        
//    }
//}
//

@end
