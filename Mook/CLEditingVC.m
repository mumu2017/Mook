//
//  CLEditingVC.m
//  Mook
//
//  Created by 陈林 on 15/12/7.
//  Copyright © 2015年 ChenLin. All rights reserved.
//

#import "CLEditingVC.h"
#import "CLQuickStringNavVC.h"
#import "CLDataSaveTool.h"
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

#import <MobileCoreServices/MobileCoreServices.h> // needed for video types
#import "XLPagerTabStripViewController.h"

@interface CLEditingVC ()<CLToolBarDelegate, CLQuickStringNavDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, XLPagerTabStripChildItem>

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger indexOfSelectedQuickString;
@property (nonatomic, assign) BOOL slectedStringUsed;

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *videoName;

@property (nonatomic, assign) BOOL isWithVideo;
@property (nonatomic, assign) BOOL isWithImage;

@property (nonatomic, strong) NSMutableArray *propObjModelList;
@property (nonatomic, strong) NSMutableArray *linesObjModelList;
@property (nonatomic, strong) NSMutableArray *sleightObjModelList;

@property (nonatomic, strong) NSMutableArray <NSString*> *quickStringList;

@property (nonatomic, assign) CGFloat videoDuration;

- (IBAction)editingFinished:(id)sender;

@end

@implementation CLEditingVC

- (CGFloat)videoDuration {
    
    if (self.editingContentType == kEditingContentTypeRoutine) {
        if (self.editingModel == kEditingModeEffect) {
            _videoDuration = 90;
        } else {
            _videoDuration = 10;
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

- (NSMutableArray *)quickStringList {
    if (!_quickStringList) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kQuickStringKey] == nil) {
            _quickStringList = [NSMutableArray array];
            
            [[NSUserDefaults standardUserDefaults] setObject:_quickStringList forKey:kQuickStringKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kQuickStringKey];
            _quickStringList = [array mutableCopy];
        }
        
    }
    return _quickStringList;
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

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 250)];
        
        _pickerView.backgroundColor = kDisplayBgColor;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    
    return _pickerView;
}

#pragma mark - pickerView datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.quickStringList.count;
}

#pragma mark - pickerView delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
   
    return kContentW;
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
//    return 36;
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* textLabel = (UILabel*)view;
    
    if (!textLabel){
        textLabel = [[UILabel alloc] init];
        textLabel.numberOfLines = 0;
        textLabel.textAlignment = NSTextAlignmentCenter;
    }

    textLabel.text = self.quickStringList[row];

    return textLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.indexOfSelectedQuickString = row;
    self.slectedStringUsed = NO;
            
}

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
//- (void)setEditingContentType:(EditingContentType)editingContentType {
//    
//    _editingContentType = editingContentType;
//    
//    if (editingContentType == kEditingContentTypeRoutine) {
//        if (self.editingModel == kEditingModeEffect) {
//            self.title = @"效果";
//        }
//    } else if (editingContentType == kEditingContentTypeLines) {
//        if (self.editingModel == kEditingModeEffect) {
//            self.title = @"台词";
//        }
//    } else {
//        if (self.editingModel == kEditingModeEffect) {
//            self.title = @"描述";
//        } else if (self.editingModel == kEditingModePrep) {
//            self.title = @"细节";
//        }
//    }
//}

