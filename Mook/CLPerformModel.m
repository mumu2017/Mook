//
//  CLPerformModel.m
//  Mook
//
//  Created by 陈林 on 15/11/16.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLPerformModel.h"
#import "CLDataSaveTool.h"


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
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.perform forKey:kPerformKey];
    [coder encodeObject:self.image forKey:kPerformImageKey];
    [coder encodeObject:self.video forKey:kPerformVideoKey];

}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.perform = [coder decodeObjectForKey:kPerformKey];
        self.image = [coder decodeObjectForKey:kPerformImageKey];
        self.video = [coder decodeObjectForKey:kPerformVideoKey];

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

@end

