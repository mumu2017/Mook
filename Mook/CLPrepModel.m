//
//  CLPrepModel.m
//  Mook
//
//  Created by 陈林 on 15/11/17.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLPrepModel.h"
#import "CLDataSaveTool.h"

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
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.prep forKey:kPrepKey];
    [coder encodeObject:self.image forKey:kPrepImageKey];
    [coder encodeObject:self.video forKey:kPrepVideoKey];

}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.prep = [coder decodeObjectForKey:kPrepKey];
        self.image = [coder decodeObjectForKey:kPrepImageKey];
        self.video = [coder decodeObjectForKey:kPrepVideoKey];


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


@end
