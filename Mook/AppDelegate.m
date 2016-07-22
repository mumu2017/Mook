//
//  AppDelegate.m
//  Mook
//
//  Created by 陈林 on 15/11/16.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "AppDelegate.h"
#import "CLShowModel.h"
#import "CLRoutineModel.h"
#import "CLIdeaObjModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"

#import "CLEffectModel.h"
#import "CLPrepModel.h"
#import "CLPerformModel.h"

#import "CLDataImportTool.h"
#import "CLDataSaveTool.h"
#import "iflyMSC/IFlyMSC.h"
#import "Appirater.h"
#import "CLMookTabBarController.h"

@interface AppDelegate ()<MBProgressHUDDelegate>

@end

@implementation AppDelegate


#pragma mark - Update Data

- (void)reloadData { //恢复备份后刷新数据
    self.allItems = nil;
    
    self.allTags = nil;
    self.allTagsShow = nil;
    self.allTagsIdea = nil;
    self.allTagsRoutine = nil;
    self.allTagsSleight = nil;
    self.allTagsProp = nil;
    self.allTagsLines = nil;
    
    self.showModelList = nil;
    self.routineModelList = nil;
    self.ideaObjModelList = nil;
    self.sleightObjModelList = nil;
    self.propObjModelList = nil;
    self.linesObjModelList = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMookNotification object:nil];
        
    });
}

- (void)updateData {
    self.allItems = nil;
    self.showModelList = nil;
    self.routineModelList = nil;
    self.ideaObjModelList = nil;
    self.sleightObjModelList = nil;
    self.propObjModelList = nil;
    self.linesObjModelList = nil;
}

- (UIColor *)themeColor {
    
    kThemeColorSet colorCode = 0;
    
    colorCode = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kThemeColorKey];
    
    switch (colorCode) {
        case flatBlackColorDark:
            _themeColor = [UIColor flatBlackColorDark];
            break;
        case flatBlueColorDark:
            _themeColor = [UIColor flatBlueColorDark];
            break;
        case flatForestGreenColorDark:
            _themeColor = [UIColor flatForestGreenColorDark];
            break;
        case flatGreenColorDark:
            _themeColor = [UIColor flatGreenColorDark];
            break;
        case flatMagentaColorDark:
            _themeColor = [UIColor flatMagentaColorDark];
            break;
        case flatMaroonColorDark:
            _themeColor = [UIColor flatMaroonColorDark];
            break;
        case flatMintColorDark:
            _themeColor = [UIColor flatMintColorDark];
            break;
        case flatNavyBlueColorDark:
            _themeColor = [UIColor flatNavyBlueColorDark];
            break;
        case flatOrangeColorDark:
            _themeColor = [UIColor flatOrangeColorDark];
            break;
        case flatPinkColorDark:
            _themeColor = [UIColor flatPinkColorDark];
            break;
        case flatPlumColorDark:
            _themeColor = [UIColor flatPlumColorDark];
            break;
        case flatPurpleColorDark:
            _themeColor = [UIColor flatPurpleColorDark];
            break;
        case flatRedColorDark:
            _themeColor = [UIColor flatRedColorDark];
            break;
        case flatSkyBlueColorDark:
            _themeColor = [UIColor flatSkyBlueColorDark];
            break;
        case flatTealColorDark:
            _themeColor = [UIColor flatTealColorDark];
            break;
        case flatWatermelonColorDark:
            _themeColor = [UIColor flatWatermelonColorDark];
            break;
        default:
            break;
    }
    
    if (!_themeColor) {
        _themeColor = [UIColor flatSkyBlueColorDark];
    }
    
    return _themeColor;
}

