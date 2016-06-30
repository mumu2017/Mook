//
//  CLListImageCell.m
//  Mook
//
//  Created by 陈林 on 15/12/25.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLNotesListCell.h"
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

@implementation CLNotesListCell

+ (instancetype)notesListCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"CLNotesListCell" owner:nil options:nil] lastObject];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.containerView.layer.cornerRadius = 4.0;

    self.titleLabel.textColor = [UIColor whiteColor];
    self.contentLabel.textColor = [UIColor whiteColor];
}

- (void)setModel:(id)modelUnknown {
    _model = modelUnknown;
    
    UIImage *image;
    NSString *title, *content, *time;
    
    if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
        CLShowModel *model = (CLShowModel *)modelUnknown;
        image = [model getThumbnail];
        title = [model getTitle];
        content = model.effectModel.effect;
        time = [NSString getDateString:model.date];
        
    } else if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
        CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
        image = [model getThumbnail];
        title = [model getTitle];
        content = model.effectModel.effect;
        time = [NSString getDateString:model.date];
        
    } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
        CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
        
        image = [model getThumbnail];
        title = [model getTitle];
        content = model.effectModel.effect;
        time = [NSString getDateString:model.date];
        
    } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
        CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
        image = [model getThumbnail];
        title = [model getTitle];
        content = model.effectModel.effect;
        time = [NSString getDateString:model.date];
        
    } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
        CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
        image = [model getThumbnail];
        title = [model getTitle];
        content = model.effectModel.effect;
        time = [NSString getDateString:model.date];
        
    } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
        CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
        image = nil;
        title = [model getTitle];
        content = model.effectModel.effect;
        time = [NSString getDateString:model.date];
    } else {
        return;
    }
    
    [self configureCellWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content time:(NSString *)time];
}

- (void)setModel:(id)modelUnknown utilityButtons:(NSArray *)rightButtons delegate:(id<SWTableViewCellDelegate>)delegate {
    
    _model = modelUnknown;
//    self.rightUtilityButtons = rightButtons;
//    self.delegate = delegate;
    
    UIImage *image;
    NSString *title, *content, *time;
    
    if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
        CLShowModel *model = (CLShowModel *)modelUnknown;
        image = [model getThumbnail];
        title = [model getTitle];
        content = model.effectModel.effect;
        time = [NSString getDateString:model.date];
        
    } else if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
        CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
        image = [model getThumbnail];
        title = [model getTitle];
        content = model.effectModel.effect;
        time = [NSString getDateString:model.date];
        
    } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
        CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
        
        image = [model getThumbnail];
        title = [model getTitle];
        content = model.effectModel.effect;
        time = [NSString getDateString:model.date];
        
    } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
        CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
        image = [model getThumbnail];
        title = [model getTitle];
        content = model.effectModel.effect;
        time = [NSString getDateString:model.date];
        
    } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
        CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
        image = [model getThumbnail];
        title = [model getTitle];
        content = model.effectModel.effect;
        time = [NSString getDateString:model.date];
        
    } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
        CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
        image = nil;
        title = [model getTitle];
        content = model.effectModel.effect;
        time = [NSString getDateString:model.date];
    } else {
        return;
    }

    [self configureCellWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content time:(NSString *)time];
}

- (void)configureCellWithImage:(UIImage *)image title:(NSString *)title content:(NSString *)content time:(NSString *)time {
    
    [self setTitle:title];
    [self setContent:content];
    [self setTime:time];
    [self setImage:image];

}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    if (image) {
        self.letterLabel.text = @"";
        self.letterLabel.hidden = YES;
        self.iconView.hidden = NO;
        self.iconView.image = image;
    } else {
        
//        UIImage *colorImage = [UIImage createImageWithColor:kAppThemeColor];
//        self.iconView.image = colorImage;
        self.iconView.hidden = YES;
        self.letterLabel.hidden = NO;
        self.containerView.backgroundColor = [UIColor darkGrayColor];
        NSString *firstLetter = [self.title substringToIndex:1];
        
        firstLetter = [firstLetter uppercaseString];
        self.letterLabel.text = firstLetter;
    }
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
