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

#pragma mark - 快速添加

+ (void)quickAddNewShowFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image {
    
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

    
    [self showAlertControllerWithTextFieldFromCurrentController:controller comfirmHandler:^(NSString *title) {
        
        model.name = title;
        [CLDataSaveTool updateShow:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:self];
        
    } editMoreHandler:^(NSString *title) {
        
        model.name = title;

        //获取storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        CLNewShowNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newShowNav"];
        
        navVC.showModel = kDataListShow[0];
        
        [controller presentViewController:navVC animated:YES completion:nil];
    }];
    

}

+ (void)quickAddNewIdeaFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image {
    
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
    
    [self showAlertControllerWithTextFieldFromCurrentController:controller comfirmHandler:^(NSString *title) {
        
        model.infoModel.name = title;
        [CLDataSaveTool updateIdea:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:self];
        
    } editMoreHandler:^(NSString *title) {
        
        model.infoModel.name = title;
        
        //获取storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        CLNewEntryNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newEntryNav"];
        navVC.editingContentType = kEditingContentTypeIdea;
        navVC.ideaObjModel = kDataListIdea[0];
        
        [controller presentViewController:navVC animated:YES completion:nil];
    }];
    
}

+ (void)quickAddNewRoutineFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image {
    
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
    
    [self showAlertControllerWithTextFieldFromCurrentController:controller comfirmHandler:^(NSString *title) {
        
        model.infoModel.name = title;
        [CLDataSaveTool updateRoutine:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:self];
        
    } editMoreHandler:^(NSString *title) {
        
        model.infoModel.name = title;
        
        //获取storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        CLNewEntryNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newEntryNav"];
        navVC.editingContentType = kEditingContentTypeRoutine;
        navVC.routineModel = kDataListRoutine[0];
        
        [controller presentViewController:navVC animated:YES completion:nil];
    }];
    
}

+ (void)quickAddNewSleightFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image {
 
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
    
    [self showAlertControllerWithTextFieldFromCurrentController:controller comfirmHandler:^(NSString *title) {
        
        model.infoModel.name = title;
        [CLDataSaveTool updateSleight:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:self];
        
    } editMoreHandler:^(NSString *title) {
        
        model.infoModel.name = title;
        
        //获取storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        CLNewEntryNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newEntryNav"];
        navVC.editingContentType = kEditingContentTypeSleight;
        navVC.sleightObjModel = kDataListSleight[0];
        
        [controller presentViewController:navVC animated:YES completion:nil];
    }];

}

+ (void)quickAddNewPropFromCurrentController:(UIViewController *)controller withVideo:(NSURL *)videoURL orImage:(UIImage *)image {
    
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
    
    [self showAlertControllerWithTextFieldFromCurrentController:controller comfirmHandler:^(NSString *title) {
        
        model.infoModel.name = title;
        [CLDataSaveTool updateProp:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:self];
        
    } editMoreHandler:^(NSString *title) {
        
        model.infoModel.name = title;
        //获取storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        CLNewEntryNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newEntryNav"];
        navVC.editingContentType = kEditingContentTypeProp;
        navVC.propObjModel = kDataListProp[0];
        [controller presentViewController:navVC animated:YES completion:nil];
    }];

}

+ (void)quickAddNewLinesFromCurrentController:(UIViewController *)controller withAudio:(NSString *)filePath {
    
    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLLinesObjModel *model = [CLLinesObjModel linesObjModel];
    
    if (filePath) {
        NSString *audioName = [kTimestamp stringByAppendingString:@".m4a"];
        [audioName saveNamedAudioToDocument:filePath];
        model.effectModel.audio = audioName;
        [CLDataSaveTool addAudioByName:audioName timesStamp:model.timeStamp content:nil type:kTypeLines];
    }
    
    // 将新增的model放在数组第一个,这样在现实到list中时,新增的model会显示在最上面
    [kDataListLines insertObject:model atIndex:0];
    [kDataListAll insertObject:model atIndex:0];
    
    [self showAlertControllerWithTextFieldFromCurrentController:controller comfirmHandler:^(NSString *title) {
        
        model.infoModel.name = title;
        [CLDataSaveTool updateLines:model];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDataNotification object:self];
        
    } editMoreHandler:^(NSString *title) {
        
        model.infoModel.name = title;
        //获取storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        CLNewEntryNavVC *navVC = [storyboard instantiateViewControllerWithIdentifier:@"newEntryNav"];
        navVC.editingContentType = kEditingContentTypeLines;
        navVC.linesObjModel = kDataListLines[0];
        [controller presentViewController:navVC animated:YES completion:nil];
    }];

}


#pragma mark - 直接弹出NewEntryNavVC

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

+ (void)addNewLinesFromCurrentController:(UIViewController *)controller withAudio:(NSString *)filePath {

    // 创建一个新的routineModel,传递给newRoutineVC,并添加到routineModelList中
    CLLinesObjModel *model = [CLLinesObjModel linesObjModel];
    
    if (filePath) {
        NSString *audioName = [kTimestamp stringByAppendingString:@".m4a"];
        [audioName saveNamedAudioToDocument:filePath];
        model.effectModel.audio = audioName;
        [CLDataSaveTool addAudioByName:audioName timesStamp:model.timeStamp content:nil type:kTypeLines];
    }
    
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


#pragma mark - Helper

+ (void)showAlertControllerWithTextFieldFromCurrentController:(UIViewController *)controller comfirmHandler:(void (^ __nullable)(NSString * __nullable title))comfirmHandler editMoreHandler:(void (^ __nullable)(NSString * __nullable title)) editMoreHandler
{
    
    // 快捷输入框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"编辑标题", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(@"标题", nil);
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textField.font = kFontSys16;
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"保存笔记", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        

            
        UITextField *nameTF = alertController.textFields.firstObject;
            
        NSString *title = nameTF.text;
        comfirmHandler(title);

        
    }];
    
    UIAlertAction *editMore = [UIAlertAction actionWithTitle:NSLocalizedString(@"继续编辑", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *nameTF = alertController.textFields.firstObject;
        
        NSString *title = nameTF.text;

        editMoreHandler(title);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消保存", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
            
        });
        
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:editMore];
    [alertController addAction:cancel];
    
    [controller presentViewController:alertController animated:YES completion:^{

    }];
    
}

@end
