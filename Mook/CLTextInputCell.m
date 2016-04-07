//
//  CLTextInputCell.m
//  Mook
//
//  Created by 陈林 on 16/3/14.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLTextInputCell.h"

@implementation CLTextInputCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.font = kBoldFontSys16;
    self.tintColor = kMenuBackgroundColor;

}

- (void)setEditingContentType:(EditingContentType)editingContentType {
    
    NSString *title;
    
    switch (editingContentType) {
        case kEditingContentTypeRoutine:
            
            title = NSLocalizedString(@"流程标题", nil);
            
            break;
        case kEditingContentTypeIdea:
            
            title = NSLocalizedString(@"灵感标题", nil);
            
            break;
        case kEditingContentTypeSleight:
            
            title = NSLocalizedString(@"技巧标题", nil);
            
            break;
        case kEditingContentTypeProp:
            
            title = NSLocalizedString(@"道具标题", nil);
            
            break;
        case kEditingContentTypeLines:
            
            title = NSLocalizedString(@"台词标题", nil);
            
            break;
        default:
            break;
    }
    
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
