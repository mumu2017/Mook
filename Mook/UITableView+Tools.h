//
//  UITableView+Tools.h
//  Deck
//
//  Created by 陈林 on 15/11/6.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Tools)

- (void) reloadCell:(UITableViewCell *)cell withRowAnimation:(UITableViewRowAnimation)animation;

- (void) reloadCell:(UITableViewCell *)cell;
//
//- (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;

@end
