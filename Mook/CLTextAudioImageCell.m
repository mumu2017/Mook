//
//  CLTextAudioImageCell.m
//  Mook
//
//  Created by 陈林 on 16/6/27.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLTextAudioImageCell.h"
#import "FDWaveformView.h"

@implementation CLTextAudioImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.backgroundColor = kCellBgColor;
        [self initSubviews];

    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kCellBgColor;
        self.contentView.clipsToBounds = YES;
        [self initSubviews];
        
    }
    return self;
}

- (void)initSubviews {
    
    [self contentLabel];
    [self audioButton];
    [self waveformView];
    [self imageContainer];
    [self iconView];
    [self imageButton];
}

- (void)loadCellWithAudioAndImage {
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.imageButton setImage:nil forState:UIControlStateNormal];
    [self.imageButton setImage:nil forState:UIControlStateHighlighted];
    
    UIImage *image = [_imageName getNamedImage];
    self.iconView.image = image;
    
    [self.audioButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
    
    [self.imageButton addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];

}


- (void)loadCellWithAudioAndVideo {
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.imageButton setImage:[UIImage imageNamed:@"PlayButtonOverlayLarge"] forState:UIControlStateNormal];
    [self.imageButton setImage:[UIImage imageNamed:@"PlayButtonOverlayLargeTap"] forState:UIControlStateHighlighted];
    
    UIImage *image = [_videoName getNamedVideoFrame];
    self.iconView.image = image;
    
    
    [self.audioButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
    
    [self.imageButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
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

- (UIView *)imageContainer {
    if (!_imageContainer) {
        _imageContainer = [[UIView alloc] init];
        [self.contentView addSubview:_imageContainer];
        
        [_imageContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.waveformView.mas_bottom).offset(30);
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
        
        _imageContainer.backgroundColor = [UIColor blackColor];
    }
    return _imageContainer;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        [self.imageContainer addSubview:_iconView];
        
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imageContainer);
            make.height.equalTo(self.imageContainer.mas_width).multipliedBy(0.75);
        }];
        _iconView.clipsToBounds = YES;
    }
    return _iconView;
}

- (UIButton *)imageButton {
    if (!_imageButton) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.imageContainer addSubview:_imageButton];
        [_imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imageContainer);
        }];
        
        _imageButton.backgroundColor = [UIColor clearColor];
    }
    return _imageButton;
}


- (void)setAttributedString:(NSAttributedString *)text audioName:(NSString *)audioName audioBlock:(AudioBlock)audioBlock imageName:(NSString *)imageName imageBlock:(ImageBlock)imageBlock videoName:(NSString *)videoName videoBlock:(VideoBlock)videoBlock
{
    _audioName = audioName;
    _audioBlock = audioBlock;
    
    _imageName = imageName;
    _imageBlock = imageBlock;
    
    _videoName = videoName;
    _videoBlock = videoBlock;
    
    self.contentLabel.attributedText = text;
    
    NSInteger duration = [audioName getDurationForNamedAudio];
    
    [self.audioButton setTitle:[NSString stringWithFormat:@"Tap to play (%.2ld:%.2ld)", (long)duration/60, (long)duration%60] forState:UIControlStateNormal];
    
    self.waveformView.audioURL = [NSURL fileURLWithPath:[audioName getNamedAudio]];
    
    if (self.isWithAudio && !self.isWithImage && self.isWithVideo) {
        
        [self loadCellWithAudioAndVideo];

    } else if (self.isWithAudio && self.isWithImage && !self.isWithVideo) {
        
        [self loadCellWithAudioAndImage];
    }
}

- (void)playAudio {
    _audioBlock(_audioName);
}

- (void)playVideo {
    _videoBlock(_videoName);
}

- (void)showImage {
    _imageBlock(_imageName);
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = kCellBgColor;
        self.contentView.clipsToBounds = YES;
        
    }
    return self;
}

- (BOOL)isWithVideo {
    
    if (self.videoName.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString videoPath] stringByAppendingPathComponent:self.videoName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

- (BOOL)isWithImage {
    
    if (self.imageName.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString imagePath] stringByAppendingPathComponent:self.imageName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
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
