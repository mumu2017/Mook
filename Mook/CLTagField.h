//
//  CLTagField.h
//  Mook
//
//  Created by 陈林 on 15/12/15.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMTagField;
@interface CLTagField : UIView

@property (weak, nonatomic) IBOutlet SMTagField *tagField;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet UIImageView *tagIcon;

+ (instancetype)tagField;

@end
