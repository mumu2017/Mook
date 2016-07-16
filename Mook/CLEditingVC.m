//
//  CLEditingVC.m
//  Mook
//
//  Created by 陈林 on 15/12/7.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLEditingVC.h"
#import "CLEdtingManageVC.h"
#import "CLQuickStringNavVC.h"
#import "CLDataSaveTool.h"
#import "CLGetMediaTool.h"
#import "CLAudioPlayTool.h"
#import "CLToolBar.h"
#import "CLMediaView.h"

#import "CLEffectModel.h"
#import "CLPropModel.h"
#import "CLPrepModel.h"
#import "CLPerformModel.h"
#import "CLNotesModel.h"

#import "CLSleightObjModel.h"
#import "CLLinesObjModel.h"
#import "CLPropObjModel.h"

#import "CLInfoModel.h"

#import "CLGetMediaTool.h"

#import "XLPagerTabStripViewController.h"

#import "IATConfig.h"
#import "PopupView.h"
#import "ISRDataHelper.h"

@interface CLEditingVC ()<CLToolBarDelegate, CLQuickStringNavDelegate, UITextViewDelegate, UINavigationControllerDelegate, XLPagerTabStripChildItem, CLEdtingManageVCDelegate>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *audioName;


@property (nonatomic, assign) BOOL isWithVideo;
@property (nonatomic, assign) BOOL isWithImage;
@property (nonatomic, assign) BOOL isWithAudio;

@property (nonatomic, assign) BOOL didMakeChange;

@property (nonatomic, strong) NSMutableArray *propObjModelList;
@property (nonatomic, strong) NSMutableArray *linesObjModelList;
@property (nonatomic, strong) NSMutableArray *sleightObjModelList;


@property (nonatomic, assign) CGFloat videoDuration;

- (IBAction)editingFinished:(id)sender;

@end

@implementation CLEditingVC

- (CGFloat)videoDuration {
    
    if (self.editingContentType == kEditingContentTypeRoutine) {
        if (self.editingModel == kEditingModeEffect) {
            _videoDuration = 180;
        } else {
            _videoDuration = 15;
        }
    } else {
        if (self.editingModel == kEditingModeEffect) {
            _videoDuration = 30;
        } else {
            _videoDuration = 10;
        }
    }
    
    return _videoDuration;
}

- (NSMutableArray *)propObjModelList {
    if (!_propObjModelList) {
        _propObjModelList = [(AppDelegate *)[[UIApplication sharedApplication] delegate] propObjModelList];
        
    }
    return _propObjModelList;
}

- (NSMutableArray *)linesObjModelList {
    if (!_linesObjModelList) {
        _linesObjModelList = [(AppDelegate *)[[UIApplication sharedApplication] delegate] linesObjModelList];
    }
    return _linesObjModelList;
}

-(NSMutableArray *)sleightObjModelList {
    if (!_sleightObjModelList) {
        _sleightObjModelList = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sleightObjModelList];
    }
    
    return _sleightObjModelList;
}



#pragma mark - 懒加载view
- (CLMediaView *)mediaView {
    if (!_mediaView) {
        _mediaView = [CLMediaView mediaView];
        _mediaView.alpha = 0.0f;
        _mediaView.isEditing = YES;
        UIView *windowView = [[UIApplication sharedApplication] keyWindow];
        [windowView addSubview:_mediaView];
        
        _mediaView.frame = CGRectMake(0, 0, kImageDisplayW, kImageDisplayH);
        _mediaView.center = windowView.center;
        [_mediaView showWhiteBorder];
        
    }
    
    return _mediaView;
}

- (CLToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [CLToolBar toolBar];
        
        _toolBar.backgroundColor = kDisplayBgColor;
        _toolBar.tbDelegate = self;
    }
    
    return _toolBar;
}

