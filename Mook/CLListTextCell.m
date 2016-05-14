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
    
    NSString *firstLetter = [iconName substringToIndex:1];
    
    firstLetter = [firstLetter uppercaseString];
    self.typeLabel.text = firstLetter;
    
//    NSMutableArray *colorArr = [NSMutableArray arrayWithCapacity:16];
//    UIColor *color;
//    for (int i = 0; i<15; i++) {
//        color = [self themeColorWithIndex:i];
//        [colorArr addObject:color];
//    }
//    UIColor *typeViewBackgroundColor = [UIColor colorWithRandomColorInArray:colorArr];
    
//    UIColor *typeViewBackgroundColor = [kMenuBackgroundColor darkenByPercentage:0.2];
    
//    UIColor *typeViewBackgroundColor = [[UIColor flatBlackColorDark] lightenByPercentage:0.2];
    
    UIColor *typeViewBackgroundColor = [UIColor colorWithRandomFlatColorOfShadeStyle:UIShadeStyleDark];
    UIColor *typeLabelTextColor = [UIColor colorWithContrastingBlackOrWhiteColorOn:typeViewBackgroundColor isFlat:YES];
    
    self.typeView.backgroundColor = typeViewBackgroundColor;
    self.typeLabel.textColor = typeLabelTextColor;
 
    
//    if (iconName.length > 0) {
//        
//        NSString *imageName;
//        if ([iconName isEqualToString:kIconNameIdea]) {
//            imageName = @"idea.jpg";
//        } else if ([iconName isEqualToString:kIconNameShow]) {
//            imageName = @"show.jpg";
//        } else if ([iconName isEqualToString:kIconNameRoutine]) {
//            imageName = @"routine.jpg";
//        } else if ([iconName isEqualToString:kIconNameSleight]) {
//            imageName = @"sleight.jpg";
//        } else if ([iconName isEqualToString:kIconNameProp]) {
//            imageName = @"prop.jpg";
//        } if ([iconName isEqualToString:kIconNameLines]) {
//            imageName = @"lines.jpg";
//        }
//        
//        self.typeIcon.image = [UIImage imageNamed:imageName];
//        
//    }
}

- (UIColor *)themeColorWithIndex:(NSInteger)index {
    
    UIColor *themeColor;
    
    kThemeColorSet colorCode = (int)index;
    
    switch (colorCode) {
        case flatBlackColorDark:
            themeColor = [UIColor flatBlackColorDark];
            break;
        case flatBlueColorDark:
            themeColor = [UIColor flatBlueColorDark];
            break;
        case flatForestGreenColorDark:
            themeColor = [UIColor flatForestGreenColorDark];
            break;
        case flatGreenColorDark:
            themeColor = [UIColor flatGreenColorDark];
            break;
        case flatMagentaColorDark:
            themeColor = [UIColor flatMagentaColorDark];
            break;
        case flatMaroonColorDark:
            themeColor = [UIColor flatMaroonColorDark];
            break;
        case flatMintColorDark:
            themeColor = [UIColor flatMintColorDark];
            break;
        case flatNavyBlueColorDark:
            themeColor = [UIColor flatNavyBlueColorDark];
            break;
        case flatOrangeColorDark:
            themeColor = [UIColor flatOrangeColorDark];
            break;
        case flatPinkColorDark:
            themeColor = [UIColor flatPinkColorDark];
            break;
        case flatPlumColorDark:
            themeColor = [UIColor flatPlumColorDark];
            break;
        case flatPurpleColorDark:
            themeColor = [UIColor flatPurpleColorDark];
            break;
        case flatRedColorDark:
            themeColor = [UIColor flatRedColorDark];
            break;
        case flatSkyBlueColorDark:
            themeColor = [UIColor flatSkyBlueColorDark];
            break;
        case flatTealColorDark:
            themeColor = [UIColor flatTealColorDark];
            break;
        case flatWatermelonColorDark:
            themeColor = [UIColor flatWatermelonColorDark];
            break;
        default:
            break;
    }
    
    return themeColor;
}

@end
