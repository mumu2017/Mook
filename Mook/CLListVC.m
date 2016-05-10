//
//  CLListvc.m
//  Mook
//
//  Created by 陈林 on 16/3/25.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLListVC.h"

#import "CLDataSaveTool.h"
#import "CLDataExportTool.h"
#import "CLNewEntryNavVC.h"
#import "CLNewShowNavVC.h"
#import "CLContentVC.h"
#import "CLShowVC.h"

#import "CLListCell.h"
#import "CLListTextCell.h"
#import "CLListImageCell.h"

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
//#import "CLNotesModel.h"

#import "JGActionSheet.h"
#import "CLTableBackView.h"


@interface CLListVC ()<SWTableViewCellDelegate, MBProgressHUDDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSMutableArray *tagList;

@property (nonatomic, strong) CLTableBackView *tableBackView;
@property (nonatomic, assign) EditingContentType editingContentType;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, copy) NSString *exportPath;

@end

@implementation CLListVC

#pragma mark - 模型数组懒加载

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

#pragma mark - 背景view懒加载
- (CLTableBackView *)tableBackView {
    if (!_tableBackView) {
        _tableBackView = [CLTableBackView tableBackView];
    }
    return _tableBackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = self.tableBackView;
    self.tableView.backgroundColor = [UIColor flatWhiteColor];
    self.tableView.rowHeight = kListCellHeight;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListImageCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLListTextCell"
                                               bundle:nil]
         forCellReuseIdentifier:kListTextCellID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeEntryIfWithTag:) name:kDeleteEntryNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeEntryIfWithTag:) name:kCancelEntryNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateDataNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tableView reloadData];

    [self.navigationController setToolbarHidden:YES];
}

- (void)update:(NSNotification *)noti {
    if (noti.object == self) return;
    
    [self.tableView reloadData];
}

- (void)removeEntryIfWithTag:(NSNotification *)noti {
    if (self.tag == nil) return;
    
    if (noti.object == nil) {
//        NSLog(@"error : cancel object == nil");
        return;
    } else {
        id modelUnknown = noti.object;
        if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
            CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
            
            if (self.ideaObjModelList != kDataListIdea) {
                [self.ideaObjModelList removeObject:model];
            }
            
        } else if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
            CLShowModel *model = (CLShowModel *)modelUnknown;

            if (self.showModelList != kDataListShow) {
                [self.showModelList removeObject:model];
            }
            
        } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
            CLRoutineModel *model = (CLRoutineModel *)modelUnknown;

            if (self.routineModelList != kDataListRoutine) {
                [self.routineModelList removeObject:model];
            }
            
        } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
            CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;

            if (self.sleightObjModelList != kDataListSleight) {
                [self.sleightObjModelList removeObject:model];
            }
            
        } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
            CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
            
            if (self.propObjModelList != kDataListProp) {
                [self.propObjModelList removeObject:model];
            }

        } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
            CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
            
            if (self.linesObjModelList != kDataListLines) {
                [self.linesObjModelList removeObject:model];
            }
        }
        
//        NSLog(@"cancel entry sucess!");
    }

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    self.tableBackView.hidden = !(number == 0);
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *iconName, *title;
    UIImage *image;
    NSAttributedString *content;
    
    switch (self.listType) {
        case kListTypeAll:
            break;
        
        case kListTypeIdea:
        {
            CLIdeaObjModel *model = self.ideaObjModelList[indexPath.row];
            image = [model getThumbnail];
            iconName = kIconNameIdea;
            title = [model getTitle];
            content = [model getContent];
            break;
        }
            
        case kListTypeShow:
        {
            CLShowModel *model = self.showModelList[indexPath.row];
            image = [model getThumbnail];
            iconName = kIconNameShow;
            title = [model getTitle];
            content = [model getContent];
            
            break;
        }
        case kListTypeRoutine:
        {
            CLRoutineModel *model = self.routineModelList[indexPath.row];
            image = [model getThumbnail];
            iconName = kIconNameRoutine;
            title = [model getTitle];
            content = [model getContent];
            break;
        }
        case kListTypeSleight:
        {
            CLSleightObjModel *model = self.sleightObjModelList[indexPath.row];
            image = [model getThumbnail];
            iconName = kIconNameSleight;
            title = [model getTitle];
            content = [model getContent];
            break;
        }

            
        case kListTypeProp:
        {
            CLPropObjModel *model = self.propObjModelList[indexPath.row];
            image = [model getThumbnail];
            iconName = kIconNameProp;
            title = [model getTitle];
            content = [model getContent];
            break;
        }
        case kListTypeLines:
        {
            CLLinesObjModel *model = self.linesObjModelList[indexPath.row];
            iconName = kIconNameLines;
            title = [model getTitle];
            content = [model getContent];
            break;
        }
        default:
            break;
    }
    
    if (image != nil) { // 如果返回图片,则表示模型中有图片或多媒体
        CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
        cell.iconView.image = image;
        cell.iconName = iconName;
        [cell setTitle:title content:content];
        
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        cell.backgroundColor = [UIColor flatWhiteColor];

        return cell;
        
    } else {
        CLListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kListTextCellID forIndexPath:indexPath];
        cell.iconName = iconName;
        [cell setTitle:title content:content];
        
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
        cell.backgroundColor = [UIColor flatWhiteColor];

        return cell;
    }
    
    return nil;
    
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];

    if (self.listType != kListTypeShow) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor flatGrayColorDark] icon:[UIImage imageNamed:@"iconAction"]];
    }
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor flatRedColor] icon:[UIImage imageNamed:@"iconBin"]];

    return rightUtilityButtons;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    if (index == 0) {
        
        if (self.listType == kListTypeShow) {
            // 演讲不可导出,所以只有删除按钮
            [self delete:path];
        } else {
            // 如果不是演讲, 则可导出
            [self exportWithIndexPath:path];

        }
        
    } else if (index == 1) {
        
        [self delete:path];
    }
    
    [cell hideUtilityButtonsAnimated:YES];
}