#pragma mark - 选择快捷输入短语代理方法
- (void)quickStringNavVC:(CLQuickStringNavVC *)quickStringNavVC didSelectQuickString:(NSString *)quickString {
    
    NSString *text = self.editTextView.text;
    NSString *newText = quickString;
    
    if (text.length == 0) {
        self.editTextView.text = newText;
        [self.editTextView hidePlaceHolder];
    } else {
        self.editTextView.text = [text stringByAppendingString:newText];
    }
    
    [self saveText:self.editTextView];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter

- (void)setEditingModel:(EditingMode)editingModel {
    _editingModel = editingModel;
    
    switch (editingModel) {
        case kEditingModeEffect:
            
            if (self.editingContentType == kEditingContentTypeLines) {
                self.toolBar.imageButton.hidden = YES;
            } else {
                self.toolBar.imageButton.hidden = NO;

            }
            
            self.toolBar.addButton.hidden = YES;
            self.toolBar.deleteButton.hidden = YES;

            break;
            
        case kEditingModePrep:

            break;
            
        case kEditingModePerform:

            break;
            
        case kEditingModeNotes:
            self.toolBar.imageButton.hidden = YES;

            break;
            
        default:
            break;
    }
}

#pragma mark - Controller 方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self mediaView];
    
    [self setDisplayData];
    [self setTextView];
    [self registerForNotifications];

    if (self.manageVC != nil) {
        self.manageVC.editDelegate = self;
    }
    
}

- (void)setTextView {
    
    self.editTextView.inputAccessoryView = self.toolBar;
    self.editTextView.delegate = self;
    self.editTextView.tintColor = kMenuBackgroundColor;
    
    if (self.editingContentType == kEditingContentTypeShow) {
        [self.editTextView addPlaceHolderWithText:NSLocalizedString(@"请输入演出说明,任何内容都可以", nil) andFont:kFontSys16];
        
    } else if (self.editingContentType == kEditingContentTypeLines) {
        
        [self.editTextView addPlaceHolderWithText:NSLocalizedString(@"写点儿好玩儿的台词吧...", nil) andFont:kFontSys16];
        
    } else {
        
        
        NSString *ph1, *ph2, *ph3, *ph4, *ph5;
        ph1 = NSLocalizedString(@"提示:左右滑动屏幕可切换编辑内容", nil);
        ph2 = NSLocalizedString(@"提示:点击话筒按钮可以语音输入", nil);
        ph3 = NSLocalizedString(@"提示:点击相机按钮可以插入多媒体", nil);
        ph4 = NSLocalizedString(@"提示:常用短语可以添加到快捷短语", nil);
        ph5 = NSLocalizedString(@"提示:点击加号按钮可快速添加内容", nil);
        
        NSArray *placeHolder = @[ph1, ph2, ph3, ph4, ph5];
        NSInteger index = arc4random_uniform(5);
        
        [self.editTextView addPlaceHolderWithText:placeHolder[index] andFont:kFontSys16];
    }

    
    if ([self.editTextView hasText]) {
        [self.editTextView hidePlaceHolder];
    } else {
        [self.editTextView showPlaceHolder];
    }
}

- (void)setDisplayData {
    
    switch (self.editingModel) {
        case kEditingModeEffect:
            self.editTextView.text = self.effectModel.effect;
            self.imageName = self.effectModel.image;
            self.videoName = self.effectModel.video;
            self.audioName = self.effectModel.audio;
            break;
            
        case kEditingModePrep:
            self.editTextView.text = self.prepModel.prep;
            self.imageName = self.prepModel.image;
            self.videoName = self.prepModel.video;
            self.audioName = self.prepModel.audio;

            break;
            
        case kEditingModePerform:
            self.editTextView.text = self.performModel.perform;
            self.imageName = self.performModel.image;
            self.videoName = self.performModel.video;
            self.audioName = self.performModel.audio;

            break;
            
        case kEditingModeNotes:
            self.editTextView.text = self.notesModel.notes;
            self.audioName = self.notesModel.audio;

            break;
            
        default:
            break;
    }
}

