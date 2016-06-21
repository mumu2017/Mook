//
//  CLRecorderNavVC.h
//  Mook
//
//  Created by 陈林 on 16/6/22.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completionBlock)(NSURL *videoURL, UIImage *image);

@interface CLRecorderNavVC : UINavigationController

@property (strong, nonatomic) completionBlock block;

@end
