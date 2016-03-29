//
//  CLTextInputCell.h
//  Mook
//
//  Created by 陈林 on 16/3/14.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLNewEntryVC.h"
@interface CLTextInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

- (void)setEditingContentType:(EditingContentType)editingContentType;
@end
