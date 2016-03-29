//
//  CLNewShowVC.m
//  Mook
//
//  Created by 陈林 on 15/12/19.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLNewShowVC.h"
#import "CLShowModel.h"

#import "CLInfoModel.h"
#import "CLEffectModel.h"

#import "CLOneLableImageCell.h"

#import "CLRoutineModel.h"

#import "CLTagField.h"
#import "SMTag.h"
#import "SMTagField.h"

#import "CLTagChooseNavVC.h"

@interface CLNewShowVC ()<UITextFieldDelegate, SMTagFieldDelegate, SWTableViewCellDelegate, CLTagChooseNavVCDelegate>

@property (nonatomic, strong) CLTagField *tagField;

@property (nonatomic, strong) NSMutableArray  *tagList;
@property (nonatomic, strong) NSMutableArray <NSString*> *tags;


//@property (nonatomic, strong) CLTableHeader *tableHeader;
@property (nonatomic, assign) BOOL viewIsShowing;

//@property (nonatomic, assign) BOOL lastRowReordered;

@end

@implementation CLNewShowVC

BOOL foldingBools[5] = {YES, YES, YES, YES, YES};

//BOOL editingBooleans[5] = {YES, YES, YES, YES, YES};


#pragma mark - 懒加载数据


- (NSMutableArray<NSString *> *)tags {
        
    _tags = self.showModel.tags;
                    
    return _tags;
}

// 懒加载routineModel
- (CLShowModel *)showModel {
    if (!_showModel) {
        _showModel = [CLShowModel showModel];
    }
    return _showModel;
}


#pragma mark 懒加载 view
- (CLTagField *)tagField {
    if (!_tagField) {
        _tagField = [CLTagField tagField];
        _tagField.frame = CGRectMake(0, 0, kScreenW, 50);
        
        _tagField.tagField.tagDelegate = self;
        [_tagField.tagField setTags:self.tags];
    }
    return _tagField;
}



