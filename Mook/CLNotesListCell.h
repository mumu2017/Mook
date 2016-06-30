//
//  CLListImageCell.h
//  Mook
//
//  Created by 陈林 on 15/12/25.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

@class SMTag;
@class CLInfoModel, CLEffectModel, CLPrepModel;
@class CLShowModel, CLRoutineModel, CLIdeaObjModel, CLSleightObjModel, CLPropObjModel, CLLinesObjModel;

@interface CLNotesListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *letterLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *time;

@property (strong, nonatomic) id model;

@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSMutableArray <NSString*> *tags;

+ (instancetype)notesListCell;

- (void)setModel:(id)model utilityButtons:(NSArray *)rightButtons delegate:(id<SWTableViewCellDelegate>)delegate;

- (void)setModel:(id)model;

@end