- (void)delete:(NSIndexPath *)path {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"提示: 删除内容后将无法恢复,确定要删除当前内容吗?", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self deleteEntryWithIndexPath:path];
            
        });
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    

}

- (void) deleteEntryWithIndexPath:(NSIndexPath *)path {
    switch (self.listType) {
        case kListTypeAll:
            break;
        
        case kListTypeIdea:
        {
            CLIdeaObjModel *model = self.ideaObjModelList[path.row];
            
            [CLDataSaveTool deleteIdea:model];
            
            [kDataListIdea removeObject:model];
            [kDataListAll removeObject:model];
            if (self.tag.length > 0 && kDataListIdea) {
                [self.ideaObjModelList removeObject:model];
            }
            
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            
            self.tableBackView.hidden = !(self.ideaObjModelList.count == 0);
            
            break;
        }
        case kListTypeShow:
        {
            CLShowModel *model = self.showModelList[path.row];
            
            
            [CLDataSaveTool deleteShow:model];
            
            [kDataListShow removeObject:model];
            [kDataListAll removeObject:model];
            if (self.showModelList != kDataListShow) {
                [self.showModelList removeObject:model];
            }
            
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            
            
            break;
        }
            
        case kListTypeRoutine:
        {
            CLRoutineModel *model = self.routineModelList[path.row];
            
            [CLDataSaveTool deleteRoutine:model];
            
            [kDataListRoutine removeObject:model];
            [kDataListAll removeObject:model];
            if (self.routineModelList != kDataListRoutine) {
                [self.routineModelList removeObject:model];
            }
            
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            
            break;
        }
        case kListTypeSleight:
        {
            CLSleightObjModel *model = self.sleightObjModelList[path.row];
            
            [CLDataSaveTool deleteSleight:model];
            
            [kDataListSleight removeObject:model];
            [kDataListAll removeObject:model];
            self.tableBackView.hidden = !(self.sleightObjModelList.count == 0);
            
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            
            break;
        }
            
        case kListTypeProp:
        {
            CLPropObjModel *model = self.propObjModelList[path.row];
            
            [CLDataSaveTool deleteProp:model];
            
            [kDataListProp removeObject:model];
            [kDataListAll removeObject:model];
            if (self.tag.length > 0 && self.propObjModelList != kDataListProp) {
                [self.propObjModelList removeObject:model];
            }
            
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            
            self.tableBackView.hidden = !(self.propObjModelList.count == 0);
            
            break;
        }
        case kListTypeLines:
        {
            CLLinesObjModel *model = self.linesObjModelList[path.row];
            
            [CLDataSaveTool deleteLines:model];
            
            [kDataListLines removeObject:model];
            [kDataListAll removeObject:model];
            if (self.tag.length > 0 && self.linesObjModelList != kDataListLines) {
                [self.linesObjModelList removeObject:model];
            }
            
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            
            self.tableBackView.hidden = !(self.linesObjModelList.count == 0);
            
            break;
        }
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:self];

}

// 导出笔记 (选择是否密码导出)
- (void)exportWithIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"导出笔记", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* exportWithPassword = [UIAlertAction actionWithTitle:NSLocalizedString(@"密码导出", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self passwordExportWithIndexPath:indexPath];
        
    }];
    
    UIAlertAction* exportWithoutPassword = [UIAlertAction actionWithTitle:NSLocalizedString(@"直接导出", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self exportEntryWithIndexPath:indexPath importPassword:@""];
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:exportWithPassword];
    [alert addAction:exportWithoutPassword];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

