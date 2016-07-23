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

- (void)deleteMedia {
    
    if (self.isWithAudio) {
        [self.audio deleteNamedAudioFromDocument];
        self.audio = nil;
    }
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.notes forKey:kNotesKey];
    [coder encodeObject:self.audio forKey:kNotesAudioKey];

}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.notes = [coder decodeObjectForKey:kNotesKey];
        self.audio = [coder decodeObjectForKey:kNotesAudioKey];

        
    }
    return self;
}

- (BOOL)isWithNotes {
    return (self.notes.length > 0);
}

- (BOOL)isWithAudio {
    if (self.audio.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString audioPath] stringByAppendingPathComponent:self.audio];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

@end
