//
//  CLNotesModel.h
//  Mook
//
//  Created by 陈林 on 15/11/19.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLNotesModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *notes;

// 是否有效果信息
@property (nonatomic, assign) BOOL isWithNotes;

+ (instancetype) notesModel;

@end