- (void)setToolBarImage { // 加载工具栏图片
    if (self.isWithVideo) {
        [self.toolBar setButtonImageWithVideoName:self.videoName];
        
    } else if (self.isWithImage) {
        [self.toolBar setButtonImageWithImageName:self.imageName];
        
    }
    
    if (self.isWithAudio) {
        UIImage *image = [kToolBarVoiceImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.toolBar.previousButton setImage:image forState:UIControlStateNormal];
        self.toolBar.previousButton.tintColor = [UIColor redColor];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.didMakeChange = NO;
    
    if ([self.editTextView isFirstResponder] == NO) {
        [self.editTextView becomeFirstResponder];

    }
        
    if ([self.toolBar.imageButton backgroundImageForState:UIControlStateNormal] == nil) {
        [self setToolBarImage];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear: animated];
    
    if (self.didMakeChange) {
        // 别忘了道具编辑页面和演出编辑页面
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidMakeChangeNotification object:nil];
    }
    
    if ([self.delegate respondsToSelector:@selector(editingVCCancelAudioRecognition:)]) {
        [self.delegate editingVCCancelAudioRecognition:self];
    }
}

// Call this method somewhere in your view controller setup code.
- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShown:(NSNotification*)aNotification
{    
    NSDictionary* info = [aNotification userInfo];

    CGFloat aniTime = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 当键盘要出现时,将Mediaview设置为不可见,且数据归零.
    if (self.mediaView.alpha == 1.0f) {
        [UIView animateWithDuration:aniTime animations:^{
            self.mediaView.alpha = 0.0f;
        }];
    }
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 3, 0.0);
    self.editTextView.contentInset = contentInsets;
    self.editTextView.scrollIndicatorInsets = contentInsets;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.editTextView.contentInset = contentInsets;
    self.editTextView.scrollIndicatorInsets = contentInsets;
    
    // 键盘弹下去表示编辑完成, 所以要更新数据库中视频的文本信息
    if (self.isWithVideo) {
        [CLDataSaveTool updateVideoByName:self.videoName withContent:self.editTextView.text];
    } else if (self.isWithImage) {
        [CLDataSaveTool updateImageByName:self.imageName withContent:self.editTextView.text];
    }
    
}


- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 跳转方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id destVC = segue.destinationViewController;
    if ([destVC isKindOfClass:[CLQuickStringNavVC class]]) {
        CLQuickStringNavVC *vc = (CLQuickStringNavVC *)destVC;
        vc.navDelegate = self;
    }
}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    NSString *title = @"";
    
    if (self.editingContentType == kEditingContentTypeRoutine) {
        if (self.editingModel == kEditingModeEffect) {
            title = NSLocalizedString(@"效果", nil);
            
        } else if (self.editingModel == kEditingModePrep) {
            title = NSLocalizedString(@"准备", nil);
        } else if (self.editingModel == kEditingModePerform) {
            title = NSLocalizedString(@"表演", nil);

        } else if (self.editingModel == kEditingModeNotes) {
            title = NSLocalizedString(@"注意", nil);
        }
        
        
    } else if (self.editingContentType == kEditingContentTypeLines) {
        if (self.editingModel == kEditingModeEffect) {
            title = NSLocalizedString(@"台词", nil);
        }
    } else {
        if (self.editingModel == kEditingModeEffect) {
            title = NSLocalizedString(@"描述", nil);
        } else if (self.editingModel == kEditingModePrep) {
            title = NSLocalizedString(@"细节", nil);
        }
    }
    
    return title;
}

-(UIColor *)colorForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return [UIColor blackColor];
}

#pragma mark - 数据处理 方法
- (IBAction)editingFinished:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - toolBar 代理方法

