//
//  CLOneLabelImageDisplayCell.m
//  Mook
//
//  Created by 陈林 on 15/12/12.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLOneLabelImageDisplayCell.h"
#define ZOOM_STEP 2.0

@interface CLOneLabelImageDisplayCell()<UIGestureRecognizerDelegate, UIScrollViewDelegate>

@end

@implementation CLOneLabelImageDisplayCell


- (void)setImageWithName:(NSString *)imageName {
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    UIImage *scaledImage = [image imageByScalingProportionallyToSize:self.imageContainer.bounds.size];
    [self.contentImageView setImage:image];
}

- (void)setImageWithVideoName:(NSString *)videoName {
    [self.contentImageView setImage:[videoName getFirstFrameOfNamedVideo]];
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.contentImageView;
}

//-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
//}
//
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
//    
//}

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    if (scrollView.zoomScale != scrollView.minimumZoomScale) {
//
//    }
//}

- (void)awakeFromNib {
    // Initialization code
    self.imageContainer.delegate = self;
    self.imageContainer.minimumZoomScale = 1.0;
    self.imageContainer.maximumZoomScale = 4.0;
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setDelegate:self];
    [doubleTap setNumberOfTapsRequired:2];
    
    //Adding gesture recognizer
    [self.imageContainer addGestureRecognizer:doubleTap];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // zoom in
    float newScale = [self.imageContainer zoomScale] * ZOOM_STEP;
    
    if (newScale> self.imageContainer.maximumZoomScale){
        newScale        = self.imageContainer.minimumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        
        [self.imageContainer zoomToRect:zoomRect animated:YES];
        
    }
    else{
        
        newScale        = self.imageContainer.maximumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        
        [self.imageContainer zoomToRect:zoomRect animated:YES];
    }
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self.imageContainer bounds].size.height / scale;
    zoomRect.size.width  = [self.imageContainer bounds].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

@end
