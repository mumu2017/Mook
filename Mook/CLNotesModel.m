//
//  CLNotesModel.m
//  Mook
//
//  Created by 陈林 on 15/11/19.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLNotesModel.h"

@implementation CLNotesModel


+ (instancetype) notesModel {
    return [[self alloc] init];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.notes forKey:kNotesKey];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.notes = [coder decodeObjectForKey:kNotesKey];
        
    }
    return self;
}

- (BOOL)isWithNotes {
    return (self.notes.length > 0);
}

@end
