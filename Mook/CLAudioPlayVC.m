//
//  CLAudioPlayVC.m
//  Mook
//
//  Created by 陈林 on 16/6/23.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLAudioPlayVC.h"
#import "FDWaveformView.h"
#import <AVFoundation/AVFoundation.h>

@interface CLAudioPlayVC()<FDWaveformViewDelegate,AVAudioPlayerDelegate>

{
    //BlurrView
    UIVisualEffectView *visualEffectView;
    BOOL _isFirstTime;
    
    UIView *middleContainerView;
    
    FDWaveformView *waveformView;
    UIActivityIndicatorView *waveLoadiingIndicatorView;
    
    //Navigation Bar
    UIBarButtonItem *_doneButton;
    
    //Toolbar
    UIBarButtonItem *_flexItem;
    
    //Playing controls
    UIBarButtonItem *_playButton;
    UIBarButtonItem *_pauseButton;
    UIBarButtonItem *_stopPlayButton;
    
    UIBarButtonItem *_speakerButton;
    UIBarButtonItem *_cropActivityBarButton;
    UIActivityIndicatorView *_cropActivityIndicatorView;
    UIView *_lineView;
    
    UILabel *_currentTimeLabel;
    UILabel *_beginTimeLabel;
    UILabel *_endTimeLabel;
    
    UIView *_topBorder;
    UIView *_bottomBorder;
    UIView *_centerLine;

    //Playing
    AVAudioPlayer *_audioPlayer;
    //    BOOL _wasPlaying;
    CADisplayLink *playProgressDisplayLink;
    
    //Private variables
    NSString *_oldSessionCategory;
    BOOL _wasIdleTimerDisabled;
    AVAudioSessionPortOverride _portOverride;
}

@end


@implementation CLAudioPlayVC

-(instancetype)initWithFilePath:(NSString*)audioPath
{
    self = [super init];
    
    if (self)
    {
        self.audioPath = audioPath;
    }
    
    return self;
}

-(void)setNormalTintColor:(UIColor *)normalTintColor
{
    _normalTintColor = normalTintColor;
    
    _playButton.tintColor = [self _normalTintColor];
    _pauseButton.tintColor = [self _normalTintColor];
    _stopPlayButton.tintColor = [self _normalTintColor];
//    _speakerButton.tintColor = [self _normalTintColor];
    waveformView.wavesColor = [self _normalTintColor];
}

-(UIColor*)_normalTintColor
{
    if (_normalTintColor)
    {
        return _normalTintColor;
    }
    else
    {
        if (self.barStyle == UIBarStyleDefault)
        {
            return [UIColor colorWithRed:0 green:0.5 blue:1.0 alpha:1.0];
        }
        else
        {
            return [UIColor whiteColor];
        }
    }
}

-(void)setHighlightedTintColor:(UIColor *)highlightedTintColor
{
    _highlightedTintColor = highlightedTintColor;
//    waveformView.progressColor = [self _highlightedTintColor];
}

-(UIColor *)_highlightedTintColor
{
    if (_highlightedTintColor)
    {
        return _highlightedTintColor;
    }
    else
    {
        if (self.barStyle == UIBarStyleDefault)
        {
            return [UIColor colorWithRed:255.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0];
        }
        else
        {
            return [UIColor colorWithRed:0 green:0.5 blue:1.0 alpha:1.0];
        }
    }
}

-(void)setBarStyle:(UIBarStyle)barStyle
{
    _barStyle = barStyle;
    
    if (self.barStyle == UIBarStyleDefault)
    {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.toolbar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBar.tintColor = [self _normalTintColor];
        self.navigationController.toolbar.tintColor = [self _normalTintColor];
        _cropActivityIndicatorView.color = [UIColor lightGrayColor];
        waveLoadiingIndicatorView.color = [UIColor lightGrayColor];
    }
    else
    {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.toolbar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.toolbar.tintColor = [UIColor whiteColor];
        _cropActivityIndicatorView.color = [UIColor whiteColor];
        waveLoadiingIndicatorView.color = [UIColor whiteColor];
    }
    
    self.view.tintColor = [self _normalTintColor];
    self.highlightedTintColor = self.highlightedTintColor;
    self.normalTintColor = self.normalTintColor;
}



