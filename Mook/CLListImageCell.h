//
//  CLListImageCell.h
//  Mook
//
//  Created by 陈林 on 15/12/25.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

//#import <SWTableViewCell/SWTableViewCell.h>
@class SMTag;
@class CLInfoModel, CLEffectModel, CLPrepModel;
@class CLShowModel, CLRoutineModel, CLIdeaObjModel, CLSleightObjModel, CLPropObjModel, CLLinesObjModel;

@interface CLListImageCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *time;

@property (strong, nonatomic) id model;

@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSMutableArray <NSString*> *tags;

+ (instancetype)listImageCell;

- (void)setModel:(id)model utilityButtons:(NSArray *)rightButtons delegate:(id<SWTableViewCellDelegate>)delegate;

@end
