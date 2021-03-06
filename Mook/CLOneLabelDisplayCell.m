//
//  CLOneLabelDisplayCell.m
//  Mook
//
//  Created by 陈林 on 15/12/12.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLOneLabelDisplayCell.h"

@implementation CLOneLabelDisplayCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.clipsToBounds = YES;

        self.backgroundColor = kCellBgColor;
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kCellBgColor;
        self.contentView.clipsToBounds = YES;


    }
    return self;
}

- (void)loadSubviewsWithTextOnly {
    
    if (_imageContainer) {
        
        [self.imageContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@0);
        }];

    }
    
    if (_audioButton) {
        [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@0);
        }];
    }
}

- (void)loadSubviewsWithAudioOnly {
    
    [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentLabel);
        make.right.equalTo(self.contentLabel);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@44);
    }];
}

- (void)loadSubviewsWithImageOnly {
    
    [self.imageContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.imageButton setImage:nil forState:UIControlStateNormal];
    [self.imageButton setImage:nil forState:UIControlStateHighlighted];
    
    UIImage *image = [_imageName getNamedImage];
    self.iconView.image = image;
}

- (void)loadSubviewsWithVideoOnly {
    
    [self.imageContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.imageButton setImage:[UIImage imageNamed:@"PlayButtonOverlayLarge"] forState:UIControlStateNormal];
    [self.imageButton setImage:[UIImage imageNamed:@"PlayButtonOverlayLargeTap"] forState:UIControlStateHighlighted];
    
    UIImage *image = [_videoName getNamedVideoFrame];
    self.iconView.image = image;

}

- (void)loadSubviewsWithAudioAndImage {
    
    [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentLabel);
        make.right.equalTo(self.contentLabel);
        make.height.equalTo(@44);
    }];
    
    [self.imageContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.audioButton.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.imageButton setImage:nil forState:UIControlStateNormal];
    [self.imageButton setImage:nil forState:UIControlStateHighlighted];
    
    UIImage *image = [_imageName getNamedImage];
    self.iconView.image = image;

}


- (void)loadSubviewsWithAudioAndVideo {
    
    [self.audioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentLabel);
        make.right.equalTo(self.contentLabel);
        make.height.equalTo(@44);
    }];
    
    [self.imageContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.audioButton.mas_bottom).offset(20);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.imageButton setImage:[UIImage imageNamed:@"PlayButtonOverlayLarge"] forState:UIControlStateNormal];
    [self.imageButton setImage:[UIImage imageNamed:@"PlayButtonOverlayLargeTap"] forState:UIControlStateHighlighted];
    
    UIImage *image = [_videoName getNamedVideoFrame];
    self.iconView.image = image;
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
        [self.contentView addSubview:_audioButton];

    }
    _audioButton.backgroundColor = [UIColor redColor];
    return _audioButton;
}

- (UIView *)imageContainer {
    if (!_imageContainer) {
        _imageContainer = [[UIView alloc] init];
        [self.contentView addSubview:_imageContainer];
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

- (void)setText:(NSString *)text audioName:(NSString *)audioName {
    
    self.contentLabel.text = text;
    if (audioName) {
        [self audioButton];
    }
}

- (void)setAttributedString:(NSAttributedString *)text audioName:(NSString *)audioName {
    
    self.contentLabel.attributedText = text;
    if (audioName) {
        [self audioButton];
        
    }
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

    if (self.isWithAudio && !self.isWithImage && !self.isWithVideo) {
        
        [self loadSubviewsWithAudioOnly];
        
        [self.audioButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (self.isWithAudio && self.isWithImage && !self.isWithVideo) {
        
        [self loadSubviewsWithAudioAndImage];
        
        [self.audioButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
        
        [self.imageButton addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (self.isWithAudio && !self.isWithImage && self.isWithVideo) {
        
        [self loadSubviewsWithAudioAndVideo];
        
        [self.audioButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
        
        [self.imageButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (!self.isWithAudio && self.isWithImage && !self.isWithVideo) {
        
        [self loadSubviewsWithImageOnly];
        
        [self.imageButton addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];

    } else if (!self.isWithAudio && !self.isWithImage && self.isWithVideo) {
        
        [self loadSubviewsWithVideoOnly];
        
        [self.imageButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (!self.isWithAudio && !self.isWithImage && !self.isWithVideo) {
        
        [self loadSubviewsWithTextOnly];
        
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
