//
//  CLHomeNavVC.m
//  Mook
//
//  Created by 陈林 on 16/3/26.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLHomeNavVC.h"

@interface CLHomeNavVC ()

@property (nonatomic, assign) BOOL isLaunched;

@end

@implementation CLHomeNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
