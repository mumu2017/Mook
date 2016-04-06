//
//  CLPropChooseVC.h
//  Mook
//
//  Created by 陈林 on 16/4/6.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLPropChooseVC, CLPropObjModel;

@protocol CLPropChooseVCDelegate <NSObject>

@optional
- (void)propChooseVC:(CLPropChooseVC *)propChooseVC didSelectProp:(CLPropObjModel *)prop;

@end

@interface CLPropChooseVC : UITableViewController

@property (nonatomic, weak) id<CLPropChooseVCDelegate> delegate;

@end
