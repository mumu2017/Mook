//
//  CLMookTabBarController.m
//  Mook
//
//  Created by 陈林 on 15/12/31.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLMookTabBarController.h"

@interface CLMookTabBarController ()

@property (nonatomic, assign) BOOL isLaunched;

@end

@implementation CLMookTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:kUsePasswordKey];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordMatch) name:@"passwordMatch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputPassword) name:UIApplicationWillEnterForegroundNotification object:nil];
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