- (void)setEditingModel:(EditingMode)editingModel {
    _editingModel = editingModel;
    
    switch (editingModel) {
        case kEditingModeEffect:
            self.toolBar.addButton.hidden = YES;
            self.toolBar.deleteButton.hidden = YES;
            [self.toolBar.previousButton setImage:kToolBarApproveImage forState:UIControlStateNormal];
            [self.toolBar.previousButton setImage:kToolBarApproveImageHighlighted forState:UIControlStateHighlighted];
            break;
            
        case kEditingModePrep:
            [self.toolBar.previousButton setImage:kToolBarApproveImage forState:UIControlStateNormal];
            [self.toolBar.previousButton setImage:kToolBarApproveImageHighlighted forState:UIControlStateHighlighted];
            break;
            
        case kEditingModePerform:
            [self.toolBar.previousButton setImage:kToolBarApproveImage forState:UIControlStateNormal];
            [self.toolBar.previousButton setImage:kToolBarApproveImageHighlighted forState:UIControlStateHighlighted];
            break;
            
        case kEditingModeNotes:
            self.toolBar.imageButton.hidden = YES;
            [self.toolBar.previousButton setImage:kToolBarApproveImage forState:UIControlStateNormal];
            [self.toolBar.previousButton setImage:kToolBarApproveImageHighlighted forState:UIControlStateHighlighted];
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
}

- (void)setTextView {
    
    self.editTextView.inputAccessoryView = self.toolBar;
    self.editTextView.delegate = self;
    self.editTextView.tintColor = kMenuBackgroundColor;
    [self.editTextView addPlaceHolderWithText:@"写点儿什么吧..." andFont:kFontSys16];
    
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
            break;
            
        case kEditingModePrep:
            self.editTextView.text = self.prepModel.prep;
            self.imageName = self.prepModel.image;
            self.videoName = self.prepModel.video;
            break;
            
        case kEditingModePerform:
            self.editTextView.text = self.performModel.perform;
            self.imageName = self.performModel.image;
            self.videoName = self.performModel.video;
            break;
            
        case kEditingModeNotes:
            self.editTextView.text = self.notesModel.notes;
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
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    if ([self.editTextView isFirstResponder] == NO) {
        [self.editTextView becomeFirstResponder];

    }
        
    if ([self.toolBar.imageButton backgroundImageForState:UIControlStateNormal] == nil) {
        [self setToolBarImage];
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
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
//        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
//    }
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
            title = @"效果";
            
        } else if (self.editingModel == kEditingModePrep) {
            title = @"准备";
        } else if (self.editingModel == kEditingModePerform) {
            title = @"表演";

        } else if (self.editingModel == kEditingModeNotes) {
            title = @"注意";
        }
        
        
    } else if (self.editingContentType == kEditingContentTypeLines) {
        if (self.editingModel == kEditingModeEffect) {
            title = @"台词";
        }
    } else {
        if (self.editingModel == kEditingModeEffect) {
            title = @"描述";
        } else if (self.editingModel == kEditingModePrep) {
            title = @"细节";
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
        
        [self.view endEditing:YES];
        
    } else if (button == toolBar.nextButton) {

        [self performSegueWithIdentifier:kQuickStringSegue sender:nil];
        
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


- (void)addPrep {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* add = [UIAlertAction actionWithTitle:@"添加准备" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(editingVCAddPrep:)]) {
                [self.delegate editingVCAddPrep:self];
            }
        });
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:add];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)addPerform {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* add = [UIAlertAction actionWithTitle:@"添加表演" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(editingVCAddPerform:)]) {
                [self.delegate editingVCAddPerform:self];
            }
        });
        
       
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:add];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)addNotes {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* add = [UIAlertAction actionWithTitle:@"添加注意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(editingVCAddNotes:)]) {
                [self.delegate editingVCAddNotes:self];
            }
        });
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:add];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deletePrep {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *deleteMessage;
    if (self.editingContentType == kEditingContentTypeRoutine) {
        deleteMessage = @"删除准备";
    } else {
        deleteMessage = @"删除细节";
    }
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:deleteMessage style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(editingVCDeletePrep:)]) {
                [self.delegate editingVCDeletePrep:self];
            }
        });
        
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)deletePerform {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:@"删除表演" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(editingVCDeletePerform:)]) {
                [self.delegate editingVCDeletePerform:self];
            }
        });
        
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:delete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}


- (void)deleteNotes {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* delete = [UIAlertAction actionWithTitle:@"删除注意" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.delegate respondsToSelector:@selector(editingVCDeleteNotes:)]) {
                [self.delegate editingVCDeleteNotes:self];
            }
        });
       
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
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



