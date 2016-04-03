//
//  SMTag.m
//
//  Created by Shai Mishali on 6/3/13.
//  Copyright (c) 2013 Shai Mishali. All rights reserved.
//

#import "SMTag.h"

@implementation SMTag
@synthesize value;
@dynamic borderColor, font, textColor;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kMenuBackgroundColor;
        [self setTitleColor:kTintColor forState:UIControlStateDisabled];
        self.titleLabel.font    = kFontSys14;
        self.layer.cornerRadius = 11;
        self.layer.masksToBounds= YES;
        self.layer.borderColor  = [UIColor whiteColor].CGColor;
        self.layer.borderWidth  = 1;
        self.showsTouchWhenHighlighted = YES;
        
        value                   = @"";
        
        [self setTitle:[NSString stringWithFormat:@"  %@  ", value] forState:UIControlStateNormal];
        
        [self sizeToFit];
        
        CGRect selfFrame        = self.frame;
        selfFrame.size.height   = 25;
        self.frame              = selfFrame;
    }
    return self;
}

-(id)initWithTag:(NSString *)tag{
    if(self = [super init]){

        self.backgroundColor = kMenuBackgroundColor;
        [self setTitleColor:kTintColor forState:UIControlStateDisabled];
        self.titleLabel.font    = kFontSys14;
        self.layer.cornerRadius = 11;
        self.layer.masksToBounds= YES;
        self.layer.borderColor  = [UIColor whiteColor].CGColor;
        self.layer.borderWidth  = 1;
        self.showsTouchWhenHighlighted = YES;
        
        value                   = tag;
        
        [self setTitle:[NSString stringWithFormat:@"  %@  ", tag] forState:UIControlStateNormal];
        
        [self sizeToFit];
        
        CGRect selfFrame        = self.frame;
        selfFrame.size.height   = 25;
        self.frame              = selfFrame;
    }
    
    return self;
}

-(void)setValue:(NSString *)aValue{
    
    [self setTitle:[NSString stringWithFormat:@"    %@    ", aValue] forState:UIControlStateNormal];
//    self.value                  = aValue;
}

-(UIColor *)borderColor{
    return [UIColor colorWithCGColor: self.layer.borderColor];
}

-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor      = borderColor.CGColor;
}

-(UIFont *)font{
    return self.titleLabel.font;
}

-(void)setFont:(UIFont *)font{
    self.titleLabel.font    = font;
}

-(UIColor *)textColor{
    return [self titleColorForState: UIControlStateNormal];
}

-(void)setTextColor:(UIColor *)textColor{
    [self setTitleColor:textColor forState:UIControlStateNormal];
}

@end