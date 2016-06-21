//
//  CLCard.m
//  Mook
//
//  Created by 陈林 on 16/6/16.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLCard.h"

@implementation CLCard

+ (CLCard *)cardWithSuit:(CardSuit)suit andValue:(CardValue)value {
    CLCard *card = [[self alloc] init];
    card.suit = suit;
    card.value = value;
    
    return card;
}

+ (CLCard *)cardWithTitle:(NSString *)title {
    CLCard *card = [[self alloc] init];
    NSString *suit, *value;
    
    if (title.length != 2) {
        return nil;
    } else {
        suit = [title substringToIndex:1];
        value = [title substringWithRange:NSMakeRange(1, 1)];
        
        if ([suit isEqualToString:@"♠️"]) {
            card.suit = kCardSuitSpade;
        } else if ([suit isEqualToString:@"❤️"]) {
            card.suit = kCardSuitHeart;
        } else if ([suit isEqualToString:@"♣️"]) {
            card.suit = kCardSuitClub;
        } else if ([suit isEqualToString:@"♦️"]) {
            card.suit = kCardSuitDiamond;
        }
        
        int number = [value intValue];
        if (number > 0 && number < 14) {
            card.value = number;
        }
    }
    
    return card;
    
}

- (NSString *)title {
    
    NSString *suit, *value;
    switch (self.suit) {
        case kCardSuitSpade:
            suit = @"♠️";
            break;
            
        case kCardSuitHeart:
            suit = @"❤️";
            break;
            
        case kCardSuitClub:
            suit = @"♣️";
            break;
            
        case kCardSuitDiamond:
            suit = @"♦️";
            break;
            
        default:
            break;
    }
    
    switch (self.value) {
        case kCardValueA:
            value = @"A";
            break;
        case kCardValue2:
            value = @"2";
            break;
        case kCardValue3:
            value = @"3";
            break;
        case kCardValue4:
            value = @"4";
            break;
        case kCardValue5:
            value = @"5";

            break;
        case kCardValue6:
            value = @"6";
            break;
        case kCardValue7:
            value = @"7";

            break;
        case kCardValue8:
            value = @"8";

            break;
        case kCardValue9:
            value = @"9";

            break;
        case kCardValue10:
            value = @"10";

            break;
        case kCardValueJ:
            value = @"J";

            break;
        case kCardValueQ:
            value = @"Q";

            break;
        case kCardValueK:
            value = @"K";

            break;
            
        default:
            break;
    }
    _title = [suit stringByAppendingString:value];
    
    return _title;
}

-(NSString *)imageName {
    _imageName = self.title;
    
    return _imageName;
}

- (UIImage *)image {
    if (!_image) {
        _image = [UIImage imageNamed:self.imageName];
    }
    return _image;
}

@end