// 密码导出
- (void)passwordExportWithIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"设置导出密码", nil) message:NSLocalizedString(@"请输入笔记密码", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"导出密码", nil);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.font = kFontSys16;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"导出", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *passwordTF = alertController.textFields.firstObject;
        
        NSString *exportPassword = passwordTF.text;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
        [self exportEntryWithIndexPath:indexPath importPassword:exportPassword];
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        UITextField *passwordTF = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = passwordTF.text.length > 0;
    }];
    
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *nameTF = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = nameTF.text.length > 0;
    }
}

- (void)exportEntryWithIndexPath:(NSIndexPath *)indexPath importPassword:(NSString *)importPassword {
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
    [self.tabBarController.view addSubview:HUD];
    
    HUD.delegate = self;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        
        switch (self.listType) {
            case kListTypeAll:
                break;
                
            case kListTypeIdea:
            {
                CLIdeaObjModel *ideaObjModel = self.ideaObjModelList[indexPath.row];
                
                self.exportPath = [CLDataExportTool makeDataPackageWithIdea:ideaObjModel passWord:importPassword];
                break;
            }
            case kListTypeShow:
                break;
                
            case kListTypeRoutine:
            {
                CLRoutineModel *routineModel = self.routineModelList[indexPath.row];
                self.exportPath = [CLDataExportTool makeDataPackageWithRoutine:routineModel passWord:importPassword];
                break;
            }
            case kListTypeSleight:
            {
                CLSleightObjModel *sleightObjModel = self.sleightObjModelList[indexPath.row];
                self.exportPath = [CLDataExportTool makeDataPackageWithSleight:sleightObjModel passWord:importPassword];
                
                break;
            }
                
            case kListTypeProp:
            {
                CLPropObjModel *propObjModel = self.propObjModelList[indexPath.row];
                self.exportPath = [CLDataExportTool makeDataPackageWithProp:propObjModel passWord:importPassword];
                
                break;
            }
            case kListTypeLines:
            {
                CLLinesObjModel *linesObjModel = self.linesObjModelList[indexPath.row];
                self.exportPath = [CLDataExportTool makeDataPackageWithLines:linesObjModel passWord:importPassword];
                break;
            }
                
            default:
                break;
        }
        
    } onQueue:dispatch_get_main_queue() completionBlock:^{
        
        if (self.exportPath != nil) {
            NSURL *dataUrl;
            dataUrl = [NSURL fileURLWithPath:self.exportPath];
            
            CGRect navRect = self.view.frame;
            self.documentInteractionController =[UIDocumentInteractionController interactionControllerWithURL:dataUrl];
            self.documentInteractionController.delegate = self;
            
            [self.documentInteractionController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
        } else {
            
            [MBProgressHUD showGlobalProgressHUDWithTitle:NSLocalizedString(@"导出失败", nil) hideAfterDelay:1.0];
        }
    }];
    
}


#pragma mark - UIDocumentInteractionControllerDelegate

//===================================================================
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}


#pragma mark 选中cell跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.listType == kListTypeShow) {

        [self performSegueWithIdentifier:kSegueListToShow sender:indexPath];
        
    } else {
        
        [self performSegueWithIdentifier:kSegueListToContent sender:indexPath];
    }
}

