//
//  CLNewEntryTool.m
//  Mook
//
//  Created by 陈林 on 16/6/21.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLNewEntryTool.h"
#import "CLDataSaveTool.h"

#import "CLNewShowVC.h"
#import "CLNewEntryVC.h"
#import "CLNewEntryNavVC.h"
#import "CLNewShowNavVC.h"

#import "CLShowModel.h"
#import "CLIdeaObjModel.h"
#import "CLRoutineModel.h"
#import "CLSleightObjModel.h"
#import "CLPropObjModel.h"
#import "CLLinesObjModel.h"

#import "CLInfoModel.h"
#import "CLEffectModel.h"
#import "CLPropModel.h"
#import "CLPrepModel.h"
#import "CLPerformModel.h"

@implementation CLNewEntryTool

+ (void)addNewShowFromCurrentController:(UIViewController *)controller {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLShowModel *model = [CLShowModel showModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListShow insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    //获取storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CLNewShowNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newShowNav"];

    navVC.showModel = kDataListShow[0];
    
    [controller presentViewController:navVC animated:YES completion:nil];
}


+ (void)addNewShowFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLShowModel *model = [CLShowModel showModel];
    
    if (videoURL) {
        NSString *videoName = [kTimestamp stringByAppendingString:@".mp4"];
        [videoName saveNamedVideoToDocument:videoURL];
        
        model.effectModel.video = videoName;
        [CLDataSaveTool addVideoByName:videoName timesStamp:model.timeStamp content:nil type:kTypeShow];
    } else if (image) {
        NSString *imageName = [kTimestamp stringByAppendingString:@".jpg"];
        [imageName saveNamedImageToDocument:image];
        
        model.effectModel.image = imageName;
        [CLDataSaveTool addImageByName:imageName timesStamp:model.timeStamp content:nil type:kTypeShow];
    }
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListShow insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    //获取storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CLNewShowNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newShowNav"];
    
    navVC.showModel = kDataListShow[0];
    
    [controller presentViewController:navVC animated:YES completion:nil];
}

+ (void)addNewIdeaFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLIdeaObjModel *model = [CLIdeaObjModel ideaObjModel];
    
    if (videoURL) {
        NSString *videoName = [kTimestamp stringByAppendingString:@".mp4"];
        [videoName saveNamedVideoToDocument:videoURL];
        
        model.effectModel.video = videoName;
        [CLDataSaveTool addVideoByName:videoName timesStamp:model.timeStamp content:nil type:kTypeIdea];
    } else if (image) {
        NSString *imageName = [kTimestamp stringByAppendingString:@".jpg"];
        [imageName saveNamedImageToDocument:image];
        
        model.effectModel.image = imageName;
        [CLDataSaveTool addImageByName:imageName timesStamp:model.timeStamp content:nil type:kTypeIdea];
    }
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListIdea insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    //获取storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    CLNewEntryNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newEntryNav"];
    navVC.editingContentType = kEditingContentTypeIdea;
    navVC.ideaObjModel = kDataListIdea[0];
    
    [controller presentViewController:navVC animated:YES completion:nil];
}

+ (void)addNewRoutineFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLRoutineModel *model = [CLRoutineModel routineModel];
    
    if (videoURL) {
        NSString *videoName = [kTimestamp stringByAppendingString:@".mp4"];
        [videoName saveNamedVideoToDocument:videoURL];
        
        model.effectModel.video = videoName;
        [CLDataSaveTool addVideoByName:videoName timesStamp:model.timeStamp content:nil type:kTypeRoutine];
    } else if (image) {
        NSString *imageName = [kTimestamp stringByAppendingString:@".jpg"];
        [imageName saveNamedImageToDocument:image];
        
        model.effectModel.image = imageName;
        [CLDataSaveTool addImageByName:imageName timesStamp:model.timeStamp content:nil type:kTypeRoutine];
    }
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListRoutine insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    //获取storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    CLNewEntryNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newEntryNav"];
    navVC.editingContentType = kEditingContentTypeRoutine;
    navVC.routineModel = kDataListRoutine[0];
    
    [controller presentViewController:navVC animated:YES completion:nil];
}

+ (void)addNewSleightFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLSleightObjModel *model = [CLSleightObjModel sleightObjModel];
    
    if (videoURL) {
        NSString *videoName = [kTimestamp stringByAppendingString:@".mp4"];
        [videoName saveNamedVideoToDocument:videoURL];
        
        model.effectModel.video = videoName;
        [CLDataSaveTool addVideoByName:videoName timesStamp:model.timeStamp content:nil type:kTypeSleight];
    } else if (image) {
        NSString *imageName = [kTimestamp stringByAppendingString:@".jpg"];
        [imageName saveNamedImageToDocument:image];
        
        model.effectModel.image = imageName;
        [CLDataSaveTool addImageByName:imageName timesStamp:model.timeStamp content:nil type:kTypeSleight];
    }
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListSleight insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    //获取storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    CLNewEntryNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newEntryNav"];
    navVC.editingContentType = kEditingContentTypeSleight;
    navVC.sleightObjModel = kDataListSleight[0];
    
    [controller presentViewController:navVC animated:YES completion:nil];
}


+ (void)addNewPropFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLPropObjModel *model = [CLPropObjModel propObjModel];
    
    if (videoURL) {
        NSString *videoName = [kTimestamp stringByAppendingString:@".mp4"];
        [videoName saveNamedVideoToDocument:videoURL];
        
        model.effectModel.video = videoName;
        [CLDataSaveTool addVideoByName:videoName timesStamp:model.timeStamp content:nil type:kTypeProp];
    }  else if (image) {
        NSString *imageName = [kTimestamp stringByAppendingString:@".jpg"];
        [imageName saveNamedImageToDocument:image];
        
        model.effectModel.image = imageName;
        [CLDataSaveTool addImageByName:imageName timesStamp:model.timeStamp content:nil type:kTypeProp];
    }
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListProp insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    //获取storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    CLNewEntryNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newEntryNav"];
    navVC.editingContentType = kEditingContentTypeProp;
    navVC.propObjModel = kDataListProp[0];
    [controller presentViewController:navVC animated:YES completion:nil];

}

+ (void)addNewLinesFromCurrentController:(UIViewController *)controller {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLLinesObjModel *model = [CLLinesObjModel linesObjModel];
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListLines insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    //获取storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    CLNewEntryNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newEntryNav"];
    navVC.editingContentType = kEditingContentTypeLines;
    navVC.linesObjModel = kDataListLines[0];
    [controller presentViewController:navVC animated:YES completion:nil];
}

+ (void)addNewLinesWithAudio:(NSURL *)audioURL {
    
}

@end
