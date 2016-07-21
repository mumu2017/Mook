//
//  CLWebCell.h
//  Mook
//
//  Created by 陈林 on 16/7/20.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLWebSiteModel;

@interface CLWebCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

- (void)setModel:(CLWebSiteModel *)model utilityButtons:(NSArray *)rightButtons delegate:(id<SWTableViewCellDelegate>)delegate;

@end
