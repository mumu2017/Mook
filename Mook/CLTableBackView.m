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



@end
