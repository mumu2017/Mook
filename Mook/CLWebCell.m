//
//  CLWebCell.m
//  Mook
//
//  Created by 陈林 on 16/7/20.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLWebCell.h"
#import "CLWebSiteModel.h"

@implementation CLWebCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconView.backgroundColor = kAppThemeColor;
    self.iconView.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

}

- (void)setModel:(CLWebSiteModel *)model utilityButtons:(NSArray *)rightButtons delegate:(id<SWTableViewCellDelegate>)delegate {
    
    self.rightUtilityButtons = rightButtons;
    self.delegate = delegate;
    
    self.titleLabel.text = model.title;
    self.urlLabel.text = model.url.absoluteString;
    
    self.iconView.backgroundColor = [UIColor colorWithRandomFlatColorOfShadeStyle:UIShadeStyleDark];
    NSString *firstLetter = [model.title substringToIndex:1];
    
    firstLetter = [firstLetter uppercaseString];
    self.iconLabel.text = firstLetter;
}


@end
