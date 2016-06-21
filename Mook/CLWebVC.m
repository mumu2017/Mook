//
//  CLWebVC.m
//  Mook
//
//  Created by 陈林 on 16/6/17.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLWebVC.h"
#import <WebKit/WebKit.h>
#import "DZNWebViewController.h"
#import "CLWebSiteModel.h"

@interface CLWebVC ()

@property (strong, nonatomic) NSMutableArray *webSiteList;

@end

@implementation CLWebVC

- (NSMutableArray *)webSiteList {
    if (!_webSiteList) {
        CLWebSiteModel *magiccafe, *vanishinginc, *conjAchive, *t11, *collegeMagic, *magicTieBa;
        
        magiccafe = [CLWebSiteModel modelWithTitle:@"The Magic Cafe" withUrlString:@"http://www.themagiccafe.com/forums/index.php"];
        
        conjAchive = [CLWebSiteModel modelWithTitle:@"Conjuring Archive" withUrlString:@"http://archive.denisbehr.de/"];
        
        t11 = [CLWebSiteModel modelWithTitle:@"Theory11" withUrlString:@"https://www.theory11.com/"];
        
        vanishinginc = [CLWebSiteModel modelWithTitle:@"Vanishing Inc" withUrlString:@"http://www.vanishingincmagic.com/"];
        
        collegeMagic = [CLWebSiteModel modelWithTitle:@"高校魔术论坛" withUrlString:@"http://www.collegemagic.cn/forum.php"];
        
        magicTieBa = [CLWebSiteModel modelWithTitle:@"魔术吧" withUrlString:@"http://tieba.baidu.com/f?kw=%C4%A7%CA%F5"];
        
        _webSiteList = [NSMutableArray arrayWithObjects:magiccafe, t11, conjAchive, vanishinginc, collegeMagic, magicTieBa, nil];
        
    }
    return _webSiteList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ID"];
    
    self.title = @"Magic in Web";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

    return self.webSiteList.count;
;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
     if (!cell) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
     }
     
     CLWebSiteModel *model = self.webSiteList[indexPath.row];
     
     cell.textLabel.text = model.title;
     
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLWebSiteModel *model = self.webSiteList[indexPath.row];

    DZNWebViewController *WVC = [[DZNWebViewController alloc] initWithURL:model.url];
    UINavigationController *NC = [[UINavigationController alloc] initWithRootViewController:WVC];

    WVC.supportedWebNavigationTools = DZNWebNavigationToolAll;
    WVC.supportedWebActions = DZNWebActionAll;
    WVC.showLoadingProgress = YES;
    WVC.allowHistory = YES;
    WVC.hideBarsWithGestures = YES;
    WVC.showPageTitleAndURL = NO;
    WVC.title = model.title;
    WVC.actionButtonImage = [UIImage imageNamed:@"iconAction"];
    WVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissWebVC)];

    [self presentViewController:NC animated:YES completion:NULL];
}

- (void)dismissWebVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
