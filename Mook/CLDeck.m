//
//  CLDeck.m
//  Mook
//
//  Created by 陈林 on 16/6/16.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLDeck.h"
#import "CLCard.h"

@implementation CLDeck

+ (NSArray *)spades {
    return [[[self alloc] init] spades];
}

+ (NSArray *)hearts {
    return [[[self alloc] init] hearts];

}


+ (NSArray *)clubs {
    return [[[self alloc] init] clubs];
    
}


+ (NSArray *)diamonds {
    return [[[self alloc] init] diamonds];
    
}


+ (NSArray *)fullDeck {
    return [[[self alloc] init] fullDeck];
    
}

+ (NSArray *)fullDeckImageList {
    
    UIImage *image;
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:52];
    NSArray *deck = [self MnemonicosisDeck];
    for (CLCard *card in deck) {
        image = card.image;
        [arrM addObject:image];
    }
    return arrM;
}

+ (NSArray *)MnemonicosisDeck {
    
    NSArray *titleArr = [NSArray arrayWithObjects:@30, @15, @46, @29, @17, @45, @1, @18, @9, @2, @25, @42, @38, @21, @6, @5, @22, @39, @41, @24, @3, @8, @19, @36, @44, @52, @28, @16, @47, @31, @13, @50, @34, @10, @26, @37, @7, @23, @40, @4, @20, @43, @27, @35, @11, @51, @33, @12, @49, @32, @14, @48, nil];
    NSNumber *index;
    CLCard *card;
    NSArray *fullDeck = [self fullDeck];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:52];
    
    for (int i=0; i<titleArr.count; i++) {
        index = titleArr[i];
        card = fullDeck[index.intValue-1];
        [arrM addObject:card];
    }
    
    
    
//    NSArray *titleArr = [NSArray arrayWithObjects:@"♣️4", @"❤️2", @"♦️7", @"♣️3", @"❤️4", @"♦️6", @"♠️1", @"❤️5", @"♠️9", @"♠️2", @"❤️12", @"♦️3", @"♣️12", @"❤️8", @"♠️6", @"♠️5", @"❤️9", @"♣️13", @"♦️2", @"❤️11", @"♠️3", @"♠️8", @"❤️6", @"♣️10", @"♦️5", @"♦️13", @"♣️2", @"❤️3", @"♦️8", @"♣️5", @"♠️13", @"♦️11", @"♣️4", @"♠️10", @"♣️4", @"♣️4", @"♠️7", @"♣️4", @"♣️4", @"♠️4", @"♣️4", @"♣️4", @"♣️4", @"♣️4", @"♣️4", @"♣️4", @"♣️4", @"♣️4", @"♣️4", @"♣️4", @"♣️4", @"♣️4", nil]
    
    return arrM;
}

- (NSArray *)spades {
    if (!_spades) {
        
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:13];
        
        for (int i=0; i<13; i++) {
            CLCard *card = [CLCard cardWithSuit:kCardSuitSpade andValue:i+1];
            [arrM addObject:card];
        }
        _spades = arrM;

    }
    return _spades;
}

- (NSArray *)hearts {
    if (!_hearts) {
        
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:13];
        
        for (int i=0; i<13; i++) {
            CLCard *card = [CLCard cardWithSuit:kCardSuitHeart andValue:i+1];
            [arrM addObject:card];
        }
        _hearts = arrM;
        
    }
    return _hearts;
}

- (NSArray *)clubs {
    if (!_clubs) {
        
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:13];
        
        for (int i=0; i<13; i++) {
            CLCard *card = [CLCard cardWithSuit:kCardSuitClub andValue:i+1];
            [arrM addObject:card];
        }
        _clubs = arrM;
        
    }
    return _clubs;
}

- (NSArray *)diamonds {
    if (!_diamonds) {
        
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:13];
        
        for (int i=0; i<13; i++) {
            CLCard *card = [CLCard cardWithSuit:kCardSuitDiamond andValue:i+1];
            [arrM addObject:card];
        }
        _diamonds = arrM;
        
    }
    return _diamonds;
}

- (NSArray *)fullDeck {
    if (!_fullDeck) {
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:52];
        for (CLCard *card in self.spades) {
            [arrM addObject:card];
        }
        for (CLCard *card in self.hearts) {
            [arrM addObject:card];
        }
        for (CLCard *card in self.clubs) {
            [arrM addObject:card];
        }
        for (CLCard *card in self.diamonds) {
            [arrM addObject:card];
        }
        
        _fullDeck = arrM;
    }
    
    return _fullDeck;
}

@end
