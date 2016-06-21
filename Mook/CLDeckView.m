////
////  CLDeckView.m
////  Mook
////
////  Created by 陈林 on 16/6/17.
////  Copyright © 2016年 Chen Lin. All rights reserved.
////
//
//#import "CLDeckView.h"
//
//@implementation CLDeckView
//
//
//@synthesize imageSize = _imageSize;
//@synthesize cardImageList = _cardImageList;
//
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    
//    if (self) {
//        // Initialization code
//        
//        _unselectedAlpha = 1.0;
//        _selectedRatio = 1.4;
//        
//        _cardImageList = [[NSMutableArray alloc] init];
//        _imageButtonStore = [[NSMutableArray alloc] init];
//    }
//    return self;
//}
//
//
//- (void)initDeckView
//{
//    if (_imageSize.width == 0 && _imageSize.height == 0) {
//        if (_cardImageList.count > 0) _imageSize = [(UIImage *)[_cardImageList objectAtIndex:0] size];
//        else _imageSize = CGSizeMake(self.frame.size.height/2, self.frame.size.height/2);
//    }
//    
//    NSAssert((_imageSize.height < self.frame.size.height), @"item's height must not bigger than scrollpicker's height");
//    
//    self.pagingEnabled = NO;
//    self.showsHorizontalScrollIndicator = NO;
//    self.showsVerticalScrollIndicator = NO;
//    
//    if (_cardImageList.count > 0)
//    {
//        NSInteger visibleImageCount = (self.frame.size.width * 2 / _imageSize.width) - 1;
//        
//        // Init 5 set of images, 3 for user selection, 2 for
//        for (int i = 0; i < (_cardImageList.count*visibleImageCount); i++)
//        {
//            // Place images into the bottom of view
//            UIButton *btn = [[UIButton  alloc] initWithFrame:CGRectMake(i * _imageSize.width/2, self.frame.size.height - _imageSize.height, _imageSize.width/2, _imageSize.height)];
//
//            [btn setImage:[_cardImageList objectAtIndex:i%_cardImageList.count] forState:UIControlStateNormal];
//            
//            [_imageButtonStore addObject:btn];
//            [self addSubview:btn];
//        }
//        
//        self.contentSize = CGSizeMake(_cardImageList.count * visibleImageCount * _imageSize.width/2, self.frame.size.height);
//        
//        float viewMiddle = _cardImageList.count * 1 * _imageSize.width/2;
//        [self setContentOffset:CGPointMake(viewMiddle, 0)];
//        
//        self.delegate = self;
//        
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(queue, ^ {
//            [self reloadView:viewMiddle-10];
//            dispatch_async(dispatch_get_main_queue(), ^ {
//                [self snapToAnEmotion];
//            });
//        });
//        
//    }
//    
//}
//
//- (void)setCardImageList:(NSArray *)cardImageList {
//    _cardImageList = cardImageList;
//    [self initDeckView];
//}
//
//- (void)setImageSize:(CGSize)imageSize {
//    _imageSize = imageSize;
//    [self initDeckView];
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    if (self.contentOffset.x > 0)
//    {
//        float sectionSize = _cardImageList.count * _imageSize.width/2;
//        
//        if (self.contentOffset.x <= (sectionSize - sectionSize/2))
//        {
//            self.contentOffset = CGPointMake(sectionSize * 2 - sectionSize/2, 0);
//        } else if (self.contentOffset.x >= (sectionSize * 3 + sectionSize/2)) {
//            self.contentOffset = CGPointMake(sectionSize * 2 + sectionSize/2, 0);
//        }
//        
//        [self reloadView:self.contentOffset.x];
//    }
//}
//
//- (void)reloadView:(float)offset
//{
//    float biggestSize = 0;
//    id biggestView;
//    
//    for (int i = 0; i < _imageButtonStore.count; i++) {
//        
//        UIButton *view = [_imageButtonStore objectAtIndex:i];
//        
//        if (view.center.x > (offset - _imageSize.width/2 ) && view.center.x < (offset + self.frame.size.width + _imageSize.width/2))
//        {
//            float tOffset = (view.center.x - offset) - self.frame.size.width/4;
//            
//            if (tOffset < 0 || tOffset > self.frame.size.width) tOffset = 0;
//            float addHeight = (-1 * fabsf((tOffset)*2 - self.frame.size.width/2) + self.frame.size.width/2)/4;
//            
//            if (addHeight < 0) addHeight = 0;
//            
//            view.frame = CGRectMake(view.frame.origin.x,
//                                    self.frame.size.height - _itemSize.height - heightOffset - (addHeight/positionRatio),
//                                    _itemSize.width + addHeight,
//                                    _itemSize.height + addHeight);
//            
//            if (((view.frame.origin.x + view.frame.size.width) - view.frame.origin.x) > biggestSize)
//            {
//                biggestSize = ((view.frame.origin.x + view.frame.size.width) - view.frame.origin.x);
//                biggestView = view;
//            }
//            
//        } else {
//            view.frame = CGRectMake(view.frame.origin.x, self.frame.size.height, _itemSize.width, _itemSize.height);
//            for (UIImageView *imageView in view.subviews)
//            {
//                imageView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//            }
//        }
//    }
//    
//    for (int i = 0; i < imageStore.count; i++)
//    {
//        UIView *cBlock = [imageStore objectAtIndex:i];
//        cBlock.alpha = alphaOfobjs;
//        
//        if (i > 0)
//        {
//            UIView *pBlock = [imageStore objectAtIndex:i-1];
//            cBlock.frame = CGRectMake(pBlock.frame.origin.x + pBlock.frame.size.width, cBlock.frame.origin.y, cBlock.frame.size.width, cBlock.frame.size.height);
//        }
//    }
//    
//    [(UIView *)biggestView setAlpha:1.0];
//    dispatch_async(dispatch_get_main_queue(), ^ {
//        
//        SEL selector = @selector(infiniteScrollPicker:didMoveToImage:);
//        if ([[self firstAvailableUIViewController] respondsToSelector:selector])
//        {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//            UIImageView *view = (UIImageView *)biggestView;
//            [[self firstAvailableUIViewController] performSelector:selector withObject:self withObject:view.image];
//#pragma clang diagnostic pop
//        }
//        
//    });
//}
//
//@end
