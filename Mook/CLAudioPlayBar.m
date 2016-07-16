//
//  CLAuidoPlayBar.m
//  Mook
//
//  Created by 陈林 on 16/7/15.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLAudioPlayBar.h"
#import "MASonry.h"

@interface CLAudioPlayBar()

@property (strong, nonatomic) UIBarButtonItem *_playItem;
@property (strong, nonatomic) UIBarButtonItem *_pauseItem;
@property (strong, nonatomic) UIBarButtonItem *_stopItem;

@property (strong, nonatomic) UIBarButtonItem *_iconItem;

@end

@implementation CLAudioPlayBar

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    

}

- (UIProgressView *)progressView {
    
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        [self addSubview:_progressView];
        
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@2);
        }];
    }
    
    return _progressView;
}

@end
