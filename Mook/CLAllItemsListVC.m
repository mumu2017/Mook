//
//  CLAllItemsListVC.m
//  Mook
//
//  Created by 陈林 on 16/4/12.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLAllItemsListVC.h"

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

@interface CLAllItemsListVC ()<SWTableViewCellDelegate, MBProgressHUDDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) NSMutableArray *allItems;

@property (nonatomic, strong) CLTableBackView *tableBackView;
@property (nonatomic, assign) EditingContentType editingContentType;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (nonatomic, copy) NSString *exportPath;

@end

@implementation CLAllItemsListVC

#pragma mark - 模型数组懒加载
- (NSMutableArray *)allItems {
    _allItems = kDataListAll;
    return kDataListAll;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateDataNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update:) name:kUpdateMookNotification
                                               object:nil];
}

- (void)update:(NSNotification *)noti {
    if (noti.object == self) return;
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.tableView reloadData];

    [self.navigationController setToolbarHidden:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number = self.allItems.count;

    self.tableBackView.hidden = !(number == 0);
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *iconName, *title;
    UIImage *image;
    NSAttributedString *content;
 
    id modelUnknown = self.allItems[indexPath.row];
    
    if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
        CLShowModel *model = (CLShowModel *)modelUnknown;
        image = [model getThumbnail];
        iconName = kIconNameShow;
        title = [model getTitle];
        content = [model getContent];
        
        if (image != nil) { // 如果返回图片,则表示模型中有图片或多媒体
            CLListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kListImageCellID forIndexPath:indexPath];
            cell.iconView.image = image;
            cell.iconName = iconName;
            [cell setTitle:title content:content];
            
            cell.rightUtilityButtons = [self showRightButtons];
            cell.delegate = self;
            cell.backgroundColor = [UIColor flatWhiteColor];
            
            return cell;
            
        } else {
            CLListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kListTextCellID forIndexPath:indexPath];
            cell.iconName = iconName;
            [cell setTitle:title content:content];
            
            cell.rightUtilityButtons = [self showRightButtons];
            cell.delegate = self;
            cell.backgroundColor = [UIColor flatWhiteColor];
            
            return cell;
        }
        
    } else if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
        CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
        image = [model getThumbnail];
        iconName = kIconNameIdea;
        title = [model getTitle];
        content = [model getContent];
    } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
        CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
        image = [model getThumbnail];
        iconName = kIconNameRoutine;
        title = [model getTitle];
        content = [model getContent];
    } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
        CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
        image = [model getThumbnail];
        iconName = kIconNameSleight;
        title = [model getTitle];
        content = [model getContent];
    } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
        CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
        image = [model getThumbnail];
        iconName = kIconNameProp;
        title = [model getTitle];
        content = [model getContent];
    } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
        CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
        iconName = kIconNameLines;
        title = [model getTitle];
        content = [model getContent];
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

// 演出的右滑按钮,不含导出
- (NSArray *)showRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor flatRedColor] icon:[UIImage imageNamed:@"iconBin"]];
    
    return rightUtilityButtons;
}

// 其他笔记的右滑按钮,包含导出按钮
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor flatGrayColorDark] icon:[UIImage imageNamed:@"iconAction"]];
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
        
        id modelUnknown = self.allItems[path.row];
        if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
            [self delete:path];
        } else {
            
            [self exportWithIndexPath:path];

        }
        
    } else if (index == 1) {
        
        [self delete:path];
        
    }
    
    [cell hideUtilityButtonsAnimated:YES];
}

#pragma mark - 删除和导出笔记方法
// 删除笔记
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

