//
//  CLQuickInputVC.m
//  Mook
//
//  Created by 陈林 on 16/1/2.
//  Copyright © 2016年 ChenLin. All rights reserved.
//

#import "CLQuickStringVC.h"
#import "CLQuickStringCell.h"
#import "CLTableBackView.h"

@interface CLQuickStringVC ()<SWTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray <NSString*> *quickStringList;
@property (nonatomic, strong) CLTableBackView *tableBackView;

@end

@implementation CLQuickStringVC


- (NSMutableArray *)quickStringList {
    if (!_quickStringList) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kQuickStringKey] == nil) {
            _quickStringList = [NSMutableArray array];
            
            [[NSUserDefaults standardUserDefaults] setObject:_quickStringList forKey:kQuickStringKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kQuickStringKey];
            _quickStringList = [array mutableCopy];
        }
    }
    return _quickStringList;
}

- (CLTableBackView *)tableBackView {
    if (!_tableBackView) {
        _tableBackView = [CLTableBackView tableBackView];
    }
    return _tableBackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 44;
    
    self.tableView.backgroundView = self.tableBackView;
    self.tableBackView.hidden = !(self.quickStringList.count == 0);
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLQuickStringCell"
                                               bundle:nil]
         forCellReuseIdentifier:kQuickStringCellID];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.quickStringList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLQuickStringCell *cell = [tableView dequeueReusableCellWithIdentifier:kQuickStringCellID forIndexPath:indexPath];
    
    cell.contentLabel.text = self.quickStringList[indexPath.row];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self editStringWithIndexPath:indexPath];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    
    return rightUtilityButtons;
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    switch (index) {

        case 0:
        { 
            [self.quickStringList removeObjectAtIndex:path.row];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.quickStringList forKey:kQuickStringKey];
            [defaults synchronize];
            
            [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
            
            self.tableBackView.hidden = !(self.quickStringList.count == 0);
            
            break;
        }
            
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
    
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


#pragma mark - 数据添加和编辑
- (IBAction)addNewQuickString:(id)sender {
    
    [self addNewQuickString];
}


- (void)addNewQuickString {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加便捷短语" message:@"请输入短语内容" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"便捷短语";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textField.font = kFontSys16;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *nameTF = alertController.textFields.firstObject;
        
        NSString *quickString = @"";
        quickString = nameTF.text;
        
        [self.quickStringList insertObject:quickString atIndex:0];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.quickStringList forKey:kQuickStringKey];
        [defaults synchronize];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
        self.tableBackView.hidden = !(self.quickStringList.count == 0);
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = NO;
    }];
}

- (void)editStringWithIndexPath:(NSIndexPath *)path {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"编辑便捷短语" message:@"请输入短语内容" preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *quickString = self.quickStringList[path.row];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"便捷短语";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textField.font = kFontSys16;
        
        textField.text = quickString;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *nameTF = alertController.textFields.firstObject;
        
        self.quickStringList[path.row] = nameTF.text;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:^{
        UITextField *nameTF = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = nameTF.text.length > 0;
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



@end