-(void)loadView
{
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
    visualEffectView.frame = [UIScreen mainScreen].bounds;
    
    self.view = visualEffectView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isFirstTime = YES;
    
    {
        if (self.title.length == 0)
        {
            self.navigationItem.title = @"录音";
        }
    }
    
    NSURL *audioURL = [NSURL fileURLWithPath:self.audioPath];
    
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    frame = CGRectInset(frame, 16, 0);
    
    middleContainerView = [[UIView alloc] initWithFrame:frame];
    middleContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    middleContainerView.center = self.view.center;
    [visualEffectView.contentView addSubview:middleContainerView];
    
    {
        
//        _centerLine = [[UIView alloc] init];
//        [middleContainerView addSubview:_centerLine];
//        [_centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(middleContainerView);
//            make.left.right.equalTo(self.view);
//            make.height.equalTo(@1);
//        }];
//        _centerLine.backgroundColor = [UIColor whiteColor];
        
        waveformView = [[FDWaveformView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(middleContainerView.frame), 100)];
        waveformView.delegate = self;
        waveformView.center = CGPointMake(CGRectGetMidX(middleContainerView.bounds), CGRectGetMidY(middleContainerView.bounds));
        waveformView.audioURL = audioURL;
        waveformView.wavesColor = [UIColor whiteColor];
        waveformView.progressColor = [UIColor redColor];
        
        waveformView.doesAllowScroll = NO;
        waveformView.doesAllowScrubbing = NO;
        waveformView.doesAllowStretch = NO;
        
        waveformView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [middleContainerView addSubview:waveformView];
        
        // waveformView本身也有panGesture的检测,为了在VC中检测panGesture,必须解除waveformView的panGesture检测, 因此设置userInteractionEnabled为NO
        [waveformView setUserInteractionEnabled:NO];
        
        waveLoadiingIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        waveLoadiingIndicatorView.center = middleContainerView.center;
        waveLoadiingIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [visualEffectView.contentView addSubview:waveLoadiingIndicatorView];
        
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 160)];
        
        [middleContainerView addSubview:_lineView];
        _lineView.center = CGPointMake(waveformView.frame.origin.x, waveformView.center.y);
        _lineView.backgroundColor = [self _normalTintColor];
        UIPanGestureRecognizer *slideRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideRecognizer:)];
        [middleContainerView addGestureRecognizer:slideRecognizer];
        
    }
    
    {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        _audioPlayer.delegate = self;
        _audioPlayer.meteringEnabled = YES;
    }
    
    {
        
        _topBorder = [[UIView alloc] init];
        [middleContainerView addSubview:_topBorder];
        [_topBorder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_lineView.mas_top);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@1);
        }];
        _topBorder.backgroundColor = [UIColor grayColor];
        
        
        _bottomBorder = [[UIView alloc] init];
        [middleContainerView addSubview:_bottomBorder];
        [_bottomBorder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_lineView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@1);
        }];
        _bottomBorder.backgroundColor = [UIColor grayColor];
        
        _beginTimeLabel = [[UILabel alloc] init];
        [middleContainerView addSubview:_beginTimeLabel];
        [_beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(waveformView);
            make.top.equalTo(_bottomBorder.mas_bottom);
            make.width.equalTo(@60);
            make.height.equalTo(@30);
        }];
        
        _beginTimeLabel.textColor = [UIColor whiteColor];
        _beginTimeLabel.font = kFontSys12;
        _beginTimeLabel.textAlignment = NSTextAlignmentLeft;
        _beginTimeLabel.text = @"00:00";
        
        _endTimeLabel = [[UILabel alloc] init];
        [middleContainerView addSubview:_endTimeLabel];
        [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(waveformView);
            make.top.equalTo(_bottomBorder.mas_bottom);
            make.width.equalTo(@60);
            make.height.equalTo(@30);
        }];
        _endTimeLabel.textColor = [UIColor whiteColor];
        _endTimeLabel.font = kFontSys12;
        _endTimeLabel.textAlignment = NSTextAlignmentRight;

        _endTimeLabel.text = [self stringFromTimeInterval:_audioPlayer.duration];
