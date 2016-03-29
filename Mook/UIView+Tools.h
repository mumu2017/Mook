//
//  UIView+Tools.h
//  Deck
//
//  Created by 陈林 on 15/11/10.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tools)

- (void) showWhiteBorder;
- (void) showBorder;
- (void) hideBorder;

- (void)highlightBorder;
- (void)unhighlightBorder;

- (void) showBottomLine;
- (void) hideBottomLine;

- (UIView *) bottomLine;
- (void) setBottomLineTransform:(CGAffineTransform)transform;

// 转换view中的内容为pdf格式
//- (void)createPDFfromContentToDocumentsWithFileName:(NSString*)aFilename;
//- (void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename;
@end
