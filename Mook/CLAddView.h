//
//  CLAddView.h
//  Mook
//
//  Created by 陈林 on 16/6/15.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLAddView : UIButton

//@property (strong, nonatomic) UIButton *coverBtn;
@property (strong, nonatomic) UIButton *ideaBtn;
@property (strong, nonatomic) UIButton *showBtn;
@property (strong, nonatomic) UIButton *routineBtn;
@property (strong, nonatomic) UIButton *sleightBtn;
@property (strong, nonatomic) UIButton *propBtn;
@property (strong, nonatomic) UIButton *linesBtn;

- (void) initSubViews;
- (void) updateColor:(UIColor *)color;

@end
