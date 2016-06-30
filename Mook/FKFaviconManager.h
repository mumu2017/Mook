//
//  FKFaviconManager.h
//  FaviconKit
//
//  Created by Thomas Di Meco on 23/09/2015.
//  Copyright © 2015 Thomas Di Meco. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FKFaviconManager : NSObject

/**
 *  Get the shared manager across the application.
 *
 *  @return The shared manager instance
 */
+ (instancetype)sharedManager;

/**
 *  Get favicon image data from the given website URL.
 *
 *  @param url A website URL. Can be a complex URL like http://www.example.com/articles/123-myarticle?id=42
 *  @param completionHandler The asynchronous completion handler. Returns the image data, or nil in case of error
 */
- (void)getFaviconDataFromURL:(NSURL *)url completionHandler:(void (^)(NSData *data))completionHandler;

@end
