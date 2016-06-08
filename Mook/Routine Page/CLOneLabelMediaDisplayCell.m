//
//  CLMediaDisplayCell.m
//  Mook
//
//  Created by 陈林 on 15/12/12.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLOneLabelMediaDisplayCell.h"
#import "CLMediaView.h"

@interface CLOneLabelMediaDisplayCell()



@end

@implementation CLOneLabelMediaDisplayCell

+ (instancetype)oneLabelMediaDisplayCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"oneLabelMediaDisplayCell" owner:nil options:nil] lastObject];
}

- (CLMediaView *)mediaView {
    
    if (_mediaView == nil) {
        _mediaView = [CLMediaView mediaView];
        [self.mediaContainer addSubview:_mediaView];
        _mediaView.frame = self.mediaContainer.bounds;
    }
    
    return _mediaView;
}

- (void)awakeFromNib {
    [self mediaView];
}

- (void)setPlayer:(AVPlayer *)player {
    
    _player = player;
    [self.mediaView setPlayer:player];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
