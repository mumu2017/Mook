//
//  CLMookTabBarController.m
//  Mook
//
//  Created by 陈林 on 15/12/31.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLMookTabBarController.h"
#import "EAIntroView.h"

static NSString * const sampleDescription1 = @"随处记录灵感,告别一闪而逝";
static NSString * const sampleDescription2 = @"私人订制的Magic库,触手可及";
static NSString * const sampleDescription3 = @"视频,图片,文字...记录魔术从未如此简单";
static NSString * const sampleDescription4 = @"做一个更好的魔术师";

@interface CLMookTabBarController ()<EAIntroDelegate>

@property (nonatomic, assign) BOOL isLaunched;

@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) EAIntroView *introView;

@property (nonatomic, assign) BOOL isNotFirstTimeLaunch;

@end

@implementation CLMookTabBarController


- (BOOL)isNotFirstTimeLaunch {

    return [[NSUserDefaults standardUserDefaults] boolForKey:kNotFirstTimeLaunchKey];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rootView = self.view;
    
    self.isLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordMatch) name:@"passwordMatch" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showIntroWithCrossDissolve) name:@"showIntroView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputPassword) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if (self.isNotFirstTimeLaunch) {
        // 如果不是第一次打开, 那就不用显示欢迎界面
    } else {
        [self showIntroWithCrossDissolve];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNotFirstTimeLaunchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"欢迎使用Mook";
    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"idea.jpg"];
    page1.titleIconView = nil;
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"您的Magic管家";
    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"prop.jpg"];
    page2.titleIconView = nil;
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"多媒体记录";
    page3.desc = sampleDescription3; 
    page3.bgImage = [UIImage imageNamed:@"routine.jpg"];
    page3.titleIconView = nil;
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"Mook";
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isLaunched) {
        [self performSegueWithIdentifier:kMookToPasswordSegue sender:nil];
    }
    
    self.isLaunched = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
