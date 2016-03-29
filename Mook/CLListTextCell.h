//
//  CLListTextCell.h
//  Mook
//
//  Created by 陈林 on 15/12/25.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

//#import <SWTableViewCell/SWTableViewCell.h>
@class CLInfoModel, CLEffectModel, CLPrepModel;

@interface CLListTextCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconType;

@property (nonatomic, copy) NSString *iconName;

//
//@property (weak, nonatomic) IBOutlet UILabel *Tag1;
//@property (weak, nonatomic) IBOutlet UILabel *Tag2;
//@property (weak, nonatomic) IBOutlet UILabel *Tag3;

//@property (nonatomic, assign) BOOL isStarred;

@property (nonatomic, strong) CLInfoModel *infoModel;
@property (nonatomic, strong) CLEffectModel *effectModel;

//@property (nonatomic, strong) NSMutableArray <CLPrepModel*> *prepModelList;

@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSMutableArray <NSString*> *tags;

+ (instancetype)listTextCell;
- (void)setTitle:(NSString *)title content:(NSAttributedString *)content;
@end
