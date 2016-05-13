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

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, copy) NSString *iconName;

@property (nonatomic, copy) NSString *date;
@property (nonatomic, strong) NSMutableArray <NSString*> *tags;

+ (instancetype)listImageCell;
- (void)setTitle:(NSString *)title content:(NSAttributedString *)content;

@end
