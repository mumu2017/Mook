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

@property (weak, nonatomic) IBOutlet UIScrollView *imageContainer;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

- (void)setImageWithName:(NSString *)imageName;
- (void)setImageWithVideoName:(NSString *)videoName;

@end
