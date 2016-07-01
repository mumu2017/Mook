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
#import "FKFaviconManager.h"

@interface CLWebVC ()
{
    CLWebViewController *_webVC;
 
}

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
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.hidden = YES;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.webSiteList.count;

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

    _webVC = [[CLWebViewController alloc] initWithURL:model.url];
    
    [self.navigationController pushViewController:_webVC animated:YES];
}




- (UIImage *)getFaviconFromWebsite:(NSURL *)websiteUrl {
    
    UIImage * __block myImage;

    [[FKFaviconManager sharedManager] getFaviconDataFromURL:websiteUrl completionHandler:^(NSData *data) {
        
        myImage = [[UIImage alloc] initWithData:data];

    }];
    
//    NSString *myURLString = [NSString stringWithFormat:@"http://www.google.com/s2/favicons?domain=%@", website];
//    NSURL *myURL=[NSURL URLWithString: myURLString];
//    NSData *myData=[NSData dataWithContentsOfURL:myURL];
//    
//    UIImage *myImage=[[UIImage alloc] initWithData:myData];
    
    return myImage;
}

@end