#pragma mark - segue方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = segue.destinationViewController;
    UIViewController *vc = (UIViewController *)destVC;
    vc.hidesBottomBarWhenPushed = YES;
    
    if ([destVC isKindOfClass:[CLContentVC class]]) {
        CLContentVC *vc = (CLContentVC *)destVC;
        
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;

            switch (self.listType) {
                case kListTypeAll:
                    break;
                    
                case kListTypeIdea:
                {
                    CLIdeaObjModel *model = self.ideaObjModelList[indexPath.row];
                    vc.contentType = kContentTypeIdea;
                    vc.ideaObjModel = model;
                    break;
                }

                case kListTypeRoutine:
                {
                    CLRoutineModel *model = self.routineModelList[indexPath.row];
                    vc.contentType = kContentTypeRoutine;
                    vc.routineModel = model;
                    break;
                }
                case kListTypeSleight:
                {
                    CLSleightObjModel *model = self.sleightObjModelList[indexPath.row];
                    vc.contentType = kContentTypeSleight;
                    vc.sleightObjModel = model;
                    break;
                }
                    
                    
                case kListTypeProp:
                {
                    CLPropObjModel *model = self.propObjModelList[indexPath.row];
                    vc.contentType = kContentTypeProp;
                    vc.propObjModel = model;
                    break;
                }
                case kListTypeLines:
                {
                    CLLinesObjModel *model = self.linesObjModelList[indexPath.row];
                    vc.contentType = kContentTypeLines;
                    vc.linesObjModel = model;
                    break;
                }

                default:
                    break;
            }
        }
        
    } else if ([destVC isKindOfClass:[CLNewEntryNavVC class]]) {
        CLNewEntryNavVC *vc = (CLNewEntryNavVC *)destVC;
        
        vc.editingContentType = self.editingContentType;
        
        if (self.editingContentType == kEditingContentTypeIdea) {
            vc.ideaObjModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] ideaObjModelList][0];
            
        } else if (self.editingContentType == kEditingContentTypeRoutine) {
            vc.routineModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] routineModelList][0];
        } else if (self.editingContentType == kEditingContentTypeSleight) {
            vc.sleightObjModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sleightObjModelList][0];
        } else if (self.editingContentType == kEditingContentTypeProp) {
            vc.propObjModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList][0];
        } else if (self.editingContentType == kEditingContentTypeLines) {
            vc.linesObjModel = [(AppDelegate *)[[UIApplication sharedApplication] delegate] linesObjModelList][0];
        }
    } else if ([destVC isKindOfClass:[CLNewShowNavVC class]]) {
        CLNewShowNavVC *vc = (CLNewShowNavVC *)destVC;
        vc.showModel = kDataListShow[0];
        
    } else if ([destVC isKindOfClass:[CLShowVC class]]) {
        CLShowVC *vc = (CLShowVC *)destVC;
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            CLShowModel *model;
            
            if (self.listType == kListTypeShow) {
                model = self.showModelList[indexPath.row];
            }
            
            vc.showModel = model;
            vc.date = model.date;
        }
    }

}

- (IBAction)addNewEntry:(id)sender {
    
    switch (self.listType) {
        case kListTypeAll:
            
            break;
            
        case kListTypeIdea:
            [self addNewIdea];
            break;
          
        case kListTypeShow:
            [self addNewShow];
            break;
            
        case kListTypeRoutine:
            [self addNewRoutine];
            break;
            
        case kListTypeSleight:
            [self addNewSleight];
            break;
            
        case kListTypeProp:
            [self addNewProp];
            break;
            
        case kListTypeLines:
            [self addNewLines];
            break;
          
        default:
            break;
    }

}

- (void)addNewIdea {
    self.editingContentType = kEditingContentTypeIdea;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLIdeaObjModel *model = [CLIdeaObjModel ideaObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListIdea insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.ideaObjModelList != kDataListIdea) {
        [model.tags addObject:self.tag];
        [self.ideaObjModelList insertObject:model atIndex:0];
    }
    
    [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
}

- (void)addNewShow {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLShowModel *model = [CLShowModel showModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListShow insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.showModelList != kDataListShow) {
        [model.tags addObject:self.tag];
        [self.showModelList insertObject:model atIndex:0];
    }
    
    [self performSegueWithIdentifier:kSegueListToNewShow sender:nil];
}

- (void)addNewRoutine {
    
    self.editingContentType = kEditingContentTypeRoutine;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLRoutineModel *model = [CLRoutineModel routineModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListRoutine insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];

    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.routineModelList != kDataListRoutine) {
        [model.tags addObject:self.tag];
        [self.routineModelList insertObject:model atIndex:0];
    }
    
    [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
}

- (void)addNewSleight {
    self.editingContentType = kEditingContentTypeSleight;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLSleightObjModel *model = [CLSleightObjModel sleightObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListSleight insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];

    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到sleightModelList中
    if (self.tag.length > 0 && self.sleightObjModelList != kDataListSleight) {
        [model.tags addObject:self.tag];
        [self.sleightObjModelList insertObject:model atIndex:0];
    }
    
    [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
}

- (void)addNewProp {
    self.editingContentType = kEditingContentTypeProp;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLPropObjModel *model = [CLPropObjModel propObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListProp insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];

    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.propObjModelList != kDataListProp) {
        [model.tags addObject:self.tag];
        [self.propObjModelList insertObject:model atIndex:0];
    }
    
    [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
}

- (void)addNewLines {
    self.editingContentType = kEditingContentTypeLines;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLLinesObjModel *model = [CLLinesObjModel linesObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListLines insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];

    // 当有tag的时候,说明是tag页面跳转而来, 新增模型时, 自动添加该tag, 且添加到tag的ModelList中
    if (self.tag.length > 0 && self.linesObjModelList != kDataListLines) {
        [model.tags addObject:self.tag];
        [self.linesObjModelList insertObject:model atIndex:0];
    }
    
    [self performSegueWithIdentifier:kSegueListToNewEntry sender:nil];
}


@end
