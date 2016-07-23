//
//  CLTextAudioCell.m
//  Mook
//
//  Created by 陈林 on 16/6/27.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLTextAudioCell.h"

@implementation CLTextAudioCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.backgroundColor = kCellBgColor;

        [self contentLabel];
        [self audioView];
        
        self.audioView.audioPlayMode = kAudioPlayModeNotLoaded;

    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kCellBgColor;
        self.contentView.clipsToBounds = YES;
        
        [self contentLabel];
        [self audioView];
        
        self.audioView.audioPlayMode = kAudioPlayModeNotLoaded;
    }
    return self;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(20);
//            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-10);
        }];
        _contentLabel.numberOfLines = 0;
        
    }
    
    return _contentLabel;
}

- (CLAudioView *)audioView {
    
    if (!_audioView) {
        _audioView = [[CLAudioView alloc] init];
        [self.contentView addSubview:_audioView];
        [_audioView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.centerY.equalTo(self.contentLabel);
            make.left.equalTo(self.contentLabel.mas_right);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    
    return _audioView;
}

- (void)setAttributedString:(NSAttributedString *)text audioName:(NSString *)audioName playBlock:(PlayBlock)playBlock audioBlock:(AudioBlock)audioBlock
{
    
    self.contentLabel.attributedText = text;
    self.audioView.audioName = audioName;
    self.audioView.audioBlock = audioBlock;
    self.audioView.playBlock = playBlock;
    
}


- (instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = kCellBgColor;
        self.contentView.clipsToBounds = YES;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
