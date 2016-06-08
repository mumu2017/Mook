//
//  CLMediaDisplayCell.h
//  Mook
//
//  Created by 陈林 on 15/12/12.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLMediaView, AVPlayer;

@interface CLOneLabelMediaDisplayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *mediaContainer;

@property (nonatomic, strong) CLMediaView *mediaView;

@property (nonatomic) AVPlayer *player;

@property (nonatomic, copy) NSString *videoName;

+ (instancetype)oneLabelMediaDisplayCell;

@end