- (void)toolBar:(CLToolBar *)toolBar didClickButton:(UIButton *)button {
    
    if (button == toolBar.imageButton) {
        
        if (self.isWithVideo == NO && self.isWithImage == NO) {
            
            [self addMedia];
            
        } else if (self.isWithImage) {
            
            [self deleteImage];
            
        } else if (self.isWithVideo) {
            
            [self deleteVideo];
        }

    } else if (button == toolBar.previousButton) {
        
        if (self.isWithAudio) {
            [self deleteAudio];
            
        } else {
            [self addAudio];

        }
        
    } else if (button == toolBar.nextButton) {

        if ([self.delegate respondsToSelector:@selector(editingVC:startAudioRecognitionWithContent:andIdentifierTag:)]) {
            
            UIImage *image = [kToolBarWriteImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.toolBar.nextButton setImage:image forState:UIControlStateNormal];
            
            [self.delegate editingVC:self startAudioRecognitionWithContent:self.editTextView.text andIdentifierTag:self.identifierTag];
        }
        
    } else if (button == toolBar.addButton) {
        
        switch (self.editingModel) {
            case kEditingModePrep:
                [self addPrep];
                break;
                
            case kEditingModePerform:
                [self addPerform];
                break;
                
            case kEditingModeNotes:
                [self addNotes];
                break;
                
            default:
                break;
        }
        
    } else if (button == toolBar.deleteButton) {
        
        switch (self.editingModel) {
            case kEditingModePrep:
                [self deletePrep];
                break;
                
            case kEditingModePerform:
                [self deletePerform];
                break;
                
            case kEditingModeNotes:
                [self deleteNotes];
                break;
                
            default:
                break;
        }
    }
}

- (void)editingManageVC:(CLEdtingManageVC *)edtingManageVC didFinishWithAudioRecognizeResult:(NSString *)result currentIdentifierTag:(NSInteger)identifierTag {
    
    if (self.identifierTag == identifierTag) { // 如果和editingManageVC中的currentIden
        self.editTextView.text = result;
        [self updateTextView:self.editTextView];
        
        UIImage *image = [kToolBarWriteImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.toolBar.nextButton setImage:image forState:UIControlStateNormal];
    }

}

- (void)addPrep {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *str;
    
    if (self.editingContentType == kEditingContentTypeRoutine) {
        str = NSLocalizedString(@"添加准备", nil);
    } else {
        str = NSLocalizedString(@"添加细节", nil);

    }
    
    UIAlertAction* add = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(editingVCAddPrep:)]) {
                [self.delegate editingVCAddPrep:self];
            }
        });
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:add];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)addPerform {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* add = [UIAlertAction actionWithTitle:NSLocalizedString(@"添加表演", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(editingVCAddPerform:)]) {
                [self.delegate editingVCAddPerform:self];
            }
        });
        
       
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:add];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)addNotes {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* add = [UIAlertAction actionWithTitle:NSLocalizedString(@"添加注意", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(editingVCAddNotes:)]) {
                [self.delegate editingVCAddNotes:self];
            }
        });
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:add];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deletePrep {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *deleteMessage;
    if (self.editingContentType == kEditingContentTypeRoutine) {
        deleteMessage = NSLocalizedString(@"删除准备", nil);
    } else {
        deleteMessage = NSLocalizedString(@"删除细节", nil);
    }
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:deleteMessage style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(editingVCDeletePrep:)]) {
                [self.delegate editingVCDeletePrep:self];
            }
        });
        
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)deletePerform {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除表演", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(editingVCDeletePerform:)]) {
                [self.delegate editingVCDeletePerform:self];
            }
        });
        
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}


