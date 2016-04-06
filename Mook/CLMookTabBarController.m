//
//  CLMookTabBarController.m
//  Mook
//
//  Created by 陈林 on 15/12/31.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLMookTabBarController.h"
#import "EAIntroView.h"

static NSString * const sampleDescription1 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
static NSString * const sampleDescription2 = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
static NSString * const sampleDescription3 = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
static NSString * const sampleDescription4 = @"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";

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
    page1.title = @"Mook";
    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"show.jpg"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"prop.jpg"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"lines.jpg"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"routine.jpg"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
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