//- (CLTableHeader *)tableHeader {
//    if (!_tableHeader) {
//        _tableHeader = [CLTableHeader tableHeader];
//        _tableHeader.frame = CGRectMake(0, 0, kScreenW, 30);
//        _tableHeader.colorView.backgroundColor = [UIColor clearColor];
//        
//        _tableHeader.nameTextField.delegate = self;
//        
//        _tableHeader.nameTextField.placeholder = @"编辑演出名称";
//        
//        _tableHeader.nameTextField.text = self.showModel.name;
//        
//        if (self.showModel.name.length > 0) {
//            
//            _tableHeader.nameTextField.textAlignment = NSTextAlignmentCenter;
//            
//            _tableHeader.nameTextField.font = kBoldFontSys17;
//            _tableHeader.nameTextField.backgroundColor = [UIColor clearColor];
//            _tableHeader.nameTextField.textColor = [UIColor whiteColor];
//            _tableHeader.nameTextField.borderStyle = UITextBorderStyleNone;
//        } else {
//            
//            _tableHeader.nameTextField.textAlignment = NSTextAlignmentLeft;
//            _tableHeader.nameTextField.font = kFontSys16;
//            _tableHeader.nameTextField.backgroundColor = [UIColor whiteColor];
//            _tableHeader.nameTextField.textColor = [UIColor blackColor];
//            _tableHeader.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
//        }
//        
//    }
//    
//    return _tableHeader;
//}
//
//- (void)deleteEntry {
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction* delete = [UIAlertAction actionWithTitle:self.deleteMessage style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        
//        NSArray *viewControllers = [[self navigationController] viewControllers];
//        
//        
//        switch (self.editingContentType) {
//            case kEditingContentTypeRoutine:
//                if ([self.delegate respondsToSelector:@selector(newEntryVC:deleteRoutine:)]) {
//                    [self.delegate newEntryVC:self deleteRoutine:self.routineModel];
//                }
//                
//                for( int i=0;i<[viewControllers count];i++){
//                    id obj=[viewControllers objectAtIndex:i];
//                    if([obj isKindOfClass:[CLRoutineListVC class]]){
//                        [[self navigationController] popToViewController:obj animated:YES];
//                        break;
//                    }
//                    
//                }
//                
//                break;
//                
//            case kEditingContentTypeIdea:
//                if ([self.delegate respondsToSelector:@selector(newEntryVC:deleteIdea:)]) {
//                    [self.delegate newEntryVC:self deleteIdea:self.ideaObjModel];
//                }
//                
//                for( int i=0;i<[viewControllers count];i++){
//                    id obj=[viewControllers objectAtIndex:i];
//                    if([obj isKindOfClass:[CLIdeaListVC class]]){
//                        [[self navigationController] popToViewController:obj animated:YES];
//                        break;
//                    }
//                    
//                }
//                break;
//            case kEditingContentTypeSleight:
//                if ([self.delegate respondsToSelector:@selector(newEntryVC:deleteSleight:)]) {
//                    [self.delegate newEntryVC:self deleteSleight:self.sleightObjModel];
//                }
//                
//                for( int i=0;i<[viewControllers count];i++){
//                    id obj=[viewControllers objectAtIndex:i];
//                    if([obj isKindOfClass:[CLSleightListVC class]]){
//                        [[self navigationController] popToViewController:obj animated:YES];
//                        break;
//                    }
//                    
//                }
//                break;
//            case kEditingContentTypeProp:
//                if ([self.delegate respondsToSelector:@selector(newEntryVC:deleteProp:)]) {
//                    [self.delegate newEntryVC:self deleteProp:self.propObjModel];
//                }
//                
//                for( int i=0;i<[viewControllers count];i++){
//                    id obj=[viewControllers objectAtIndex:i];
//                    if([obj isKindOfClass:[CLPropListVC class]]){
//                        [[self navigationController] popToViewController:obj animated:YES];
//                        break;
//                    }
//                    
//                }
//                break;
//            case kEditingContentTypeLines:
//                if ([self.delegate respondsToSelector:@selector(newEntryVC:deleteLines:)]) {
//                    [self.delegate newEntryVC:self deleteLines:self.linesObjModel];
//                }
//                
//                for( int i=0;i<[viewControllers count];i++){
//                    id obj=[viewControllers objectAtIndex:i];
//                    if([obj isKindOfClass:[CLLineListVC class]]){
//                        [[self navigationController] popToViewController:obj animated:YES];
//                        break;
//                    }
//                }
//                break;
//            default:
//                break;
//        }
//        
//    }];
//    
//    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//    }];
//    
//    [alert addAction:delete];
//    [alert addAction:cancel];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//}

#pragma mark - viewController方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setFoldingBools];
    [self setTableViewStatus];
    
    self.title = self.showModel.name;
//    if (!self.tableHeader.nameTextField.hasText) {
//        [self.tableHeader.nameTextField becomeFirstResponder];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelTagSelection) name:@"cancelTagSelection" object:nil];
}

- (void)cancelTagSelection {
    if ([self.presentedViewController isKindOfClass:[CLTagChooseNavVC class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTableViewStatus {
    
    self.tableView.backgroundColor = [UIColor whiteColor];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelectionDuringEditing = YES;
    

    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.tableHeaderView = self.tagField;
    
    self.tableView.rowHeight = 80;
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"CLListTextCell"
//                                               bundle:nil]
//         forCellReuseIdentifier:kListTextCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLOneLableImageCell"
                                               bundle:nil]
         forCellReuseIdentifier:kOneLabelImageCellID];
    
}

- (void)setFoldingBools {
    
    for (int i = 0; i<3; i++) {
        foldingBools[i] = YES;
    }
    
    if (self.showModel.openerShow.count > 0) {
        foldingBools[0] = NO;
        
    }
    
    if (self.showModel.middleShow.count > 0) {
        foldingBools[1] = NO;
        
    }
    
    if (self.showModel.endingShow.count > 0) {
        foldingBools[2] = NO;
    }
    
}


// 隐藏MBProgreeHUD
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    self.navigationController.navigationBar.barTintColor = kHeaderViewColor;
    //    self.navigationController.navigationBar.translucent = NO;
    
    self.viewIsShowing = NO;
    [self.tableView reloadData];
//    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.viewIsShowing = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number = 0;
    
    switch (section) {
            
        case 0:
            number = self.showModel.openerShow.count;
            break;
            
        case 1:
            
            number = self.showModel.middleShow.count;
            break;
            
        case 2:
            number = self.showModel.endingShow.count;
            break;
            
        default:
            break;
    }
    
    if (foldingBools[section]) return 0;
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLOneLableImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kOneLabelImageCellID forIndexPath:indexPath];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLOneLableImageCell *listCell = (CLOneLableImageCell *)cell;
    
    NSString *imageName, *name, *effect;

    CLRoutineModel *model;
    switch (indexPath.section) {
        case 0:
            model = self.showModel.openerShow[indexPath.row];
            break;
            
        case 1:
            model = self.showModel.middleShow[indexPath.row];
            break;
            
        case 2:
            model = self.showModel.endingShow[indexPath.row];
            break;
            
        default:
            break;
    }
    
    imageName = [model getImage];
    name = model.infoModel.name;
    
    
    if (model.isStarred) {
        if (model.effectModel.isWithEffect) {
            effect = [NSString stringWithFormat:@"★%@", model.effectModel.effect];
        } else {
            effect = @"★";
        }
    } else {
        effect = model.effectModel.effect;
    }
    
    listCell.imageName = imageName;
//    listCell.dateLabel.text = date;
    listCell.titleLabel.text = name;
    
    listCell.contentLabel.text = effect;
    
//    listCell.rightUtilityButtons = [self rightButtons];
//    listCell.delegate = self;
    
}