- (void)deleteNotes {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除注意", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(editingVCDeleteNotes:)]) {
                [self.delegate editingVCDeleteNotes:self];
            }
        });
       
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (BOOL)isWithVideo {
    
    if (self.videoName.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString videoPath] stringByAppendingPathComponent:self.videoName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

- (BOOL)isWithImage {
    
    if (self.imageName.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString imagePath] stringByAppendingPathComponent:self.imageName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

- (BOOL)isWithAudio {
    if (self.audioName.length == 0) {
        return NO;
    }
    
    NSString *path = [[NSString audioPath] stringByAppendingPathComponent:self.audioName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    return fileExists;
}

#pragma mark 添加多媒体
- (void)addMedia {
        
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (self.editingModel == kEditingModeEffect || self.editingModel == kEditingModePrep || self.editingModel == kEditingModePerform) {
        
        UIAlertAction* recordMedia = [UIAlertAction actionWithTitle:NSLocalizedString(@"相机拍摄", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[CLGetMediaTool getInstance] loadCameraFromCurrentViewController:self maximumDuration:self.videoDuration completion:^(NSURL *videoURL, UIImage *photo) {
                    
                    if (videoURL) {
                        [self saveVideo:videoURL];
                    } else if (photo) {
                        [self saveImage:photo];
                    }
                }];
            });
            
            
            
        }];
        
        UIAlertAction* pickMedia = [UIAlertAction actionWithTitle:NSLocalizedString(@"相册导入", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[CLGetMediaTool getInstance] pickAlbumMediaFromCurrentController:self maximumDuration:self.videoDuration completion:^(NSURL *videoURL, UIImage *photo) {
                    
                    if (videoURL) {
                        [self saveVideo:videoURL];
                    } else if (photo) {
                        [self saveImage:photo];
                    }
                }];

            });
            
        }];
        
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            
        }];
        
        [alert addAction:recordMedia];
        [alert addAction:pickMedia];
        [alert addAction:cancel];

    }
  
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 删除多媒体
- (void)deleteImage {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.mediaView setImageWithName:self.imageName];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mediaView.alpha = 1.0f;
    }];

    UIAlertAction* deletePhoto = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除图片", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 如果发生了编辑改变, 则将发生编辑的状态设置为YES
            self.didMakeChange = YES;
            
            [self.imageName deleteNamedImageFromDocument];
            [CLDataSaveTool deleteMediaByName:self.imageName];
            self.imageName = nil;
            self.toolBar.imageName = nil;
            [self.mediaView setImageWithName:nil];
            
        });
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:deletePhoto];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{

    }];
}

- (void)deleteVideo {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.mediaView setVideoWithName:self.videoName];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mediaView.alpha = 1.0f;
    }];
    
    UIAlertAction* deletePhoto = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除视频", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 如果发生了编辑改变, 则将发生编辑的状态设置为YES
            self.didMakeChange = YES;
            
            [self.videoName deleteNamedVideoFromDocument];
            [CLDataSaveTool deleteMediaByName:self.videoName];
            self.videoName = nil;
            self.toolBar.videoName = nil;
            [self.mediaView setVideoWithName:nil];
            
        });
        
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {

    }];
    
    [alert addAction:deletePhoto];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)deleteAudio {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction* playAudio = [UIAlertAction actionWithTitle:NSLocalizedString(@"播放录音", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [CLAudioPlayTool playAudioFromCurrentController:self audioPath:[self.audioName getNamedAudio]];
            
        });
        
    }];
    
    UIAlertAction* deleteAudio = [UIAlertAction actionWithTitle:NSLocalizedString(@"删除录音", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // 如果发生了编辑改变, 则将发生编辑的状态设置为YES
            self.didMakeChange = YES;
            
            [self.audioName deleteNamedAudioFromDocument];
            [CLDataSaveTool deleteMediaByName:self.audioName];
            self.audioName = nil;
            
            UIImage *image = [kToolBarVoiceImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [self.toolBar.previousButton setImage:image forState:UIControlStateNormal];
            
        });
        
    }];

    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }];
    
    [alert addAction:playAudio];
    [alert addAction:deleteAudio];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) saveImage:(UIImage *)image {
    
    // 如果发生了编辑改变, 则将发生编辑的状态设置为YES
    self.didMakeChange = YES;
    
    NSString *imageName = [kTimestamp stringByAppendingString:@".jpg"];
    
    [imageName saveNamedImageToDocument:image];
    [CLDataSaveTool addImageByName:imageName timesStamp:self.timeStamp content:self.editTextView.text type:[self getModelType]];
    
    self.imageName = imageName;
    
    switch (self.editingModel) {
        case kEditingModeEffect:
            self.effectModel.image = imageName;
            
            break;
            
        case kEditingModePrep:
            self.prepModel.image = imageName;
            
            break;
            
        case kEditingModePerform:
            self.performModel.image = imageName;
            break;
            
        default:
            break;
    }

    [self.toolBar setButtonImage:image];
}

