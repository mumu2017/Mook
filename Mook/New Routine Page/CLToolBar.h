//
//  CLPerformToolBar.h
//  Mook
//
//  Created by 陈林 on 15/11/16.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLToolBar;

@protocol CLToolBarDelegate <NSObject>

// 添加按钮代理方法
@optional
- (void)toolBar:(CLToolBar *)toolBar didClickButton:(UIButton *)button;

@end

@interface CLToolBar : UIToolbar

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *previousButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic, weak) id<CLToolBarDelegate> tbDelegate;


@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *videoName;

// 工厂方法
+ (instancetype)toolBar;

- (void)setButtonImage:(UIImage *)image;

// 设置imageName与videoName之后,toolBar会自动设置缩略图
- (void)setImageName:(NSString *)imageName;
- (void)setVideoName:(NSString *)videoName;

- (void)setButtonImageWithImageName:(NSString *)imageName;
- (void)setButtonImageWithVideoName:(NSString *)videoName;
@end
