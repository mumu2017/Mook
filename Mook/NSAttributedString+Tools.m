//
//  NSAttributedString+Tools.m
//  Mook
//
//  Created by 陈林 on 16/4/5.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "NSAttributedString+Tools.h"

@implementation NSAttributedString (Tools)

// 设定文本段落格式
- (NSAttributedString *)styledString {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    [style setParagraphSpacing:10];

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, self.length)];
    
    return attrString;
}

@end
