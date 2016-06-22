//
//  CLAddView.h
//  Mook
//
//  Created by 陈林 on 16/6/15.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFPaperButton.h"

@interface CLAddView : UIButton

//@property (strong, nonatomic) UIButton *coverBtn;
@property (strong, nonatomic) BFPaperButton *ideaBtn;
@property (strong, nonatomic) BFPaperButton *showBtn;
@property (strong, nonatomic) BFPaperButton *routineBtn;
@property (strong, nonatomic) BFPaperButton *sleightBtn;
@property (strong, nonatomic) BFPaperButton *propBtn;
@property (strong, nonatomic) BFPaperButton *linesBtn;

- (void) initSubViews;
- (void) updateColor:(UIColor *)color;

@end
