//
//  CLTextAudioCell.h
//  Mook
//
//  Created by 陈林 on 16/6/27.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLTextAudioCell : UITableViewCell


typedef void (^AudioBlock)(NSString *audioName);

@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIButton *audioButton;

@property (strong, nonatomic) NSString *audioName;

@property (nonatomic, assign) BOOL isWithAudio;

@property (strong, nonatomic) AudioBlock audioBlock;

- (void)setAttributedString:(NSAttributedString *)text audioName:(NSString *)audioName audioBlock:(AudioBlock)audioBlock;


@end
