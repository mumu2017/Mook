//
//  CLPropChooseNavVC.h
//  Mook
//
//  Created by 陈林 on 16/1/2.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLPropChooseNavVC, CLPropObjModel;

@protocol CLPropChooseNavVCDelegate <NSObject>

@optional
- (void)propChooseNavVC:(CLPropChooseNavVC *)propChooseNavVC didSelectProp:(CLPropObjModel *)prop;

@end

@interface CLPropChooseNavVC : UINavigationController

@property (nonatomic, weak) id<CLPropChooseNavVCDelegate> navDelegate;

@end
