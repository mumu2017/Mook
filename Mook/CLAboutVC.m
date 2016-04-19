//
//  CLAboutVC.m
//  Mook
//
//  Created by 陈林 on 16/4/19.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLAboutVC.h"

@interface CLAboutVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation CLAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentTextView.tintColor = [UIColor flatSkyBlueColorDark];
    self.titleLabel.text = NSLocalizedString(@"Mook版本", nil);
    self.contentTextView.text = NSLocalizedString(@"关于内容", nil);

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