#pragma mark 添加多媒体
- (void)addMedia {
        
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (self.editingModel == kEditingModeEffect || self.editingModel == kEditingModePrep || self.editingModel == kEditingModePerform) {
        
        UIAlertAction* takeVideo = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self pickVideoFromCamera];
            });
            
            
            
        }];
        
        UIAlertAction* pickVideo = [UIAlertAction actionWithTitle:@"相册视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self pickVideoFromAlbum];

            });
            
        }];
        
        [alert addAction:takeVideo];
        [alert addAction:pickVideo];
    }
  
    UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:@"拍摄照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        prepCell.prepFrame.model.image = image;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self pickImageFromCamera];
            
        });
        
    }];
    
    UIAlertAction* pickPhoto = [UIAlertAction actionWithTitle:@"相册图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self pickImageFromAlbum];
            
        });
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }];
    

    [alert addAction:takePhoto];
    [alert addAction:pickPhoto];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 删除多媒体
- (void)deleteImage {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.mediaView setImageWithName:self.imageName];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mediaView.alpha = 1.0f;
    }];

    UIAlertAction* deletePhoto = [UIAlertAction actionWithTitle:@"删除图片" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.imageName deleteNamedImageFromDocument];
            [CLDataSaveTool deleteImageByName:self.imageName];
            self.imageName = nil;
            self.toolBar.imageName = nil;
            [self.mediaView setImageWithName:nil];
            
        });
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
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
    
    UIAlertAction* deletePhoto = [UIAlertAction actionWithTitle:@"删除视频" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.videoName deleteNamedVideoFromDocument];
            [CLDataSaveTool deleteVideoByName:self.videoName];
            self.videoName = nil;
            self.toolBar.videoName = nil;
            [self.mediaView setVideoWithName:nil];
            
        });
        
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {

    }];
    
    [alert addAction:deletePhoto];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark 从用户相册获取活动图片
- (void)pickImageFromAlbum
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark 拍摄照片
- (void)pickImageFromCamera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark 从相册获取活动视频
- (void)pickVideoFromAlbum {
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self;
    videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    videoPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    
    videoPicker.allowsEditing = YES;
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    videoPicker.videoMaximumDuration = self.videoDuration;
    
    [self presentViewController:videoPicker animated:YES completion:nil];
}


#pragma mark 拍摄视频
- (void)pickVideoFromCamera
{
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self;
    videoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [videoPicker setMediaTypes: [NSArray arrayWithObject:(NSString *)kUTTypeMovie]];
    videoPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    videoPicker.videoMaximumDuration = self.videoDuration;
    
    videoPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    videoPicker.allowsEditing = YES;
    
    [self presentViewController:videoPicker animated:YES completion:nil];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
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
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self saveImage:image];
        
        
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
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self saveVideo:videoURL];
    }
    
    UIView *view = [UIResponder currentFirstResponder];
    
    if (view != self.editTextView) {
        [view resignFirstResponder];
        [self.editTextView becomeFirstResponder];
    }
}

- (void) video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"Finished saving video with error: %@", error);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIView *view = [UIResponder currentFirstResponder];
    
    if (view != self.editTextView) {
        [view resignFirstResponder];
        [self.editTextView becomeFirstResponder];
    }
    
}

- (void) saveImage:(UIImage *)image {
    
    NSString *imageName = [kTimestamp stringByAppendingString:@".jpg"];
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
    
    [imageName saveNamedImageToDocument:image];
    [CLDataSaveTool addImageByName:imageName timesStamp:self.timeStamp content:self.editTextView.text type:type];
    
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
    
    NSString *videoName = [kTimestamp stringByAppendingString:@".mp4"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [videoName saveNamedVideoToDocument:videoURL];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.toolBar setButtonImageWithVideoName:videoName];

        });
    });
    
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
    
    [CLDataSaveTool addVideoByName:videoName timesStamp:self.timeStamp content:self.editTextView.text type:type];
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


#pragma mark - textView 代理方法
- (void)textViewDidChange:(UITextView *)textView {
    
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


@end
