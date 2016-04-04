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

#import "CLDataSaveTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (NSMutableArray *)allItems {
    if (!_allItems) {
        _allItems = [CLDataSaveTool allItems];
        if (!_allItems) _allItems = [NSMutableArray array];
    }
    return _allItems;
}

- (NSMutableArray *)allTags {
    if (!_allTags) {
        _allTags = [CLDataSaveTool allTags];
        if (!_allTags) _allTags = [NSMutableArray array];
    }
    return _allTags;
}

- (NSMutableArray *)_allTagsShow {
    if (!_allTagsShow) {
        _allTagsShow = [CLDataSaveTool allTagsShow];
        if (!_allTagsShow) _allTagsShow = [NSMutableArray array];
    }
    return _allTagsShow;
}


- (NSMutableArray *)allTagsShow {
    if (!_allTagsShow) {
        _allTagsShow = [CLDataSaveTool allTagsShow];
        if (!_allTagsShow) _allTagsShow = [NSMutableArray array];
    }
    return _allTagsShow;
}

- (NSMutableArray *)allTagsIdea {
    if (!_allTagsIdea) {
        _allTagsIdea = [CLDataSaveTool allTagsIdea];
        if (!_allTagsIdea) _allTagsIdea = [NSMutableArray array];
    }
    return _allTagsIdea;
}

- (NSMutableArray *)allTagsRoutine {
    if (!_allTagsRoutine) {
        _allTagsRoutine = [CLDataSaveTool allTagsRoutine];
        if (!_allTagsRoutine) _allTagsRoutine = [NSMutableArray array];
    }
    return _allTagsRoutine;
}

- (NSMutableArray *)allTagsSleight {
    if (!_allTagsSleight) {
        _allTagsSleight = [CLDataSaveTool allTagsSleight];
        if (!_allTagsSleight) _allTagsSleight = [NSMutableArray array];
    }
    return _allTagsSleight;
}

- (NSMutableArray *)allTagsProp {
    if (!_allTagsProp) {
        _allTagsProp = [CLDataSaveTool allTagsProp];
        if (!_allTagsProp) _allTagsProp = [NSMutableArray array];
    }
    return _allTagsProp;
}

- (NSMutableArray *)allTagsLines {
    if (!_allTagsLines) {
        _allTagsLines = [CLDataSaveTool allTagsLines];
        if (!_allTagsLines) _allTagsLines = [NSMutableArray array];
    }
    return _allTagsLines;
}

- (NSMutableArray<CLShowModel *> *)showModelList {
    if (!_showModelList) {
        _showModelList = [CLDataSaveTool allShows];
        if (!_showModelList) _showModelList = [NSMutableArray array];
    }
    return _showModelList;
}

-(NSMutableArray *)routineModelList {
    if (!_routineModelList) {
        _routineModelList = [CLDataSaveTool allRoutines];
        if (!_routineModelList) _routineModelList = [NSMutableArray array];
    }
    return _routineModelList;
}

-(NSMutableArray *)ideaObjModelList {
    if (!_ideaObjModelList) {
        _ideaObjModelList = [CLDataSaveTool allIdeas];
        if (!_ideaObjModelList) _ideaObjModelList = [NSMutableArray array];
    }
    return _ideaObjModelList;
}

-(NSMutableArray *)sleightObjModelList {
    if (!_sleightObjModelList) {
        _sleightObjModelList = [CLDataSaveTool allSleights];
        if (!_sleightObjModelList) _sleightObjModelList = [NSMutableArray array];
    }
    return _sleightObjModelList;
}

- (NSMutableArray *)propObjModelList {
    if (!_propObjModelList) {
        _propObjModelList = [CLDataSaveTool allProps];
        if (!_propObjModelList) _propObjModelList = [NSMutableArray array];
    }
    return _propObjModelList;
}

- (NSMutableArray *)linesObjModelList {
    if (!_linesObjModelList) {
        _linesObjModelList = [CLDataSaveTool allLines];
        if (!_linesObjModelList) _linesObjModelList = [NSMutableArray array];
    }
    return _linesObjModelList;
}

#pragma mark - Update Data

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.shouldInputPassword = [[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey];
    
    self.window.tintColor = kMenuBackgroundColor;
        
    [[UIToolbar appearance] setTranslucent:NO];
    [[UIToolbar appearance] setOpaque:YES];
    [[UIToolbar appearance] setTintColor:kTintColor];
    [[UIToolbar appearance] setBarTintColor:nil];
    
    [[UINavigationBar appearance] setTintColor:kTintColor];
    [[UINavigationBar appearance] setBarTintColor:kMenuBackgroundColor];

    // 设置导航栏没有边线
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
//                                      forBarPosition:UIBarPositionAny
//                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setOpaque:YES];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           kTintColor, NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    
    // 已经在info.plist文件中设置了statusBarStyle属性为lightContent
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //        [defaults setBool:NO forKey:kUsePasswordKey];
    //        [defaults setBool:NO forKey:kSavePhotoKey];
    //        [defaults setBool:NO forKey:kSaveVideoKey];
    //        [defaults setObject:@"" forKey:kPasswordKey];
    //        [defaults setBool:NO forKey:kCheckIfShouldPasswordKey];
    //
    //        [defaults synchronize];
    //
    //    });
    
    //    NSDictionary *userDefaultsDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                          [NSNumber numberWithBool:NO], kUsePasswordKey,
    //                                          kSavePhotoKey, @"AnotherKey",
    //                                          [NSNumber numberWithInt:0], @"NumberKey",
    //                                          nil];
    //    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];
    
    
    BOOL usePassword = [[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey];
    [[NSUserDefaults standardUserDefaults] setBool:usePassword forKey:kCheckIfShouldPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [self registerForDataNotifications];
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    BOOL usePassword = [[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey];
    [[NSUserDefaults standardUserDefaults] setBool:usePassword forKey:kCheckIfShouldPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    self.shouldInputPassword = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
