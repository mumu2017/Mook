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
        
        NSString *imageName;
        if ([iconName isEqualToString:kIconNameIdea]) {
            imageName = @"idea.jpg";
        } else if ([iconName isEqualToString:kIconNameShow]) {
            imageName = @"show.jpg";
        } else if ([iconName isEqualToString:kIconNameRoutine]) {
            imageName = @"routine.jpg";
        } else if ([iconName isEqualToString:kIconNameSleight]) {
            imageName = @"sleight.jpg";
        } else if ([iconName isEqualToString:kIconNameProp]) {
            imageName = @"prop.jpg";
        } if ([iconName isEqualToString:kIconNameLines]) {
            imageName = @"lines.jpg";
        }
        
        self.typeIcon.image = [UIImage imageNamed:imageName];
        
    }
}

@end
