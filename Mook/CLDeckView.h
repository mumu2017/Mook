//
//  CLDeckView.h
//  Mook
//
//  Created by 陈林 on 16/6/17.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDeckView : UIScrollView<UIScrollViewDelegate>
{
    NSMutableArray *_imageButtonStore;
    bool snapping;
    float lastSnappingX;
}
@property (strong, nonatomic) NSArray *cardImageList;
@property (assign, nonatomic) CGFloat selectedRatio;
@property (assign, nonatomic) CGFloat unselectedAlpha;

@property (nonatomic) CGSize imageSize;


@end
