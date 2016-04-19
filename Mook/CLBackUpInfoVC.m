//
//  CLBackUpInfoVC.m
//  Mook
//
//  Created by 陈林 on 16/4/19.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLBackUpInfoVC.h"

@interface CLBackUpInfoVC ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation CLBackUpInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contentTextView.text = NSLocalizedString(@"备份说明内容", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
