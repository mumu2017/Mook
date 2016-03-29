//
//  CLTagChooseNavVC.h
//  Mook
//
//  Created by 陈林 on 16/1/2.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTagChooseVC.h"

@class CLTagChooseNavVC;

@protocol CLTagChooseNavVCDelegate <NSObject>

@optional
- (void)tagChooseNavVC:(CLTagChooseNavVC *)tagChooseNavVC didSelectTag:(NSString *)tag;

@end

@interface CLTagChooseNavVC : UINavigationController

@property (nonatomic, assign) EditingContentType editingContentType;
@property (nonatomic, weak) id<CLTagChooseNavVCDelegate> navDelegate;
@end
