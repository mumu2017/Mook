//
//  CLListImageCell.m
//  Mook
//
//  Created by 陈林 on 15/12/25.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLListImageCell.h"
#import "CLInfoModel.h"
#import "CLEffectModel.h"
#import "CLPrepModel.h"
#import "SMTag.h"

#import "CLShowModel.h"
#import "CLIdeaObjModel.h"
#import "CLRoutineModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"

#import "UIImage+Color.h"
#import "MASonry.h"

@implementation CLListImageCell

+ (instancetype)listImageCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"CLListImageCell" owner:nil options:nil] lastObject];
}

//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//
//
//}

- (void)setModel:(id)modelUnknown utilityButtons:(NSArray *)rightButtons delegate:(id<SWTableViewCellDelegate>)delegate {
    
    _model = modelUnknown;
    self.rightUtilityButtons = rightButtons;
    self.delegate = delegate;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *image;
        NSString *type, *title, *content, *time;
        
        if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
            CLShowModel *model = (CLShowModel *)modelUnknown;
            image = [model getThumbnail];
            type = kDefaultTitleShow;
            title = [model getTitle];
            content = model.effectModel.effect;
            time = [NSString getDateString:model.date];
            
        } else if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
            CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
            type = kDefaultTitleIdea;
            image = [model getThumbnail];
            title = [model getTitle];
            content = model.effectModel.effect;
            time = [NSString getDateString:model.date];
            
        } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
            CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
            type = kDefaultTitleRoutine;
            image = [model getThumbnail];
            title = [model getTitle];
            content = model.effectModel.effect;
            time = [NSString getDateString:model.date];
            
        } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
            CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
            type = kDefaultTitleSleight;
            image = [model getThumbnail];
            title = [model getTitle];
            content = model.effectModel.effect;
            time = [NSString getDateString:model.date];
            
        } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
            CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
            type = kDefaultTitleProp;
            image = [model getThumbnail];
            title = [model getTitle];
            content = model.effectModel.effect;
            time = [NSString getDateString:model.date];
            
        } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
            CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
            type = kDefaultTitleLines;
            image = nil;
            title = [model getTitle];
            content = model.effectModel.effect;
            time = [NSString getDateString:model.date];
        } else {
            return;
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.iconView.image = image;
            self.titleLabel.text = title;
            self.contentLabel.text = content;
            self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",type, time];;

//            [self configureCellWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content time:(NSString *)time];
            
        });
    });
    
}

- (void)configureCellWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content time:(NSString *)time {
    
    [self setTitle:title];
    [self setContent:content];
    [self setTime:time];
    [self setImage:image];

}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.iconView.image = image;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
}

- (void)setTime:(NSString *)time {
    _time = time;
    self.timeLabel.text = time;
}

@end
