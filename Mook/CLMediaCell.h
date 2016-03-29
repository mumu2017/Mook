//
//  CLMediaCell.h
//  Mook
//
//  Created by 陈林 on 15/12/10.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLMediaView;

@interface CLMediaCell : UITableViewCell

@property (nonatomic, strong) CLMediaView *mediaView;
@property (nonatomic, weak) IBOutlet UIView *mediaContainer;

+ (instancetype)mediaCell;

@end