//- (NSArray *)rightButtons
//{
//    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
//    
//    return rightUtilityButtons;
//}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (foldingBools[section]) {
        return 70;
    }
    
    return 55;
}



#pragma mark - tableView 编辑方法
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    return UITableViewCellEditingStyleDelete;
    
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
   if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        switch (indexPath.section) {
            case 0:
                [self.showModel.openerShow removeObjectAtIndex:indexPath.row];
                break;
                
            case 1:
                [self.showModel.middleShow removeObjectAtIndex:indexPath.row];

                break;
                
            case 2:
                [self.showModel.endingShow removeObjectAtIndex:indexPath.row];

                break;
            default:
                break;
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    if (fromIndexPath.section != toIndexPath.section) {
        [self.tableView reloadData];
        return;
    }
        
    switch (fromIndexPath.section) {
        case 0:
        {
            CLRoutineModel *model = self.showModel.openerShow[fromIndexPath.row];
            [self.showModel.openerShow removeObjectAtIndex:fromIndexPath.row];
            [self.showModel.openerShow insertObject:model atIndex:toIndexPath.row];
            break;
        }
        case 1:
        {
            CLRoutineModel *model = self.showModel.middleShow[fromIndexPath.row];
            [self.showModel.middleShow removeObjectAtIndex:fromIndexPath.row];
            [self.showModel.middleShow insertObject:model atIndex:toIndexPath.row];
            break;
        }
            
        case 2:
        {
            CLRoutineModel *model = self.showModel.endingShow[fromIndexPath.row];
            [self.showModel.endingShow removeObjectAtIndex:fromIndexPath.row];
            [self.showModel.endingShow insertObject:model atIndex:toIndexPath.row];
            break;
        }
            
            
        default:
            break;
    }
}




- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.tableView numberOfRowsInSection:indexPath.section] < 2) return NO;
    
    return YES;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//
//}


//#pragma mark - SWTableViewDelegate
//
//- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
//{
//    switch (index) {
//        case 0:
//        {
//            NSIndexPath *path = [self.tableView indexPathForCell:cell];
//            
////            CLRoutineModel *model = [self.routineModelList objectAtIndex:path.row];
////            [self deleteMediaFromModel:model];
//            
////            [self.routineModelList removeObjectAtIndex:path.row];
//            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
//            
//            
//            
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
//{
//    // allow just one cell's utility button to be open at once
//    return YES;
//}
//
//- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
//{
//    switch (state) {
//        case 1:
//            // set to NO to disable all left utility buttons appearing
//            return NO;
//            break;
//        case 2:
//            // set to NO to disable all right utility buttons appearing
//            return YES;
//            break;
//        default:
//            break;
//    }
//    
//    return YES;
//}
//


#pragma mark - segue 方法

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id destVC = [segue destinationViewController];
//    if ([destVC isKindOfClass:[CLRoutineListVC class]]) {
//        CLRoutineListVC *vc = (CLRoutineListVC *)destVC;
//        vc.isPickingRoutines = YES;
//        vc.delegate = self;
//        
//        if ([sender isKindOfClass:[NSIndexPath class]]) {
//            NSIndexPath *path = (NSIndexPath *)sender;
//            vc.dataPath = path;
//        }
//    } else if ([destVC isKindOfClass:[CLTagChooseNavVC class]]) {
        CLTagChooseNavVC *vc = (CLTagChooseNavVC *)destVC;
        vc.navDelegate = self;