- (void)setAppUI { // 设置应用UI
    
    self.window.tintColor = self.themeColor;
    
    [[UISwitch appearance] setOnTintColor:self.themeColor];
    [[UISegmentedControl appearance] setTintColor:self.themeColor];
    
    [[UIToolbar appearance] setTranslucent:NO];
    [[UIToolbar appearance] setOpaque:YES];
    [[UIToolbar appearance] setTintColor:kTintColor];
    
    [[UINavigationBar appearance] setTintColor:kTintColor];
    [[UINavigationBar appearance] setBarTintColor:self.themeColor];
    
    [[UITabBar appearance] setTintColor:self.themeColor];
    
//     设置导航栏没有边线
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
//                                      forBarPosition:UIBarPositionAny
//                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTranslucent:NO]; // 半透明效果
    [[UINavigationBar appearance] setOpaque:YES];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           kTintColor, NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    
    // 已经在info.plist文件中设置了statusBarStyle属性为lightContent
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)registerIFlyVoiceRecognition { // 注册讯飞语音识别
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",kIFlyAppID];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];

}

- (void)checkPasswordInfo { // 检查是否使用密码
    self.shouldInputPassword = [[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey];
    
    BOOL usePassword = [[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey];
    [[NSUserDefaults standardUserDefaults] setBool:usePassword forKey:kCheckIfShouldPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 下面两个openURL的方法是导入文件时触发
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{

    return [self handleURL:url];
}

//- application:handleOpenURL:
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {

    return [self handleURL:url];

}

// 处理外部导入的数据
- (BOOL)handleURL:(NSURL *)url {    // url是Document/Inbox文件夹下面的路径

    // 第一步: 获取模型字典
    NSDictionary *dict = [CLDataImportTool getDataFromURL:url];
    
    if (dict != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"importStart" object:nil userInfo:dict];
        
        return YES;
        
    } else {
        
        [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"无法打开文件", nil) hideAfterDelay:2.5];

    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // 设置主窗口,并设置根控制器
//    self.window = [[UIWindow alloc]init];
//    self.window.frame = [UIScreen mainScreen].bounds;
//    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
//    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
//    [self.window makeKeyAndVisible];
//

//
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    [self.window setRootViewController:self.mainController];
    [self.window makeKeyAndVisible];

    [self setAppUI];
    [self checkPasswordInfo];
    [self registerIFlyVoiceRecognition];
    
    [self setAppiraterForRatingMook];
//    NSLog(@"%@", [NSString imagePath]);
    
    
    return YES;
    
}

// 设置评分提醒
- (void)setAppiraterForRatingMook {
    
//    [Appirater setAppId:@"1105302733"];    // Change for your "Your APP ID"
//    [Appirater setDaysUntilPrompt:0];     // Days from first entered the app until prompt
//    [Appirater setUsesUntilPrompt:5];     // Number of uses until prompt
//    [Appirater setTimeBeforeReminding:2]; // Days until reminding if the user taps "remind me"
//    //[Appirater setDebug:YES];           // If you set this to YES it will display all the time
//    
//    //... Perhaps do stuff
    
    [Appirater setCustomAlertTitle:NSLocalizedString(@"请评价Mook", nil)];
    [Appirater setCustomAlertMessage:NSLocalizedString(@"如果您喜欢Mook的话,请给个好评吧!", nil)];
    [Appirater setCustomAlertRateButtonTitle:NSLocalizedString(@"去AppStore评分", nil)];
    [Appirater setCustomAlertRateLaterButtonTitle:NSLocalizedString(@"稍后提示", nil)];
    [Appirater setCustomAlertCancelButtonTitle:NSLocalizedString(@"不用了,谢谢", nil)];
    
    
    [Appirater setAppId:@"1105302733"];
    [Appirater setDaysUntilPrompt:7];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater appLaunched:YES];
    [Appirater setDebug:NO];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // 退到后台后,就dismiss所有的Modal ViewController
    CLMookTabBarController* rootVC = (CLMookTabBarController*)self.window.rootViewController;
    
    [rootVC dismissViewControllerAnimated:NO completion:nil];
    
}

// 应用退到后台时的处理
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    // 保存用户偏好数据
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 清空临时文件
    [NSString clearTmpDirectory];
    
}

// 应用将要恢复前台时的处理
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    BOOL usePassword = [[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey];
    [[NSUserDefaults standardUserDefaults] setBool:usePassword forKey:kCheckIfShouldPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    self.shouldInputPassword = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 数据懒加载方法
- (NSMutableArray *)allItems {
    if (!_allItems) {
        _allItems = [CLDataSaveTool allItems];
    }
    return _allItems;
}

- (NSMutableArray *)allTags {
    if (!_allTags) {
        _allTags = [CLDataSaveTool allTags];
    }
    return _allTags;
}

- (NSMutableArray *)_allTagsShow {
    if (!_allTagsShow) {
        _allTagsShow = [CLDataSaveTool allTagsShow];
    }
    return _allTagsShow;
}


- (NSMutableArray *)allTagsShow {
    if (!_allTagsShow) {
        _allTagsShow = [CLDataSaveTool allTagsShow];
    }
    return _allTagsShow;
}

- (NSMutableArray *)allTagsIdea {
    if (!_allTagsIdea) {
        _allTagsIdea = [CLDataSaveTool allTagsIdea];
    }
    return _allTagsIdea;
}

- (NSMutableArray *)allTagsRoutine {
    if (!_allTagsRoutine) {
        _allTagsRoutine = [CLDataSaveTool allTagsRoutine];
    }
    return _allTagsRoutine;
}

- (NSMutableArray *)allTagsSleight {
    if (!_allTagsSleight) {
        _allTagsSleight = [CLDataSaveTool allTagsSleight];
    }
    return _allTagsSleight;
}

- (NSMutableArray *)allTagsProp {
    if (!_allTagsProp) {
        _allTagsProp = [CLDataSaveTool allTagsProp];
    }
    return _allTagsProp;
}

- (NSMutableArray *)allTagsLines {
    if (!_allTagsLines) {
        _allTagsLines = [CLDataSaveTool allTagsLines];
    }
    return _allTagsLines;
}

- (NSMutableArray<CLShowModel *> *)showModelList {
    if (!_showModelList) {
        _showModelList = [CLDataSaveTool allShows];
    }
    return _showModelList;
}

-(NSMutableArray *)routineModelList {
    if (!_routineModelList) {
        _routineModelList = [CLDataSaveTool allRoutines];
    }
    return _routineModelList;
}

-(NSMutableArray *)ideaObjModelList {
    if (!_ideaObjModelList) {
        _ideaObjModelList = [CLDataSaveTool allIdeas];
    }
    return _ideaObjModelList;
}

-(NSMutableArray *)sleightObjModelList {
    if (!_sleightObjModelList) {
        _sleightObjModelList = [CLDataSaveTool allSleights];
    }
    return _sleightObjModelList;
}

- (NSMutableArray *)propObjModelList {
    if (!_propObjModelList) {
        _propObjModelList = [CLDataSaveTool allProps];
    }
    return _propObjModelList;
}

- (NSMutableArray *)linesObjModelList {
    if (!_linesObjModelList) {
        _linesObjModelList = [CLDataSaveTool allLines];
    }
    return _linesObjModelList;
}

#pragma mark - reload方法: // 如果指针不为空, 则重新加载数据
- (void)reloadAllItems {
    if (_allItems) {
        _allItems = [CLDataSaveTool allItems];
    }
}

- (void)reloadAllIdeas {
    if (_ideaObjModelList) {
        _ideaObjModelList = [CLDataSaveTool allIdeas];
    }
}

- (void)reloadAllShows {
    if (_showModelList) {
        _showModelList = [CLDataSaveTool allShows];
    }
}

- (void)reloadAllRoutines {
    if (_routineModelList) {
        _routineModelList = [CLDataSaveTool allRoutines];
    }
}

- (void)reloadAllSleights {

    if (_sleightObjModelList) {
        _sleightObjModelList = [CLDataSaveTool allSleights];
    }
}

- (void)reloadAllProps {
    if (_propObjModelList) {
        _propObjModelList = [CLDataSaveTool allProps];
    }
}

- (void)reloadAllLines {
    if (_linesObjModelList) {
        _linesObjModelList = [CLDataSaveTool allLines];
    }
}

- (UIViewController *)mainController {
    
    if (!_mainController) {
    
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        CLMookTabBarController *navVC =  [sb instantiateViewControllerWithIdentifier:@"mookVC"];
        _mainController = navVC;
    }
    
    return _mainController;
}

@end
