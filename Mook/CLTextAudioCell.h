//
//  CLTextAudioCell.h
//  Mook
//
//  Created by 陈林 on 16/6/27.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CLAudioView.h"

@interface CLTextAudioCell : UITableViewCell

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) CLAudioView *audioView;

- (void)setAttributedString:(NSAttributedString *)text audioName:(NSString *)audioName playBlock:(PlayBlock)playBlock audioBlock:(AudioBlock)audioBlock;


@end
