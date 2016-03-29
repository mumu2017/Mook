//
//  CLOneLabelCell.h
//  Mook
//
//  Created by 陈林 on 15/12/9.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLOneLabelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (instancetype)oneLabelCell;

@end
