//
//  MBProgressHUD+Tools.m
//  Mook
//
//  Created by 陈林 on 16/4/14.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "MBProgressHUD+Tools.h"

@implementation MBProgressHUD (Tools)

+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title {
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    return hud;
}

+ (void)showGlobalProgressHUDWithTitle:(NSString *)title hideAfterDelay:(NSTimeInterval)delay {
    
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    [hud hide:YES afterDelay:delay];
}


+ (void)dismissGlobalHUD {
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    [MBProgressHUD hideHUDForView:window animated:YES];
}

+ (void)showAnimated:(BOOL)animated whileExecutingBlockOnGloableQueue:(dispatch_block_t)block completionBlock:(MBProgressHUDCompletionBlock)completion {
    
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    [hud showAnimated:YES whileExecutingBlock:block onQueue:dispatch_get_global_queue(0, 0) completionBlock:completion];
}


@end
