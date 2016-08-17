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
@property (strong, nonatomic) NSMutableArray *webNotesList;

@property (strong, nonatomic) UISegmentedControl *segControl;

@property (assign, nonatomic) WebSiteMode webSiteMode;


@end

@implementation CLWebVC

- (NSMutableArray *)webNotesList {
    
    if (!_webNotesList) {

        _webNotesList = [CLDataSaveTool allWebNotes];
    }

    return _webNotesList;
}

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

- (UISegmentedControl *)segControl {
    
    if (!_segControl) {
        _segControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"书签", nil), NSLocalizedString(@"收藏", nil)]];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:_segControl];
        self.navigationItem.titleView = view;
        
        [_segControl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(view);
        }];
        
        _segControl.selectedSegmentIndex = 0;
        _segControl.backgroundColor = [UIColor clearColor];
        _segControl.tintColor = [UIColor whiteColor];
        [_segControl addTarget:self action:@selector(changeList:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segControl;
}

- (void)changeList:(UISegmentedControl *)segControl {
    
    if (segControl.selectedSegmentIndex == 0) {
        
        self.webSiteMode = kWebSiteModeSite;
        self.navigationItem.rightBarButtonItem = _addItem;
        
    } else if (segControl.selectedSegmentIndex == 1) {
        
        self.webSiteMode = kWebSiteModeNotes;
        self.navigationItem.rightBarButtonItem = nil;

    }
    
    [self.tableView reloadData];
    
    
    if ([self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:0] > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
    }
    
    
    [self prepareVisibleCellsForAnimation];
    [self animateVisibleCells];

    
}

#pragma mark - Private Cell的动画效果

- (void)prepareVisibleCellsForAnimation {
    
    NSArray *indexArr = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *topIndexPath = [indexArr firstObject];
    NSIndexPath *bottomIndexPath = [indexArr lastObject];
    
    for (NSInteger i = topIndexPath.row; i < bottomIndexPath.row+1; i++) {
        CLWebCell * cell = (CLWebCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        cell.frame = CGRectMake(-CGRectGetWidth(cell.bounds), cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
        cell.alpha = 0.f;
    }
}

- (void)animateVisibleCells {
    
    NSArray *indexArr = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *topIndexPath = [indexArr firstObject];
    NSIndexPath *bottomIndexPath = [indexArr lastObject];
    
    for (NSInteger i = topIndexPath.row; i < bottomIndexPath.row+1; i++) {
        CLWebCell * cell = (CLWebCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        cell.alpha = 1.f;
        [UIView animateWithDuration:0.15f
                              delay:(i-topIndexPath.row) * 0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.frame = CGRectMake(0.f, cell.frame.origin.y, CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds));
                         }
                         completion:nil];
    }
}


#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"发现", nil);

    [self initSubviews];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLWebCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"webCell"];
    self.tableView.rowHeight = 70;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor flatWhiteColor];
    
}

- (void)initSubviews {
    
    [self segControl];

    _addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(chooseWayToWebSite)];

    self.navigationItem.rightBarButtonItem = _addItem;
    
//    _collectItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showCollection)];
//    
//    self.navigationItem.rightBarButtonItems = @[_addItem, _collectItem];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.hidden = YES;
    [self.navigationController setHidesBarsOnSwipe:NO];
    [self.navigationController setHidesBarsWhenKeyboardAppears:NO];

    [self.navigationController setHidesBarsWhenVerticallyCompact:NO];

    
    [self.tableView reloadData];

}

#pragma mark - 添加网址
- (void)chooseWayToWebSite {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"添加网址", nil)  message:NSLocalizedString(@"推荐使用搜索添加", nil)  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* addWebSite = [UIAlertAction actionWithTitle:NSLocalizedString(@"搜索添加", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self addWebSiteWithSearching];
        
    }];
    
    UIAlertAction* addWebNote = [UIAlertAction actionWithTitle:NSLocalizedString(@"手动添加", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self addWebSiteWithTyping];
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:addWebSite];
    [alert addAction:addWebNote];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)addWebSiteWithSearching {

    CLWebViewController *webVC = [[CLWebViewController alloc] initWithURL:[NSURL URLWithString:kSearchUrlString]];
    webVC.webSiteList = self.webSiteList;
    webVC.webNoteList = self.webNotesList;
    
    webVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)addWebSiteWithTyping {
    
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
        
        // 检测剪切板中的文本, 如果是以http开头, 则直接拷贝到textField中
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        NSString *copyString = pboard.string;
        
        if ([copyString hasPrefix:@"http"]) {
            textField.text = copyString;
        }
        
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

    NSInteger number = 0;
    
    if (self.webSiteMode == kWebSiteModeSite) {
        
        number = self.webSiteList.count;
    } else if (self.webSiteMode == kWebSiteModeNotes) {
            
        number = self.webNotesList.count;
    }
    
    return number;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     CLWebCell *cell = [tableView dequeueReusableCellWithIdentifier:@"webCell" forIndexPath:indexPath];
     
    CLWebSiteModel *model;
    
    if (self.webSiteMode == kWebSiteModeSite) {
        
        model = self.webSiteList[indexPath.row];
        
    } else if (self.webSiteMode == kWebSiteModeNotes) {
        
        model = self.webNotesList[indexPath.row];

    }
    
    [cell setModel:model utilityButtons:[self rightButtons] delegate:self];
    
     cell.backgroundColor = [UIColor flatWhiteColor];

     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLWebSiteModel *model;
    
    if (self.webSiteMode == kWebSiteModeSite) {
        
        model = self.webSiteList[indexPath.row];
        
    } else if (self.webSiteMode == kWebSiteModeNotes) {
        
        model = self.webNotesList[indexPath.row];
        
    }

//TODO: 检查网络连接
    
    CLWebViewController *webVC = [[CLWebViewController alloc] initWithURL:model.url];
    webVC.webSiteList = self.webSiteList;
    webVC.webNoteList = self.webNotesList;

    webVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
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
            
            CLWebSiteModel *model;
            
            if (self.webSiteMode == kWebSiteModeSite) {
                
                model = self.webSiteList[indexPath.row];
                [self.webSiteList removeObject:model];

            } else if (self.webSiteMode == kWebSiteModeNotes) {
                
                model = self.webNotesList[indexPath.row];
                [self.webNotesList removeObject:model];

            }
            
            [CLDataSaveTool deleteWebSite:model];
            
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

//- (BOOL)checkIfStringIsValidUrl:(NSString *)string {
//    NSString *urlRegEx =
//    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
//    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
//    return [urlTest evaluateWithObject:string];
//}

@end
