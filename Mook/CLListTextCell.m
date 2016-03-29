//
//  CLListTextCell.m
//  Mook
//
//  Created by 陈林 on 15/12/25.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLListTextCell.h"
#import "CLInfoModel.h"
#import "CLEffectModel.h"
#import "CLPrepModel.h"

@implementation CLListTextCell

+ (instancetype)listTextCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"CLListTextCell" owner:nil options:nil] lastObject];
}

- (void)setTitle:(NSString *)title content:(NSAttributedString *)content {
    self.titleLabel.text = title;
    self.contentLabel.attributedText = content;
}

- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    
    if (iconName.length > 0) {
        self.iconType.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",iconName]];
    } else {
        self.iconType.image = nil;
    }
}

@end
