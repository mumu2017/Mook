//
//  CLPropInputVC.m
//  Mook
//
//  Created by 陈林 on 15/12/8.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLPropInputVC.h"
#import "CLPropModel.h"
#import "CLToolBar.h"
#import "CLPropObjModel.h"
#import "CLInfoModel.h"
#import "CLPropChooseNavVC.h"

#import "XLPagerTabStripViewController.h"

@interface CLPropInputVC ()<UITextFieldDelegate, CLToolBarDelegate, CLPropChooseNavVCDelegate, XLPagerTabStripChildItem>

@property (nonatomic, strong) CLToolBar *toolBar;

@property (nonatomic, weak) IBOutlet UITextField *propNameTextField;

@property (nonatomic, weak) IBOutlet UITextField *quantityTextField;

@property (nonatomic, weak) IBOutlet UITextField *propDetailTextField;

@property (nonatomic, assign) BOOL didMakeChange;

- (IBAction)doneButtonClicked:(id)sender;


@end

@implementation CLPropInputVC

- (CLPropModel *)propModel {
    if (!_propModel) {
        _propModel = [CLPropModel propModel];
    }
    return _propModel;
}


- (CLToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [CLToolBar toolBar];
        [_toolBar.imageButton setImage:kToolBarPropImage forState:UIControlStateNormal];
        [_toolBar.imageButton setImage:kToolBarPropImageHighlighted forState:UIControlStateHighlighted];
        [_toolBar.previousButton setImage:kToolBarUpImage forState:UIControlStateNormal];
        [_toolBar.previousButton setImage:kToolBarUpImageHighlighted forState:UIControlStateHighlighted];
        [_toolBar.nextButton setImage:kToolBarDownImage forState:UIControlStateNormal];
        [_toolBar.nextButton setImage:kToolBarDownImageHighlighted forState:UIControlStateHighlighted];

        _toolBar.backgroundColor = kDisplayBgColor;
        _toolBar.tbDelegate = self;
    }
    return _toolBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDisplayData];
        
    self.propNameTextField.inputAccessoryView = self.toolBar;
    self.quantityTextField.inputAccessoryView = self.toolBar;
    self.propDetailTextField.inputAccessoryView = self.toolBar;
    
    self.propNameTextField.delegate = self;
    self.quantityTextField.delegate = self;
    self.propDetailTextField.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelSelection) name:@"cancelPropSelection" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)cancelSelection {
    if ([self.presentedViewController isKindOfClass:[CLPropChooseNavVC class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)setDisplayData {
    
    self.propNameTextField.text = self.propModel.prop;
    self.quantityTextField.text = self.propModel.quantity;
    self.propDetailTextField.text = self.propModel.propDetail;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.didMakeChange = NO;
    if ([self.propNameTextField isFirstResponder] == NO) {
        [self.propNameTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
    if (self.didMakeChange) {
        // 别忘了道具编辑页面和演出编辑页面
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidMakeChangeNotification object:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

#pragma mark - toolBar 代理方法
- (void)toolBar:(CLToolBar *)toolBar didClickButton:(UIButton *)button {
    if (button == self.toolBar.previousButton) {
        
        [self previousTextField];
        
    } else if (button == self.toolBar.nextButton) {
        
        [self nextTextField];
        
    } else if (button == self.toolBar.imageButton) {

        [self selectProp];
        
    } else if (button == toolBar.addButton) {
        
        [self addProp];
        
    } else if (button == toolBar.deleteButton) {
        
        [self deleteProp];
    }

}

- (void)selectProp {
        
    [self performSegueWithIdentifier:kNewRoutineChoosePropSegue sender:nil];
}

- (void)addProp {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* add = [UIAlertAction actionWithTitle:NSLocalizedString(@"添加道具", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(propInputVCAddProp:)]) {
                [self.delegate propInputVCAddProp:self];
            }
            
        });

    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:add];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteProp {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除道具", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(propInputVCDeleteProp:)]) {
                [self.delegate propInputVCDeleteProp:self];
            }
            
        });

    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    

}

- (void)previousTextField {
    
    UIView *view = [UIResponder currentFirstResponder];
    if ([view isKindOfClass:[UITextField class]]) {
        UITextField *tf = (UITextField *)view;
        
        if (tf == self.quantityTextField) {
            [self.quantityTextField resignFirstResponder];
            [self.propDetailTextField  becomeFirstResponder];
        } else if (tf == self.propDetailTextField) {
            [self.propDetailTextField resignFirstResponder];
            [self.propNameTextField becomeFirstResponder];
        }
        
    }
}

- (void)nextTextField {
    
    UIView *view = [UIResponder currentFirstResponder];
    if ([view isKindOfClass:[UITextField class]]) {
        UITextField *tf = (UITextField *)view;
        
        if (tf == self.propNameTextField) {
            [self.propNameTextField resignFirstResponder];
            [self.propDetailTextField  becomeFirstResponder];
        } else if (tf == self.propDetailTextField) {
            [self.propDetailTextField resignFirstResponder];
            [self.quantityTextField becomeFirstResponder];
        }
        
    }
}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return NSLocalizedString(@"道具", nil);
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor blackColor];
}

#pragma mark - 数据保存
- (IBAction)doneButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - textField 代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.didMakeChange = YES;
    if (textField == self.propNameTextField) {
        self.propModel.prop = textField.text;
    } else if (textField == self.quantityTextField) {
        self.propModel.quantity = textField.text;
    } else if (textField == self.propDetailTextField) {
        self.propModel.propDetail = textField.text;
    }
}

- (void)saveData {
    self.propModel.prop = self.propNameTextField.text;
    self.propModel.quantity = self.quantityTextField.text;
    self.propModel.propDetail = self.propDetailTextField.text;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destVC = [segue destinationViewController];
    if ([destVC isKindOfClass:[CLPropChooseNavVC class]]) {
        CLPropChooseNavVC *vc = (CLPropChooseNavVC *)destVC;
        vc.navDelegate = self;
    }
}

- (void)propChooseNavVC:(CLPropChooseNavVC *)propChooseNavVC didSelectProp:(CLPropObjModel *)prop {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (prop.infoModel.isWithName) {
            self.propNameTextField.text = prop.infoModel.name;
        } else {
            self.propNameTextField.text = kDefaultTitleProp;

        }

        UIView *view = [UIResponder currentFirstResponder];
        
        if (view != self.propNameTextField) {
            [view resignFirstResponder];
            [self.propNameTextField becomeFirstResponder];
        }
    }];
}

@end
