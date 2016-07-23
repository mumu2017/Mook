//
//  CLSizeListVC.m
//  Mook
//
//  Created by 陈林 on 16/5/10.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLSizeListVC.h"

#import "CLDataSizeTool.h"
#import "FCFileManager.h"

#import "CLShowModel.h"
#import "CLIdeaObjModel.h"
#import "CLRoutineModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"

#import "CLInfoModel.h"
#import "CLEffectModel.h"
#import "CLPropModel.h"
#import "CLPrepModel.h"
#import "CLPerformModel.h"

@interface CLSizeListVC ()

@property (nonatomic, strong) NSMutableArray *ideaObjModelList;
@property (nonatomic, strong) NSMutableArray *showModelList;
@property (nonatomic, strong) NSMutableArray *routineModelList;
@property (nonatomic, strong) NSMutableArray *sleightObjModelList;
@property (nonatomic, strong) NSMutableArray *propObjModelList;
@property (nonatomic, strong) NSMutableArray *linesObjModelList;

@end

@implementation CLSizeListVC

#pragma mark - 数据懒加载
-(NSMutableArray *)ideaObjModelList {
    if (!_ideaObjModelList) _ideaObjModelList = kDataListIdea;
    return _ideaObjModelList;
}

- (NSMutableArray *)showModelList {
    if (!_showModelList) _showModelList = kDataListShow;
    return _showModelList;
}

- (NSMutableArray *)routineModelList {
    if (!_routineModelList)  _routineModelList = kDataListRoutine;
    return _routineModelList;
}

-(NSMutableArray *)sleightObjModelList {
    if (!_sleightObjModelList) _sleightObjModelList = kDataListSleight;
    return _sleightObjModelList;
}

- (NSMutableArray *)propObjModelList {
    if (!_propObjModelList)  _propObjModelList = kDataListProp;
    return _propObjModelList;
}

- (NSMutableArray *)linesObjModelList {
    if (!_linesObjModelList)  _linesObjModelList = kDataListLines;
    return _linesObjModelList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (self.listType) {
        case kListTypeAll:
            self.navigationItem.title = @"";
            break;
            
        case kListTypeIdea:
            self.navigationItem.title = NSLocalizedString(@"想法", nil);
            break;
            
        case kListTypeShow:
            self.navigationItem.title = NSLocalizedString(@"演出", nil);
            break;
            
        case kListTypeRoutine:
            self.navigationItem.title = NSLocalizedString(@"流程", nil);
            break;
            
        case kListTypeSleight:
            self.navigationItem.title = NSLocalizedString(@"技巧", nil);
            break;
            
        case kListTypeProp:
            self.navigationItem.title = NSLocalizedString(@"道具", nil);
            break;
            
        case kListTypeLines:
            self.navigationItem.title = NSLocalizedString(@"台词", nil);
            break;
            
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number;
    switch (self.listType) {
        case kListTypeAll:
            number = 0;
            break;
            
        case kListTypeIdea:
            number = self.ideaObjModelList.count;
            break;
            
        case kListTypeShow:
            number = self.showModelList.count;
            break;
            
        case kListTypeRoutine:
            number = self.routineModelList.count;
            break;
            
        case kListTypeSleight:
            number = self.sleightObjModelList.count;
            break;
            
        case kListTypeProp:
            number = self.propObjModelList.count;
            break;
            
        case kListTypeLines:
            number = self.linesObjModelList.count;
            break;
            
        default:
            break;
    }
    
    return number;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"ID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    // Configure the cell...
    
    cell.detailTextLabel.text = NSLocalizedString(@"计算中...", nil);

    
    NSString *title;
    UIImage *image;
    
    switch (self.listType) {
        case kListTypeAll:
            break;
            
        case kListTypeIdea:
        {
            CLIdeaObjModel *model = self.ideaObjModelList[indexPath.row];
            image = [model getThumbnail];
            title = [model getTitle];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSString *sizeString = [FCFileManager sizeFormatted: [CLDataSizeTool sizeOfIdea:model]]; // 每次重新打开页面就重新计算一次文件尺寸
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                    
                });
            });

            break;
        }
            
        case kListTypeShow:
        {
            CLShowModel *model = self.showModelList[indexPath.row];
            image = [model getThumbnail];
            title = [model getTitle];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSString *sizeString = [FCFileManager sizeFormatted: [CLDataSizeTool sizeOfShow:model]]; // 每次重新打开页面就重新计算一次文件尺寸
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                    
                });
            });

            break;
        }
        case kListTypeRoutine:
        {
            CLRoutineModel *model = self.routineModelList[indexPath.row];
            image = [model getThumbnail];
            title = [model getTitle];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSString *sizeString = [FCFileManager sizeFormatted: [CLDataSizeTool sizeOfRoutine:model]]; // 每次重新打开页面就重新计算一次文件尺寸
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                    
                });
            });

            break;
        }
        case kListTypeSleight:
        {
            CLSleightObjModel *model = self.sleightObjModelList[indexPath.row];
            image = [model getThumbnail];
            title = [model getTitle];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSString *sizeString = [FCFileManager sizeFormatted: [CLDataSizeTool sizeOfSleight:model]]; // 每次重新打开页面就重新计算一次文件尺寸
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                    
                });
            });

            break;
        }
            
            
        case kListTypeProp:
        {
            CLPropObjModel *model = self.propObjModelList[indexPath.row];
            image = [model getThumbnail];
            title = [model getTitle];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSString *sizeString = [FCFileManager sizeFormatted: [CLDataSizeTool sizeOfProp:model]]; // 每次重新打开页面就重新计算一次文件尺寸
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                    
                });
            });
            break;
        }
        case kListTypeLines:
        {
            CLLinesObjModel *model = self.linesObjModelList[indexPath.row];
            title = [model getTitle];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                NSString *sizeString = [FCFileManager sizeFormatted: [CLDataSizeTool sizeOfLines:model]]; // 每次重新打开页面就重新计算一次文件尺寸
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    cell.detailTextLabel.text = sizeString; // 每次重新打开页面就重新计算一次文件尺寸
                    
                });
            });

            break;
        }
        default:
            break;
    }

    cell.imageView.image = image;
    cell.textLabel.text = title;

    return cell;
}



@end
