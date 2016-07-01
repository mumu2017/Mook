//
//  CLTextAudioCell.m
//  Mook
//
//  Created by 陈林 on 16/6/27.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLTextAudioCell.h"
#import "FDWaveformView.h"

@implementation CLTextAudioCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.backgroundColor = kCellBgColor;
        [self contentLabel];
        [self audioButton];
        [self waveformView];

    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kCellBgColor;
        self.contentView.clipsToBounds = YES;
        
        [self contentLabel];
        [self audioButton];
        [self waveformView];
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
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-10);
        }];
        _contentLabel.numberOfLines = 0;
        
    }
    
    return _contentLabel;
}

- (UIButton *)audioButton {
    if (!_audioButton) {
        _audioButton = [[UIButton alloc] init];
        [self.waveformView addSubview:_audioButton];
        [_audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self.waveformView);
            
        }];
    }
    
    _audioButton.titleLabel.font = kFontSys14;
    
    [_audioButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _audioButton.backgroundColor = [UIColor clearColor];
    
    return _audioButton;
}

- (FDWaveformView *)waveformView {
    if (!_waveformView) {
        _waveformView = [[FDWaveformView alloc] init];
        [self.contentView addSubview:_waveformView];
        
        [_waveformView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(20);
            make.left.right.equalTo(self.contentLabel);
            make.bottom.equalTo(self.contentView).offset(-20);
            make.height.equalTo(@44);
        }];
        
        _waveformView.wavesColor = [UIColor whiteColor];
        _waveformView.backgroundColor = [UIColor grayColor];
        _waveformView.doesAllowScroll = NO;
        _waveformView.doesAllowScrubbing = NO;
        _waveformView.doesAllowStretch = NO;
        _waveformView.layer.cornerRadius = 1.0;
        
    }
    return _waveformView;
}

- (void)setAttributedString:(NSAttributedString *)text audioName:(NSString *)audioName audioBlock:(AudioBlock)audioBlock
{
    _audioName = audioName;
    _audioBlock = audioBlock;
    
    
    self.contentLabel.attributedText = text;
    
    [self.audioButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *duration = [audioName getDurationForNamedAudio];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.audioButton setTitle:duration forState:UIControlStateNormal];
            
        });
    });
    
    self.waveformView.audioURL = [NSURL fileURLWithPath:[audioName getNamedAudio]];
    
}

- (void)playAudio {
    _audioBlock(_audioName);
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = kCellBgColor;
        self.contentView.clipsToBounds = YES;
        
    }
    return self;
}


- (BOOL)isWithAudio {
    if (self.audioName.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString audioPath] stringByAppendingPathComponent:self.audioName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = kCellBgColor;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.backgroundColor = kCellBgColor;
        
    }
    return self;
    
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    
    self = [super awakeAfterUsingCoder:aDecoder];
    if (self) {
        self.backgroundColor = kCellBgColor;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
