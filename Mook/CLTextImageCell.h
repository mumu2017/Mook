//
//  CLTextImageCell.h
//  Mook
//
//  Created by 陈林 on 16/6/27.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLTextImageCell : UITableViewCell

typedef void (^ImageBlock)(NSString *imageName);
typedef void (^VideoBlock)(NSString *videoName);

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UIView *imageContainer;

@property (strong, nonatomic) UIButton *imageButton;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *videoName;

@property (nonatomic, assign) BOOL isWithVideo;

@property (nonatomic, assign) BOOL isWithImage;

@property (strong, nonatomic) ImageBlock imageBlock;
@property (strong, nonatomic) VideoBlock videoBlock;

- (void)setAttributedString:(NSAttributedString *)text imageName:(NSString *)imageName imageBlock:(ImageBlock)imageBlock videoName:(NSString *)videoName videoBlock:(VideoBlock)videoBlock;


@end