//        vc.tagChooseMode = kTagChooseModeShow;
//    }
}



#pragma mark - 保存数据
- (IBAction)saveButtonClicked:(UIBarButtonItem *)sender {
    
//    UIView *view = [UIResponder currentFirstResponder];
//    if (view == self.tableHeader.nameTextField) {
//        [self.tableHeader.nameTextField resignFirstResponder];
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//- (void)routineListVC:(CLRoutineListVC *)routineListVC didPickRoutines:(NSArray *)pickedRoutines {
//    switch (routineListVC.dataPath.section) {
//        case 0:
//            for (CLRoutineModel *model in pickedRoutines) {
//                if ([self.showModel.openerShow containsObject:model] == NO) {
//                    [self.showModel.openerShow addObject:model];
//                }
//            }
//            break;
//            
//        case 1:
//            for (CLRoutineModel *model in pickedRoutines) {
//                if ([self.showModel.middleShow containsObject:model] == NO) {
//                    [self.showModel.middleShow addObject:model];
//                }
//            }
//            break;
//            
//        case 2:
//            for (CLRoutineModel *model in pickedRoutines) {
//                if ([self.showModel.endingShow containsObject:model] == NO) {
//                    [self.showModel.endingShow addObject:model];
//                }
//            }
//            break;
//            
//        default:
//            break;
//    }
//    
//    [self.tableView reloadData];
//}


// 销毁本veiwController时保存数据
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

        if ([self.delegate respondsToSelector:@selector(newShowVC:didSaveShow:)]) {
            
            [self.delegate newShowVC:self didSaveShow:self.showModel];
        }
}

//#pragma mark - textField 代理方法
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    
//    _tableHeader.nameTextField.textAlignment = NSTextAlignmentLeft;
//    _tableHeader.nameTextField.font = kFontSys16;
//    textField.backgroundColor = [UIColor whiteColor];
//    textField.textColor = [UIColor blackColor];
//    textField.borderStyle = UITextBorderStyleRoundedRect;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    
//    self.showModel.name = textField.text;
//    
//    if (textField.hasText == NO) {
//        _tableHeader.nameTextField.textAlignment = NSTextAlignmentLeft;
//        _tableHeader.nameTextField.font = kFontSys16;
//        textField.backgroundColor = [UIColor whiteColor];
//        textField.textColor = [UIColor blackColor];
//        textField.borderStyle = UITextBorderStyleRoundedRect;
//        
//    } else {
//        _tableHeader.nameTextField.textAlignment = NSTextAlignmentCenter;
//        _tableHeader.nameTextField.font = kBoldFontSys17;
//        textField.backgroundColor = [UIColor clearColor];
//        textField.textColor = [UIColor whiteColor];
//        textField.borderStyle = UITextBorderStyleNone;
//    }
//}

#pragma mark - tagField 代理方法
- (void)tagField:(SMTagField *)tagField tagAdded:(NSString *)tag {
    
    if ([self.tags containsObject:tag] == NO) {
        [self.tags addObject: tag];
    }
    
    if ([self.tagList containsObject:tag] == NO) {
        [self.tagList addObject: tag];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [NSKeyedArchiver archiveRootObject:[(AppDelegate *)[[UIApplication sharedApplication] delegate] tagList] toFile:kTagPath];
        });
    }
}

- (void)tagField:(SMTagField *)tagField tagRemoved:(NSString *)tag {
    if ([self.tags containsObject:tag]) {
        [self.tags removeObject: tag];
    }
    
}

- (void)tagField:(SMTagField *)tagField tagsChanged:(NSArray *)tags {
    
}

- (void)tagFieldAddButtonClicked:(SMTagField *)tagField {
    
    [self performSegueWithIdentifier:kNewShowChooseTagSegue sender:nil];
}

#pragma tagchoose 代理方法
- (void)tagChooseNavVC:(CLTagChooseNavVC *)tagChooseNavVC didSelectTag:(NSString *)tag {

    [self dismissViewControllerAnimated:YES completion:^{
        self.tagField.tagField.text = tag;
        
        if(self.tagField.tagField.text.length > 0)
            self.tagField.tagField.text = [self.tagField.tagField.text stringByAppendingString:@" "];
        
        [self.tagField.tagField textFieldDidChange:nil];
    }];
    
}


@end
