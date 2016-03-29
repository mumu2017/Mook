//
//  CLMediaCell.m
//  Mook
//
//  Created by 陈林 on 15/12/10.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLMediaCell.h"
#import "CLMediaView.h"

@interface CLMediaCell()

@end

@implementation CLMediaCell

+ (instancetype)mediaCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"CLMediaCell" owner:nil options:nil] lastObject];
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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
