//
//  CLEffectModel.m
//  Mook
//
//  Created by 陈林 on 15/11/17.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLEffectModel.h"
#import "CLDataSaveTool.h"

@implementation CLEffectModel

+ (instancetype) effectModel {
    return [[self alloc] init];
}

- (void)deleteMedia {
    
    if (self.isWithImage) {

        [self.image deleteNamedImageFromDocument];
        [CLDataSaveTool deleteImageByName:self.image];
        self.image = nil;
    }
    
    if (self.isWithVideo) {
        [self.video deleteNamedVideoFromDocument];
        [CLDataSaveTool deleteVideoByName:self.video];
        self.video = nil;
    }
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.effect forKey:kEffectKey];
    [coder encodeObject:self.video forKey:kEffectVideoKey];
    [coder encodeObject:self.image forKey:kEffectImageKey];

}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.effect = [coder decodeObjectForKey:kEffectKey];
        self.video = [coder decodeObjectForKey:kEffectVideoKey];
        self.image = [coder decodeObjectForKey:kEffectImageKey];

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


@end
