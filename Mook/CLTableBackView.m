//
//  CLTableBackView.m
//  Mook
//
//  Created by 陈林 on 16/1/1.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import "CLTableBackView.h"

@implementation CLTableBackView

+ (instancetype)tableBackView {
    return [[[NSBundle mainBundle] loadNibNamed:@"CLTableBackView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentLabel.text = NSLocalizedString(@"您还没有添加任何内容", nil);
}


@end
