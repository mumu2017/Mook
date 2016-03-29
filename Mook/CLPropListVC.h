//
//  CLPropListVC.h
//  Mook
//
//  Created by 陈林 on 15/11/20.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLPropListVC, CLPropObjModel;

@protocol CLPropListVCDelegate <NSObject>

@optional
- (void)propListVC:(CLPropListVC *)propListVC didSelectProp:(CLPropObjModel *)prop;

@end

@interface CLPropListVC : UITableViewController

@property (nonatomic, strong) NSMutableArray <CLPropObjModel*> *propObjModelList;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, assign) BOOL isSelectingProp;

@property (nonatomic, weak) id<CLPropListVCDelegate> delegate;

- (void)addNewProp;

@end
