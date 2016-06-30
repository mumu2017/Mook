//
//  FKFaviconManager.m
//  FaviconKit
//
//  Created by Thomas Di Meco on 23/09/2015.
//  Copyright © 2015 Thomas Di Meco. All rights reserved.
//

#import <HTMLReader/HTMLReader.h>
#import "FKFaviconManager.h"


@implementation FKFaviconManager

#pragma mark - Lifecycle

+ (instancetype)sharedManager {
    static FKFaviconManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


#pragma mark - Favicon methods

- (void)getFaviconDataFromURL:(NSURL *)url completionHandler:(void (^)(NSData *data))completionHandler {
    
    // Create the session configuration
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.URLCache = [[NSURLCache alloc] initWithMemoryCapacity:10*1024*1024 diskCapacity:20*1024*1024 diskPath:@"Favicons"];
    
    // Create the session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // Create and start the session task
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // Check everything is fine
        if (data != nil && response != nil && error == nil) {
            
            // Get the content type
            NSString *contentType = nil;
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                contentType = ((NSHTTPURLResponse *)response).allHeaderFields[@"Content-Type"];
            }
            
            // Create the HTML document
            NSURL *finalIconURL = nil;
            HTMLDocument *htmlDocument = [[HTMLDocument alloc] initWithData:data contentTypeHeader:contentType];
            
            // Try to find the custom link tag in the HTML head section
            finalIconURL = [self getCustomIconURLFromURL:url HTMLDocument:htmlDocument];
            
            // If not found, use the default favicon path
            if (finalIconURL == nil) {
                finalIconURL = [self getDefaultFaviconURLFromURL:url];
            }
            
            // If any URL is found, get its data
            if (finalIconURL != nil) {
                
                [[session dataTaskWithURL:finalIconURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (data != nil && response != nil && error == nil) {
                        completionHandler(data);
                    } else {
                        completionHandler(nil);
                    }
                }] resume];
                
                return;
            }
        }
        
        // If we are here, this is an error case
        completionHandler(nil);
        
    }] resume];
}

- (NSURL *)getCustomIconURLFromURL:(NSURL *)url HTMLDocument:(HTMLDocument *)htmlDocument {
    NSURL *customIconURL = nil;
    
    HTMLElement *iconElement = [htmlDocument firstNodeMatchingSelector:@"head link[rel='icon'], head link[rel='shortcut icon']"];
    NSString *iconRelativePath = iconElement.attributes[@"href"];
    if (iconRelativePath != nil) {
        customIconURL = [[NSURL URLWithString:iconRelativePath relativeToURL:url] absoluteURL];
    }
    
    return customIconURL;
}

- (NSURL *)getDefaultFaviconURLFromURL:(NSURL *)url {
    return [[NSURL URLWithString:@"/favicon.ico" relativeToURL:url] absoluteURL];
}

@end