//        [NSString stringWithFormat:@"%f", _audioPlayer.duration];
        
        // 当前播放时间
        _currentTimeLabel = [[UILabel alloc] init];
        [middleContainerView addSubview:_currentTimeLabel];
        
        [_currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_topBorder.mas_top).offset(-30);
            make.centerX.equalTo(middleContainerView);
            make.width.equalTo(middleContainerView);
            make.height.equalTo(@60);
        }];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:30];
        _currentTimeLabel.text = [self preciceStringFromTimeInterval:_audioPlayer.currentTime];

        
    }
    
    {
        _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];

        self.navigationItem.rightBarButtonItem = _doneButton;
    }
    
    {
        NSBundle* bundle = [NSBundle bundleForClass:self.class];
        
        self.navigationController.toolbarHidden = NO;
        
        _flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        _stopPlayButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop_playing" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(stopPlayingButtonAction:)];
        _stopPlayButton.enabled = NO;
        _stopPlayButton.tintColor = [self _normalTintColor];
        _playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playAction:)];
        _playButton.tintColor = [self _normalTintColor];
        

        
        _pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseAction:)];
        _pauseButton.tintColor = [self _normalTintColor];
        
        // 默认为扬声器播放
        _portOverride = AVAudioSessionPortOverrideSpeaker;
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        
        _speakerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"speaker" inBundle:bundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(switchToSpeaker)];
        _speakerButton.tintColor = [self _normalTintColor];
        
        _cropActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _cropActivityBarButton = [[UIBarButtonItem alloc] initWithCustomView:_cropActivityIndicatorView];
        
        [self setToolbarItems:@[_stopPlayButton,_flexItem, _playButton,_flexItem,_speakerButton] animated:NO];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isFirstTime)
    {
        _isFirstTime = NO;
        
        if (self.blurrEnabled)
        {
            if (self.barStyle == UIBarStyleDefault)
            {
                visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            }
            else
            {
                visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            }
        }
        else
        {
            if (self.barStyle == UIBarStyleDefault)
            {
                self.view.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                self.view.backgroundColor = [UIColor darkGrayColor];
            }
        }
    }
}


-(void)slideRecognizer:(UIPanGestureRecognizer*)panRecognizer
{
    static CGPoint beginPoint;
    static CGPoint beginCenter;
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan)
    {
        beginPoint = [panRecognizer translationInView:middleContainerView];
        beginCenter = _lineView.center;
        
        [self stopPlayingButtonAction:_stopPlayButton];
        
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_stopPlayButton.target methodSignatureForSelector:_stopPlayButton.action]];
//        invocation.target = _stopPlayButton.target;
//        invocation.selector = _stopPlayButton.action;
//        [invocation invoke];
    }
    else if (panRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint newPoint = [panRecognizer translationInView:middleContainerView];
        
        //Left Margin
        CGFloat pointX = MAX(CGRectGetMinX(waveformView.frame), beginCenter.x+(newPoint.x-beginPoint.x));
        
        //Right Margin from right cropper
        pointX = MIN(CGRectGetMaxX(waveformView.frame), pointX);
        
        _lineView.center = CGPointMake(pointX, beginCenter.y);
        
        {
            CGFloat cropTime = (_lineView.center.x/waveformView.frame.size.width)*_audioPlayer.duration;
            _audioPlayer.currentTime = cropTime;
            waveformView.progressSamples = waveformView.totalSamples*(_audioPlayer.currentTime/_audioPlayer.duration);
            
            _currentTimeLabel.text = [self preciceStringFromTimeInterval:_audioPlayer.currentTime];
        }
    }
    else if (panRecognizer.state == UIGestureRecognizerStateEnded|| panRecognizer.state == UIGestureRecognizerStateFailed)
    {
        beginPoint = CGPointZero;
        beginCenter = CGPointZero;
        
    }
}

// 切换声音Output的硬件(扬声器或听筒)
- (void)switchToSpeaker {
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    if (_portOverride == AVAudioSessionPortOverrideNone) {
        _portOverride = AVAudioSessionPortOverrideSpeaker; // 扬声器
        _speakerButton.tintColor = _normalTintColor;
        
    } else if (_portOverride == AVAudioSessionPortOverrideSpeaker) {
        
        _portOverride = AVAudioSessionPortOverrideNone; // 听筒
        _speakerButton.tintColor = [UIColor blueColor];

    }
    
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:_portOverride error:nil];

}

#pragma mark - Audio Play

-(void)updatePlayProgress
{
    waveformView.progressSamples = waveformView.totalSamples*(_audioPlayer.currentTime/_audioPlayer.duration);
    
    CGFloat x = (_audioPlayer.currentTime/_audioPlayer.duration) *waveformView.frame.size.width;
    
    _lineView.center = CGPointMake(x, waveformView.center.y);
    _currentTimeLabel.text = [self preciceStringFromTimeInterval:_audioPlayer.currentTime];
}

