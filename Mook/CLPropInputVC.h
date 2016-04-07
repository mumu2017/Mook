//
//  CLPropInputVC.h
//  Mook
//
//  Created by 陈林 on 15/12/8.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLPropModel, CLPropInputVC;

@protocol CLPropInputVCDelegate <NSObject>

@optional

- (void) propInputVCAddProp:(CLPropInputVC *)propInputVC;

- (void) propInputVCDeleteProp:(CLPropInputVC *)propInputVC;

@end

@interface CLPropInputVC : UITableViewController

@property (nonatomic, strong) CLPropModel *propModel;

@property (nonatomic, weak) id<CLPropInputVCDelegate> delegate;

@property (nonatomic, assign) BOOL isEditingExistingProp;
@end
