//
//  UITableView+Tools.m
//  Deck
//
//  Created by 陈林 on 15/11/6.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "UITableView+Tools.h"

@implementation UITableView (Tools)

- (void) reloadCell:(UITableViewCell *)cell {
    NSIndexPath *path = [self indexPathForCell:cell];
    [self reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) reloadCell:(UITableViewCell *)cell withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *path = [self indexPathForCell:cell];
    [self reloadRowsAtIndexPaths:@[path] withRowAnimation:animation];
}


@end