- (void)playAction:(UIBarButtonItem *)item
{
    _oldSessionCategory = [AVAudioSession sharedInstance].category;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
    
    //UI Update
    {
        [self setToolbarItems:@[_stopPlayButton,_flexItem, _pauseButton,_flexItem,_speakerButton] animated:YES];
        _stopPlayButton.enabled = YES;

    }
    
    {
        [playProgressDisplayLink invalidate];
        playProgressDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePlayProgress)];
        [playProgressDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

-(void)pauseAction:(UIBarButtonItem*)item
{
    [[AVAudioSession sharedInstance] setCategory:_oldSessionCategory error:nil];
    [UIApplication sharedApplication].idleTimerDisabled = _wasIdleTimerDisabled;
    
    [_audioPlayer pause];
    
    //    //UI Update
    {
        [self setToolbarItems:@[_stopPlayButton,_flexItem, _playButton,_flexItem,_speakerButton] animated:YES];
    }
}

-(void)stopPlayingButtonAction:(UIBarButtonItem*)item
{
    //UI Update
    {
        [self setToolbarItems:@[_stopPlayButton,_flexItem, _playButton,_flexItem,_speakerButton] animated:YES];
        _stopPlayButton.enabled = NO;

    }
    
    {
        [playProgressDisplayLink invalidate];
        playProgressDisplayLink = nil;
    }
    
    [_audioPlayer stop];
    // 停止播放后, 将播放时间设置为起始时间.
    _audioPlayer.currentTime = 0.0f;
    [self updatePlayProgress];
//    {
//        _audioPlayer.currentTime = leftCropView.cropTime;
//        waveformView.progressSamples = waveformView.totalSamples*(_audioPlayer.currentTime/_audioPlayer.duration);
//    }
    
    [[AVAudioSession sharedInstance] setCategory:_oldSessionCategory error:nil];
    [UIApplication sharedApplication].idleTimerDisabled = _wasIdleTimerDisabled;
}

#pragma mark - AVAudioPlayerDelegate
/*
 Occurs when the audio player instance completes playback
 */
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //To update UI on stop playing
    [self stopPlayingButtonAction:_stopPlayButton];

//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_stopPlayButton.target methodSignatureForSelector:_stopPlayButton.action]];
//    invocation.target = _stopPlayButton.target;
//    invocation.selector = _stopPlayButton.action;
//    [invocation invoke];
}

#pragma mark - FDWaveformView delegate

- (void)waveformViewWillRender:(FDWaveformView *)waveformView
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [UIView animateWithDuration:0.1 animations:^{
            middleContainerView.alpha = 0.0;
            [waveLoadiingIndicatorView startAnimating];
        }];
    }];
}

- (void)waveformViewDidRender:(FDWaveformView *)waveformView
{
    [UIView animateWithDuration:0.1 animations:^{
        middleContainerView.alpha = 1.0;
        [waveLoadiingIndicatorView stopAnimating];
    }];
}

- (void)waveformViewWillLoad:(FDWaveformView *)waveformView
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)waveformViewDidLoad:(FDWaveformView *)waveformView
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)waveformDidBeginPanning:(FDWaveformView *)waveformView
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)waveformDidEndPanning:(FDWaveformView *)waveformView
{
    //    NSLog(@"%@",NSStringFromSelector(_cmd));
    
}



#pragma mark - Done

-(void)doneAction:(UIBarButtonItem*)item
{
    if (_audioPlayer.isPlaying) {
        [self stopPlayingButtonAction:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Orientation

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//        
//        leftCropView.center = CGPointMake((leftCropView.cropTime/_audioPlayer.duration)*CGRectGetWidth(middleContainerView.frame),leftCropView.center.y);
//        rightCropView.center = CGPointMake((rightCropView.cropTime/_audioPlayer.duration)*CGRectGetWidth(middleContainerView.frame),rightCropView.center.y);
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}


- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval {
    
    // convert the time to an integer, as we don't need double precision, and we do need to use the modulous operator
    int time = round(timeInterval);
    
    return [NSString stringWithFormat:@"%.2d:%.2d", (time / 60) % 60, time % 60];

}

- (NSString *)preciceStringFromTimeInterval:(NSTimeInterval)timeInterval {
    
    // convert the time to an integer, as we don't need double precision, and we do need to use the modulous operator
    int time = (int)timeInterval;
    int millisecond = round(timeInterval * 100.0) - time * 100;
    
    return [NSString stringWithFormat:@"%.2d:%.2d:%.2d", ((time / 60) % 60), (time % 60), millisecond];
    
}

@end
