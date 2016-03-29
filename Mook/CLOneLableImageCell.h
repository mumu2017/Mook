//
//  CLOneLableImageCell.h
//  Mook
//
//  Created by 陈林 on 15/12/29.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLInfoModel, CLEffectModel, CLPrepModel;

@interface CLOneLableImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, assign) BOOL isStarred;

@property (nonatomic, strong) CLInfoModel *infoModel;
@property (nonatomic, strong) CLEffectModel *effectModel;
@property (nonatomic, strong) NSMutableArray <CLPrepModel*> *prepModelList;

@property (nonatomic, copy) NSString *imageName;
//@property (nonatomic, copy) NSString *date;

+ (instancetype)oneLabelImageCell;


@end
