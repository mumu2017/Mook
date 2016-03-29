//
//  CLTableBackView.h
//  Mook
//
//  Created by 陈林 on 16/1/1.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLTableBackView : UIView

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (instancetype)tableBackView;

@end
