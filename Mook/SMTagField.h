//
//  SMTagField.h
//
//  Created by Shai Mishali on 6/16/13.
//  Copyright (c) 2013 Shai Mishali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTag.h"
@class SMTagField;

@protocol SMTagFieldDelegate <NSObject>

@optional


/**
 Called by delegate when a specific tag was added
 
 @param tagField The Tag Field
 @param tag The tag
 */
-(void) tagField: (SMTagField *) tagField tagAdded: (NSString *) tag;

/**
 Called by delegate when a specific tag was removed
 
 @param tagField The Tag Field
 @param tag The tag
 */
-(void) tagField: (SMTagField *) tagField tagRemoved: (NSString *) tag;

/**
 Called by delegate when any change to the tags occured (add/remove)
 
 @param tagField The Tag Field
 @param tag The tag
 */
-(void) tagField: (SMTagField *) tagField tagsChanged: (NSArray *) tags;

- (void)tagFieldAddButtonClicked:(SMTagField *)tagField;

@end
/**
 SMTagField is an implementation of UITextField that allows for easy input/display of tags
 */
@interface SMTagField : UITextField

/**
 The tags array, contains all of the tags. Can be set manually
 */
@property (nonatomic, strong) NSArray *tags;

/**
 The SMTagField Delegate. See documentation above
 */
@property (unsafe_unretained) id<SMTagFieldDelegate> tagDelegate;


- (void)textFieldDidChange:(NSNotification*)aNotification;

@end