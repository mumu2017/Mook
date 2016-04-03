//
//  CLRoutineChooseVC.h
//  Mook
//
//  Created by 陈林 on 16/3/31.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLRoutineModel, CLRoutineChooseVC;

@protocol CLRoutineChooseVCDelegate <NSObject>

@optional
- (void)routineChooseVC:(CLRoutineChooseVC *)routineChooseVC didPickRoutines:(NSArray *)pickedRoutines;


@end

@interface CLRoutineChooseVC : UITableViewController

@property (nonatomic, weak) id<CLRoutineChooseVCDelegate> delegate;

@end
