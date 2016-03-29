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

@interface CLListImageCell : SWTableViewCell
//
//@property (weak, nonatomic) IBOutlet UIButton *Btn1;
//@property (weak, nonatomic) IBOutlet UIButton *Btn2;
//
//@property (weak, nonatomic) IBOutlet UILabel *Tag1;
//@property (weak, nonatomic) IBOutlet UILabel *Tag2;
//@property (weak, nonatomic) IBOutlet UILabel *Tag3;

@property (nonatomic, assign) NSInteger vidCnt;
@property (nonatomic, assign) NSInteger picCnt;
@property (weak, nonatomic) IBOutlet UIImageView *iconType;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//@property (nonatomic, assign) BOOL isStarred;

//@property (nonatomic, strong) CLInfoModel *infoModel;
//@property (nonatomic, strong) CLEffectModel *effectModel;
//@property (nonatomic, strong) NSMutableArray <CLPrepModel*> *prepModelList;

@property (nonatomic, copy) NSString *iconName;

@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSMutableArray <NSString*> *tags;

+ (instancetype)listImageCell;
- (void)setTitle:(NSString *)title content:(NSAttributedString *)content;
@end