#pragma mark 设置cell视频
- (void)saveVideo:(NSURL *)videoURL {
    
    // 如果发生了编辑改变, 则将发生编辑的状态设置为YES
    self.didMakeChange = YES;
    
    NSString *videoName = [kTimestamp stringByAppendingString:@".mp4"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [videoName saveNamedVideoToDocument:videoURL];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.toolBar setButtonImageWithVideoName:videoName];

        });
    });
    
    [CLDataSaveTool addVideoByName:videoName timesStamp:self.timeStamp content:self.editTextView.text type:[self getModelType]];
    self.videoName = videoName;
    
    switch (self.editingModel) {
        case kEditingModeEffect:
            self.effectModel.video = videoName;
            
            break;
            
        case kEditingModePrep:
            self.prepModel.video = videoName;
            
            break;
            
        case kEditingModePerform:
            self.performModel.video = videoName;
            break;
            
        default:
            break;
    }
}


- (void)addAudio {
    
    [[CLGetMediaTool getInstance] recordAudioFromCurrentController:self audioBlock:^(NSString *filePath) {
        
        NSString *audioName = [kTimestamp stringByAppendingString:@".m4a"];
        [audioName saveNamedAudioToDocument:filePath];
        self.audioName = audioName;

        switch (self.editingModel) {
            case kEditingModeEffect:
                self.effectModel.audio = audioName;
                
                break;
                
            case kEditingModePrep:
                self.prepModel.audio = audioName;
                
                break;
                
            case kEditingModePerform:
                self.performModel.audio = audioName;
                break;
                
            case kEditingModeNotes:
                self.notesModel.audio = audioName;
                break;
                
            default:
                break;
        }
        
        //修改按鈕圖片的顏色
        UIImage *image = [kToolBarVoiceImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.toolBar.previousButton setImage:image forState:UIControlStateNormal];
        self.toolBar.previousButton.tintColor = [UIColor redColor];
        
        [CLDataSaveTool addAudioByName:audioName timesStamp:self.timeStamp content:nil type:[self getModelType]];
    }];
}

#pragma mark - textView 代理方法
- (void)textViewDidChange:(UITextView *)textView {
    
    // 如果发生了编辑改变, 则将发生编辑的状态设置为YES
    self.didMakeChange = YES;
    
    if (textView == self.editTextView) {
        if (!textView.hasText) {
            [textView showPlaceHolder];
        } else {
            [textView hidePlaceHolder];
        }
        
        // 如果输入@, 弹出快捷短语选项
        // Create the predicate
        NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"SELF endswith %@", @"@"];
        NSString *oldString = textView.text;
        // Run the predicate
        // match == YES if the predicate is successful
        BOOL match = [myPredicate evaluateWithObject:textView.text];
        if (match) {
            NSString *newString = [oldString substringToIndex:[oldString length]-1];
            textView.text = newString;
            [self performSegueWithIdentifier:kQuickStringSegue sender:nil];
        }
        
        [self saveText:textView];
    }
}

- (void)updateTextView:(UITextView *)textView {
    // 如果发生了编辑改变, 则将发生编辑的状态设置为YES
    self.didMakeChange = YES;
    
    if (textView == self.editTextView) {
        if (!textView.hasText) {
            [textView showPlaceHolder];
        } else {
            [textView hidePlaceHolder];
        }
        
        [self saveText:textView];
    }
}

- (void)saveText:(UITextView *)textView {

    switch (self.editingModel) {
        case kEditingModeEffect:
            self.effectModel.effect = textView.text;
            
            break;
            
        case kEditingModePrep:
            self.prepModel.prep = textView.text;
            
            break;
            
        case kEditingModePerform:
            self.performModel.perform = textView.text;
            break;
            
        case kEditingModeNotes:
            self.notesModel.notes = textView.text;
            break;
            
        default:
            break;
    }

}

#pragma mark - Helpers

- (NSString *)getModelType {
    
    NSString *type;
    
    switch (self.editingContentType) {
        case kEditingContentTypeShow:
            type = kTypeShow;
            break;
            
        case kEditingContentTypeIdea:
            type = kTypeIdea;
            break;
            
        case kEditingContentTypeRoutine:
            type = kTypeRoutine;
            break;
            
        case kEditingContentTypeSleight:
            type = kTypeSleight;
            break;
            
            
        case kEditingContentTypeProp:
            type = kTypeProp;
            break;
            
            
        case kEditingContentTypeLines:
            type = kTypeLines;
            break;
            
        default:
            break;
    }
    return type;
}

@end
