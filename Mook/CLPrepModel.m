//
//  CLPrepModel.m
//  Mook
//
//  Created by 陈林 on 15/11/17.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLPrepModel.h"
#import "CLDataSaveTool.h"
#import "FCFileManager.h"

@implementation CLPrepModel

+ (instancetype) prepModel {
    return [[self alloc] init];
}

- (void)deleteMedia {
    
    if (self.isWithImage) {
        
        [self.image deleteNamedImageFromDocument];
        self.image = nil;
    }
    
    if (self.isWithVideo) {
        [self.video deleteNamedVideoFromDocument];
        self.video = nil;
    }
    
    if (self.isWithAudio) {
        [self.audio deleteNamedAudioFromDocument];
        self.audio = nil;
    }
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.prep forKey:kPrepKey];
    [coder encodeObject:self.image forKey:kPrepImageKey];
    [coder encodeObject:self.video forKey:kPrepVideoKey];
    [coder encodeObject:self.audio forKey:kPrepAudioKey];


}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.prep = [coder decodeObjectForKey:kPrepKey];
        self.image = [coder decodeObjectForKey:kPrepImageKey];
        self.video = [coder decodeObjectForKey:kPrepVideoKey];
        self.audio = [coder decodeObjectForKey:kPrepAudioKey];


    }
    return self;
}

- (BOOL)isWithPrep {
    return (self.prep.length > 0);
}


- (BOOL)isWithImage {
    
    if (self.image.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString imagePath] stringByAppendingPathComponent:self.image];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

- (BOOL)isWithVideo {
    
    if (self.video.length == 0) {
        return NO;
    }
        
    NSString *path = [[NSString videoPath] stringByAppendingPathComponent:self.video];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

- (BOOL)isWithAudio {
    if (self.audio.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString audioPath] stringByAppendingPathComponent:self.audio];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

- (NSNumber *)mediaSize {
    
    NSNumber *size = @0;
    NSString *path;
    if (self.isWithImage) {
        path = [[NSString imagePath] stringByAppendingPathComponent:self.image];
        size = [FCFileManager sizeOfFileAtPath:path];
        
    } else if (self.isWithVideo) {
        path = [[NSString videoPath] stringByAppendingPathComponent:self.video];
        size = [FCFileManager sizeOfFileAtPath:path];
        
    }
    
    return size;
}


@end
