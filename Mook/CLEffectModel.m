//
//  CLEffectModel.m
//  Mook
//
//  Created by 陈林 on 15/11/17.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLEffectModel.h"
#import "CLDataSaveTool.h"
#import "FCFileManager.h"

@implementation CLEffectModel

+ (instancetype) effectModel {
    return [[self alloc] init];
}

- (void)deleteMedia {
    
    if (self.isWithImage) {

        [self.image deleteNamedImageFromDocument];
//        [CLDataSaveTool deleteImageByName:self.image];
        self.image = nil;
    }
    
    if (self.isWithVideo) {
        [self.video deleteNamedVideoFromDocument];
//        [CLDataSaveTool deleteVideoByName:self.video];
        self.video = nil;
    }
    
    if (self.isWithAudio) {
        [self.audio deleteNamedAudioFromDocument];
        self.audio = nil;
    }
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.effect forKey:kEffectKey];
    [coder encodeObject:self.video forKey:kEffectVideoKey];
    [coder encodeObject:self.image forKey:kEffectImageKey];
    [coder encodeObject:self.audio forKey:kEffectAudioKey];

}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.effect = [coder decodeObjectForKey:kEffectKey];
        self.video = [coder decodeObjectForKey:kEffectVideoKey];
        self.image = [coder decodeObjectForKey:kEffectImageKey];
        self.audio = [coder decodeObjectForKey:kEffectAudioKey];


    }
    return self;
}

- (BOOL)isWithEffect {
    return (self.effect.length > 0);
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
    
    if (self.image.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString imagePath] stringByAppendingPathComponent:self.image];
    
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

- (NSString *)effect {
    if (_effect == nil) {
        _effect = @"";
    }
    return _effect;
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
    
    if (self.isWithAudio) {
        path = [[NSString audioPath] stringByAppendingPathComponent:self.video];
        size = @(size.intValue + [FCFileManager sizeOfFileAtPath:path].intValue);
        
    }

    return size;
}

@end
