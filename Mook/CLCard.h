//
//  CLCard.h
//  Mook
//
//  Created by 陈林 on 16/6/16.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {

    kCardSuitSpade = 0,
    kCardSuitHeart,
    kCardSuitClub,
    kCardSuitDiamond,
    
} CardSuit;

typedef enum {
    kCardValueA = 1,
    kCardValue2,
    kCardValue3,
    kCardValue4,
    kCardValue5,
    kCardValue6,
    kCardValue7,
    kCardValue8,
    kCardValue9,
    kCardValue10,
    kCardValueJ,
    kCardValueQ,
    kCardValueK,
    
}CardValue;


@interface CLCard : NSObject

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) CardSuit suit;
@property (assign, nonatomic) CardValue value;
@property (assign, nonatomic) NSInteger index;

@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) UIImage *image;

+ (CLCard *)cardWithSuit:(CardSuit) suit andValue:(CardValue)value;
+ (CLCard *)cardWithTitle:(NSString *)title;


@end
