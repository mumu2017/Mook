//
//  CLDeck.h
//  Mook
//
//  Created by 陈林 on 16/6/16.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLDeck : NSObject

@property (strong, nonatomic) NSArray *fullDeck;

@property (strong, nonatomic) NSArray *spades;
@property (strong, nonatomic) NSArray *hearts;
@property (strong, nonatomic) NSArray *clubs;
@property (strong, nonatomic) NSArray *diamonds;

+ (NSArray *)spades;
+ (NSArray *)hearts;
+ (NSArray *)clubs;
+ (NSArray *)diamonds;
+ (NSArray *)fullDeck;

+ (NSArray *)fullDeckImageList;
+ (NSArray *)MnemonicosisDeck;

@end
