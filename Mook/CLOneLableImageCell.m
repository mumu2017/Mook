//
//  CLOneLableImageCell.m
//  Mook
//
//  Created by 陈林 on 15/12/29.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLOneLableImageCell.h"
#import "CLInfoModel.h"
#import "CLEffectModel.h"
#import "CLPrepModel.h"

@implementation CLOneLableImageCell

+ (instancetype)oneLabelImageCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"CLOneLableImageCell" owner:nil options:nil] lastObject];
}

- (void)setIsStarred:(BOOL)isStarred {
    _isStarred = isStarred;
}

//- (void)setDate:(NSString *)date {
//    _date = date;
//    
//    self.dateLabel.text = date;
//}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    if (imageName.length > 0) {
        self.iconView.image = [UIImage imageWithImage:[imageName getNamedImage] scaledToSize:CGSizeMake(210, 210)];
    } else {
        self.iconView.image = [UIImage imageNamed:@"mookIcon"];
    }
}

- (void)setInfoModel:(CLInfoModel *)infoModel {
    _infoModel = infoModel;
    self.titleLabel.text = infoModel.name;
}

- (void)setEffectModel:(CLEffectModel *)effectModel {
    _effectModel = effectModel;
    
    if (self.imageName == nil) {
        self.imageName = effectModel.image;
    }
    
    if (self.isStarred) {
        self.contentLabel.text = [NSString stringWithFormat:@"★%@", effectModel.effect];
    } else {
        self.contentLabel.text = effectModel.effect;
        
    }
    
}

- (void)setPrepModelList:(NSMutableArray *)prepModelList {
    _prepModelList = prepModelList;
    
    if (self.imageName == nil) {
        
        for (CLPrepModel *prepModel in prepModelList) {
            if (prepModel.isWithImage) {
                
                self.imageName = prepModel.image;
                break;
            }
        }
    }
    
}

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    self.colorView.backgroundColor = kCellBgColor;
    self.colorView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.colorView.layer.borderWidth = 0.5;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //    [self.iconView showBorder];
    
    //    self.titleLabel.numberOfLines = 0;
    //    self.titleLabel.font = kBoldFontSys14;
    //    self.titleLabel.textColor = [UIColor blackColor];
    
    //    [self.iconView showBorder];
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
