//
//  CLOneLabelImageDisplayCell.h
//  Mook
//
//  Created by 陈林 on 15/12/12.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLOneLabelImageDisplayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UIView *imageContainer;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

- (void)setImageWithName:(NSString *)imageName;
- (void)setImageWithVideoName:(NSString *)videoName;

@end
