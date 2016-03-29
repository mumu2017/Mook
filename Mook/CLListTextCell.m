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
        self.iconType.image = [UIImage imageNamed:@"mookIcon"];
    }
}
//
//- (void)setIsStarred:(BOOL)isStarred {
//    _isStarred = isStarred;
//}
//
//- (void)setDate:(NSString *)date {
//    _date = date;
//    
//    self.dateLabel.text = date;
//}
//
//- (void)setInfoModel:(CLInfoModel *)infoModel {
//    _infoModel = infoModel;
//    self.titleLabel.text = infoModel.name;
//}
//
//- (void)setEffectModel:(CLEffectModel *)effectModel {
//    _effectModel = effectModel;
//    
//    if (self.isStarred) {
//        self.contentLabel.text = [NSString stringWithFormat:@"★%@", effectModel.effect];
//    } else {
//        self.contentLabel.text = effectModel.effect;
//        
//    }
//}
//
//- (void)setTags:(NSMutableArray<NSString *> *)tags {
//    _tags = tags;
//    
//    NSString *tag1, *tag2, *tag3;
//    
//    if (tags.count == 0) {
//        
//        self.Tag1.hidden = YES;
//        self.Tag2.hidden = YES;
//        self.Tag3.hidden = YES;
//        
//    } else if (tags.count == 1) {
//        tag1 = tags[0];
//        [self setTagAppearance:self.Tag1 withTag:tag1];
//        
//        self.Tag2.hidden = YES;
//        self.Tag3.hidden = YES;
//        
//    } else if (tags.count == 2) {
//        tag1 = tags[0];
//        [self setTagAppearance:self.Tag1 withTag:tag1];
//        
//        tag2 = tags[1];
//        [self setTagAppearance:self.Tag2 withTag:tag2];
//        
//        self.Tag3.hidden = YES;
//        
//    } else if (tags.count >= 2) {
//        tag1 = tags[0];
//        [self setTagAppearance:self.Tag1 withTag:tag1];
//        self.Tag1.hidden = NO;
//        
//        tag2 = tags[1];
//        [self setTagAppearance:self.Tag2 withTag:tag2];
//        
//        tag3 = tags[2];
//        [self setTagAppearance:self.Tag3 withTag:tag3];
//    }
//    
//}
//
//- (void)setTagAppearance:(UILabel *)tagLabel withTag:(NSString *)tag {
//    
//    tagLabel.hidden = NO;
//    tagLabel.backgroundColor = [UIColor whiteColor];
//    tagLabel.layer.cornerRadius = 8;
//    tagLabel.layer.borderColor  = kTintColor.CGColor;
//    tagLabel.layer.borderWidth  = 0.5;
//    
//    tagLabel.text = [NSString stringWithFormat:@" %@  ", tag];
//}
//
- (void)awakeFromNib {
    
    self.backgroundColor = kCellBgColor;
    
//    self.titleLabel.numberOfLines = 0;
//    self.titleLabel.font = kBoldFontSys14;
//    self.titleLabel.textColor = [UIColor blackColor];
    
    //    [self.iconView setContentMode:UIViewContentModeScaleAspectFill];
    //    self.iconView.clipsToBounds = YES;
    
//    self.contentLabel.numberOfLines = 0;
//    self.contentLabel.font = kFontSys14;
//    self.contentLabel.textColor = [UIColor blackColor];;
//    
//    self.dateLabel.textAlignment = NSTextAlignmentRight;
//    self.dateLabel.font = kFontSys12;
//    self.dateLabel.textColor = [UIColor grayColor];
}



@end
