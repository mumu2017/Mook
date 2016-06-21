//
//  CLGetMediaTool.m
//  Mook
//
//  Created by 陈林 on 16/6/21.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLGetMediaTool.h"
#import <MobileCoreServices/MobileCoreServices.h> // needed for video types

@interface CLGetMediaTool ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation CLGetMediaTool

#pragma mark - Public Methods
+(instancetype)getInstance{
    static CLGetMediaTool* getMediaTool = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        getMediaTool = [[CLGetMediaTool alloc] init];
//        takephoto.ratio = -1;
    });
    return getMediaTool;
}

//- (void)pickAlbumPhotoFromCurrentController:(UIViewController *)controller  completion:(CompletionBlock)completion {
//    
//    _controller = controller;
//    _completion = completion;
//    
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate = self;
//    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    
//    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    imagePicker.allowsEditing = YES;
//    
//    [controller presentViewController:imagePicker animated:YES completion:nil];
//}

- (void)pickAlbumMediaFromCurrentController:(UIViewController *)controller maximumDuration:(CGFloat)duration completion:(CompletionBlock)completion {
    
    _controller = controller;
    _completion = completion;
    
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self;
    videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    videoPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [videoPicker setMediaTypes:[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]];
//    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    
    videoPicker.allowsEditing = YES;
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    videoPicker.videoMaximumDuration = duration;
    
    [controller presentViewController:videoPicker animated:YES completion:nil];
}


//- (void)takePhotoFromCurrentController:(UIViewController *)controller  completion:(CompletionBlock)completion {
//    
//    _controller = controller;
//    _completion = completion;
//    
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate = self;
//    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    imagePicker.allowsEditing = YES;
//    
//    [controller presentViewController:imagePicker animated:YES completion:nil];
//}

- (void)loadCameraFromCurrentViewController:(UIViewController *)controller maximumDuration:(CGFloat)duration completion:(CompletionBlock)completion {
    
    _controller = controller;
    _completion = completion;
    
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self;
    videoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // 设置mediaTypes为所有的类型,这样照相机界面就可以自由切换图片和视频.
    [videoPicker setMediaTypes:[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]];
//     [NSArray arrayWithObject:(NSString *)kUTTypeMovie]];
    videoPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    videoPicker.videoMaximumDuration = duration;
    
    videoPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    videoPicker.allowsEditing = YES;
    
    [controller presentViewController:videoPicker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获取选择的媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 如果是图片
    if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage *image= [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //如果根据设置保存图片到系统相册
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kSavePhotoKey]) {
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
            {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
        }
        
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
//        if (_imageBlock) {
//            _imageBlock(image);
//        }
        if (_completion) {
            _completion(nil, image);
        }
        // 如果是视频
    } else if ([mediaType isEqualToString:@"public.movie"]) {
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kSaveVideoKey]) {
            NSString *tempFilePath = [videoURL path];
            
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(tempFilePath))
            {
                // Copy it to the camera roll.
                UISaveVideoAtPathToSavedPhotosAlbum(tempFilePath, self, @selector(video:didFinishSavingWithError:contextInfo:), (__bridge void * _Nullable)(tempFilePath));
            }
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
//        if (_videoBlock) {
//            _videoBlock(videoURL);
//        }
        if (_completion) {
            _completion(videoURL, nil);
        }
    }

}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    //    NSLog(@"Finished saving video with error: %@", error);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


@end
