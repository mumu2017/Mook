//
//  CLTagChooseVC.h
//  Mook
//
//  Created by 陈林 on 16/1/2.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLTagChooseVC;

@protocol CLTagChooseVCDelegate <NSObject>

@optional
- (void)tagChooseVC:(CLTagChooseVC *)tagChooseVC didSelectTag:(NSString *)tag;

@end

@interface CLTagChooseVC : UITableViewController

@property (nonatomic, strong) NSMutableArray *tagChooseList;

@property (nonatomic, assign) EditingContentType editingContentType;

@property (nonatomic, weak) id<CLTagChooseVCDelegate> delegate;
@end