- (void)deleteEntryWithIndexPath:(NSIndexPath *)path {
 
    id modelUnknown = self.allItems[path.row];
    if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
        CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
        [CLDataSaveTool deleteIdea:model];

        [kDataListIdea removeObject:model];
        [self.allItems removeObjectAtIndex:path.row];

        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        
    } else if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
        CLShowModel *model = (CLShowModel *)modelUnknown;
        [CLDataSaveTool deleteShow:model];

        [kDataListShow removeObject:model];
        [self.allItems removeObjectAtIndex:path.row];

        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        
    } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
        CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
        [CLDataSaveTool deleteRoutine:model];

        [kDataListRoutine removeObject:model];
        [self.allItems removeObjectAtIndex:path.row];

        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        
    } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
        CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
        [CLDataSaveTool deleteSleight:model];
        
        [kDataListSleight removeObject:model];
        [self.allItems removeObjectAtIndex:path.row];

        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        
        
    } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
        CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
        [CLDataSaveTool deleteProp:model];
        [kDataListProp removeObject:model];

        [self.allItems removeObjectAtIndex:path.row];
        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        
    } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
        CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
        [CLDataSaveTool deleteLines:model];
        [kDataListLines removeObject:model];

        [self.allItems removeObjectAtIndex:path.row];

        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
    
    self.tableBackView.hidden = !(self.allItems.count == 0);
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


// 导出笔记
- (void)exportEntryWithIndexPath:(NSIndexPath *)indexPath importPassword:(NSString *)importPassword {
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
    [self.tabBarController.view addSubview:HUD];
    
    HUD.delegate = self;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        
        id modelUnknown = self.allItems[indexPath.row];
        if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
            CLIdeaObjModel *ideaObjModel = (CLIdeaObjModel *)modelUnknown;
            
            self.exportPath = [CLDataExportTool makeDataPackageWithIdea:ideaObjModel passWord:importPassword];
            
        } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
            CLRoutineModel *routineModel = (CLRoutineModel *)modelUnknown;
            self.exportPath = [CLDataExportTool makeDataPackageWithRoutine:routineModel passWord:importPassword];
            
            
        } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
            CLSleightObjModel *sleightObjModel = (CLSleightObjModel *)modelUnknown;
            self.exportPath = [CLDataExportTool makeDataPackageWithSleight:sleightObjModel passWord:importPassword];
            
            
        } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
            CLPropObjModel *propObjModel = (CLPropObjModel *)modelUnknown;
            self.exportPath = [CLDataExportTool makeDataPackageWithProp:propObjModel passWord:importPassword];
            
            
        } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
            CLLinesObjModel *linesObjModel = (CLLinesObjModel *)modelUnknown;
            self.exportPath = [CLDataExportTool makeDataPackageWithLines:linesObjModel passWord:importPassword];
            
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
    
    id modelUnknown = self.allItems[indexPath.row];
    if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
        [self performSegueWithIdentifier:kSegueHomeToShowSegue sender:indexPath];
    } else {
        
        [self performSegueWithIdentifier:kSegueHomeToContentSegue sender:indexPath];
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
   
            id modelUnknown = self.allItems[indexPath.row];
            if ([modelUnknown isKindOfClass:[CLIdeaObjModel class]]) {
                CLIdeaObjModel *model = (CLIdeaObjModel *)modelUnknown;
                vc.contentType = kContentTypeIdea;
                vc.ideaObjModel = model;
                
            } else if ([modelUnknown isKindOfClass:[CLRoutineModel class]]) {
                CLRoutineModel *model = (CLRoutineModel *)modelUnknown;
                vc.contentType = kContentTypeRoutine;
                vc.routineModel = model;
                
            } else if ([modelUnknown isKindOfClass:[CLSleightObjModel class]]) {
                CLSleightObjModel *model = (CLSleightObjModel *)modelUnknown;
                vc.contentType = kContentTypeSleight;
                vc.sleightObjModel = model;
                
            } else if ([modelUnknown isKindOfClass:[CLPropObjModel class]]) {
                CLPropObjModel *model = (CLPropObjModel *)modelUnknown;
                vc.contentType = kContentTypeProp;
                vc.propObjModel = model;
                
            } else if ([modelUnknown isKindOfClass:[CLLinesObjModel class]]) {
                CLLinesObjModel *model = (CLLinesObjModel *)modelUnknown;
                vc.contentType = kContentTypeLines;
                vc.linesObjModel = model;
            }
   
        }
        
    } else if ([destVC isKindOfClass:[CLNewEntryNavVC class]]) {
        CLNewEntryNavVC *vc = (CLNewEntryNavVC *)destVC;
        
        vc.editingContentType = self.editingContentType;
        
        if (self.editingContentType == kEditingContentTypeIdea) {
            vc.ideaObjModel = kDataListIdea[0];
        } else if (self.editingContentType == kEditingContentTypeRoutine) {
            vc.routineModel = kDataListRoutine[0];
        } else if (self.editingContentType == kEditingContentTypeSleight) {
            vc.sleightObjModel = kDataListSleight[0];
        } else if (self.editingContentType == kEditingContentTypeProp) {
            vc.propObjModel = kDataListProp[0];
        } else if (self.editingContentType == kEditingContentTypeLines) {
            vc.linesObjModel = kDataListLines[0];
        }
    } else if ([destVC isKindOfClass:[CLNewShowNavVC class]]) {
        CLNewShowNavVC *vc = (CLNewShowNavVC *)destVC;
        
        vc.showModel = kDataListShow[0];
        
    } else if ([destVC isKindOfClass:[CLShowVC class]]) {
        CLShowVC *vc = (CLShowVC *)destVC;
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            CLShowModel *model;
            
            id modelUnknown = self.allItems[indexPath.row];
            if ([modelUnknown isKindOfClass:[CLShowModel class]]) {
                model = (CLShowModel *)modelUnknown;
            }
            
            vc.showModel = model;
            vc.date = model.date;
        }
    }
    
}

