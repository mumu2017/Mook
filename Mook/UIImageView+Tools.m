//
//  UIImageView+Tools.m
//  Mook
//
//  Created by 陈林 on 15/11/27.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "UIImageView+Tools.h"

@implementation UIImageView (Tools)


- (void) showBorder {
    self.layer.cornerRadius = 5.0;
    
}

- (void) hideBorder {
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.cornerRadius = 5.0;
    }];
}

@end
