//
//  CLWebViewController.h
//  Mook
//
//  Created by 陈林 on 16/7/1.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <DZNWebViewController/DZNWebViewController.h>

@interface CLWebViewController : DZNWebViewController

@property (assign, nonatomic) BOOL isAddingWebSite;

@property (strong, nonatomic) NSMutableArray *webSiteList;

@property (strong, nonatomic) NSMutableArray *webNoteList;

@end
