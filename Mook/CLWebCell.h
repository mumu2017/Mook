//
//  CLWebCell.h
//  Mook
//
//  Created by 陈林 on 16/7/20.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLWebCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UIView *iconView;

- (void)setTitle:(NSString *)title;

@end
