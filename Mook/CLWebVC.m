//
//  CLWebVC.m
//  Mook
//
//  Created by 陈林 on 16/6/17.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLWebVC.h"
#import <WebKit/WebKit.h>
#import "CLWebViewController.h"
#import "CLWebSiteModel.h"
#import "CLDataSaveTool.h"
#import "CLWebCell.h"

@interface CLWebVC ()<SWTableViewCellDelegate>
{
//    CLWebViewController *_webVC;
    UIBarButtonItem *_addItem;
    UIBarButtonItem *_collectItem;
    NSInteger _scale;
 
}

@property (strong, nonatomic) NSMutableArray *webSiteList;


@end

@implementation CLWebVC

- (NSMutableArray *)webSiteList {
    if (!_webSiteList) {
        
        _webSiteList = [CLDataSaveTool allWebSites];
        if (_webSiteList.count == 0) {
            CLWebSiteModel *magiccafe, *vanishinginc, *conjAchive, *t11, *collegeMagic, *magicTieBa;
            
            magiccafe = [CLWebSiteModel modelWithTitle:@"The Magic Cafe" withUrlString:@"http://www.themagiccafe.com/forums/index.php"];
            
            conjAchive = [CLWebSiteModel modelWithTitle:@"Conjuring Archive" withUrlString:@"http://archive.denisbehr.de/"];
            
            t11 = [CLWebSiteModel modelWithTitle:@"Theory11" withUrlString:@"https://www.theory11.com/"];
            
            vanishinginc = [CLWebSiteModel modelWithTitle:@"Vanishing Inc" withUrlString:@"http://www.vanishingincmagic.com/"];
            
            collegeMagic = [CLWebSiteModel modelWithTitle:@"高校魔术论坛" withUrlString:@"http://www.collegemagic.cn/forum.php"];
            
            magicTieBa = [CLWebSiteModel modelWithTitle:@"魔术吧" withUrlString:@"http://tieba.baidu.com/f?kw=%C4%A7%CA%F5"];
            
            _webSiteList = [NSMutableArray arrayWithObjects:magiccafe, t11, conjAchive, vanishinginc, collegeMagic, magicTieBa, nil];
            
            [CLDataSaveTool updateWebSite:magiccafe];
            [CLDataSaveTool updateWebSite:vanishinginc];
            [CLDataSaveTool updateWebSite:conjAchive];
            [CLDataSaveTool updateWebSite:t11];
            [CLDataSaveTool updateWebSite:collegeMagic];
            [CLDataSaveTool updateWebSite:magicTieBa];

        }
        

        
    }
    return _webSiteList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";

    [self initSubviews];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLWebCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"webCell"];
    self.tableView.rowHeight = 80;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor flatWhiteColor];
    
}

- (void)initSubviews {
    
    _addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWebSite)];

    
    _collectItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showCollection)];
    
    self.navigationItem.rightBarButtonItems = @[_addItem, _collectItem];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.hidden = YES;
    [self.navigationController setHidesBarsOnSwipe:NO];
    [self.navigationController setHidesBarsWhenKeyboardAppears:NO];

    [self.navigationController setHidesBarsWhenVerticallyCompact:NO];

    
    [self.tableView reloadData];

}

#pragma mark - 控件方法


- (void)showCollection {
    
    
}

- (void)addWebSite {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"添加网站", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"网站标题", nil);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textField.font = kFontSys16;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"网站地址", nil);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = kFontSys16;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UITextField *nameTF = alertController.textFields.firstObject;
            UITextField *urlTF = alertController.textFields.lastObject;

            NSString *name = @"";
            name = nameTF.text;
            NSString *urlString = @"";
            urlString = urlTF.text;

            CLWebSiteModel *webSite = [CLWebSiteModel modelWithTitle:name withUrlString:urlString];
            
            [self.webSiteList addObject:webSite];
            
            [CLDataSaveTool updateWebSite:webSite];
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:self.webSiteList.count-1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
            
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
            
        });
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"编辑便捷短语", nil) message:NSLocalizedString(@"请输入短语内容", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *quickString = self.webSiteList[path.row];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"便捷短语", nil);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textField.font = kFontSys16;
        
        textField.text = quickString;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
//            self.quickStringList[path.row] = nameTF.text;
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
            
            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
            
        });
        
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
            
        });
        
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
        UITextField *urlTF = alertController.textFields.lastObject;

        UIAlertAction *okAction = alertController.actions.firstObject;
        okAction.enabled = (nameTF.text.length > 0 &&urlTF.text.length > 0 );
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.webSiteList.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     CLWebCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webCell" forIndexPath:indexPath];
     
     CLWebSiteModel *model = self.webSiteList[indexPath.row];
    
    [cell setModel:model utilityButtons:[self rightButtons] delegate:self];
    
     cell.backgroundColor = [UIColor flatWhiteColor];

     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLWebSiteModel *model = self.webSiteList[indexPath.row];

#warning 检查网络连接
    CLWebViewController *_webVC = [[CLWebViewController alloc] initWithURL:model.url];
    _webVC.webSiteList = self.webSiteList;
    
    _webVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:_webVC animated:YES];
    
//    if ([self checkIfStringIsValidUrl:model.url.absoluteString] == NO) {
//        [MBProgressHUD showGlobalProgressHUDWithTitle:@"无效的地址, 无法加载!" hideAfterDelay:0.5];
//        
//    } else {
//        _webVC = [[CLWebViewController alloc] initWithURL:model.url];
//        _webVC.webSiteList = self.webSiteList;
//        
//        _webVC.hidesBottomBarWhenPushed = YES;
//        
//        [self.navigationController pushViewController:_webVC animated:YES];
//    }
    

}

#pragma mark - SWTableViewCellDelegate
 // 其他笔记的右滑按钮,包含导出按钮
 - (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor flatRedColor] icon:[UIImage imageNamed:@"iconBin"]];
    
    return rightUtilityButtons;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self delete:indexPath];
    
    [cell hideUtilityButtonsAnimated:YES];
}

#pragma mark - 删除和导出笔记方法
// 删除笔记
- (void)delete:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"提示: 删除内容后将无法恢复,确定要删除当前内容吗?", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            CLWebSiteModel *model = self.webSiteList[indexPath.row];

            [CLDataSaveTool deleteWebSite:model];
            [self.webSiteList removeObject:model];
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

        });
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - helper

- (BOOL)checkIfStringIsValidUrl:(NSString *)string {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:string];
}

@end
