//
//  CLTextCell.h
//  Mook
//
//  Created by 陈林 on 16/6/27.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLTextCell : UITableViewCell


@property (strong, nonatomic) UILabel *contentLabel;


- (void)setAttributedString:(NSAttributedString *)text;


@end
