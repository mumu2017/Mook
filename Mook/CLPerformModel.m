//
//  CLPerformModel.m
//  Mook
//
//  Created by 陈林 on 15/11/16.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLPerformModel.h"
#import "CLDataSaveTool.h"
#import "FCFileManager.h"

@implementation CLPerformModel

+ (instancetype) performModel {
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
    [coder encodeObject:self.perform forKey:kPerformKey];
    [coder encodeObject:self.image forKey:kPerformImageKey];
    [coder encodeObject:self.video forKey:kPerformVideoKey];
    [coder encodeObject:self.audio forKey:kPerformAudioKey];

}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.perform = [coder decodeObjectForKey:kPerformKey];
        self.image = [coder decodeObjectForKey:kPerformImageKey];
        self.video = [coder decodeObjectForKey:kPerformVideoKey];
        self.audio = [coder decodeObjectForKey:kPerformAudioKey];

    }
    return self;
}

- (BOOL)isWithPerform {
    return (self.perform.length > 0);
}

- (BOOL)isWithVideo {
    
    if (self.video.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString videoPath] stringByAppendingPathComponent:self.video];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

- (BOOL)isWithImage {
    
    if (self.image.length == 0) return NO;
        
    NSString *path = [[NSString imagePath] stringByAppendingPathComponent:self.image];
    
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

- (BOOL)isWithAudio {
    if (self.audio.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString audioPath] stringByAppendingPathComponent:self.audio];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

@end