#pragma mark - 新建笔记方法

- (IBAction)addNewEntry:(id)sender {

    [self addNewEntry];
}

- (void)addNewEntry {
    
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[NSLocalizedString(@"新建灵感", nil), NSLocalizedString(@"新建演出", nil), NSLocalizedString(@"新建流程", nil), NSLocalizedString(@"新建技巧", nil), NSLocalizedString(@"新建道具", nil), NSLocalizedString(@"新建台词", nil)] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[NSLocalizedString(@"取消", nil)] buttonStyle:JGActionSheetButtonStyleCancel];
    
    NSArray *sections = @[section1, cancelSection];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
    sheet.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    [self addNewIdea];
                    break;
                case 1:
                    [self addNewShow];
                    break;
                    
                case 2:
                    [self addNewRoutine];
                    break;
                case 3:
                    [self addNewSleight];
                    break;
                case 4:
                    [self addNewProp];
                    break;
                case 5:
                    [self addNewLines];
                    break;
                default:
                    break;
            }
            
        }
        
        [sheet dismissAnimated:YES];
    }];
    
    [sheet showInView:self.tabBarController.view animated:YES];
}

- (void)addNewIdea {
    self.editingContentType = kEditingContentTypeIdea;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLIdeaObjModel *model = [CLIdeaObjModel ideaObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListIdea insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntrySegue sender:nil];
}

- (void)addNewShow {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLShowModel *model = [CLShowModel showModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListShow insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewShowSegue sender:nil];
}

- (void)addNewRoutine {
    
    self.editingContentType = kEditingContentTypeRoutine;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLRoutineModel *model = [CLRoutineModel routineModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListRoutine insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntrySegue sender:nil];
}

- (void)addNewSleight {
    self.editingContentType = kEditingContentTypeSleight;
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLSleightObjModel *model = [CLSleightObjModel sleightObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListSleight insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntrySegue sender:nil];
}

- (void)addNewProp {
    self.editingContentType = kEditingContentTypeProp;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLPropObjModel *model = [CLPropObjModel propObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListProp insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntrySegue sender:nil];
}

- (void)addNewLines {
    self.editingContentType = kEditingContentTypeLines;
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLLinesObjModel *model = [CLLinesObjModel linesObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListLines insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self performSegueWithIdentifier:kSegueHomeToNewEntrySegue sender:nil];
}


@end
