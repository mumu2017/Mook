//
//  CLDeckVC.m
//  Mook
//
//  Created by 陈林 on 16/6/16.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLDeckVC.h"

#import "CLDeck.h"
#import "CLCard.h"
#import "InfiniteScrollPicker.h"
#import "LTInfiniteScrollView.h"

//#import "Masonry.h"

#define kCardTableColor     [UIColor colorWithRed:21/225.0 green:102/225.0 blue:46/225.0 alpha:1.0]


@interface CLDeckVC ()<LTInfiniteScrollViewDelegate,LTInfiniteScrollViewDataSource>

@property (strong, nonatomic) NSArray *deck;
@property (strong, nonatomic) NSArray *deckImageList;
@property (strong, nonatomic) UILabel *indexLabel;
@property (strong, nonatomic) UIButton *preButton;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) LTInfiniteScrollView *deckView;
@property (strong, nonatomic) UISegmentedControl *segment;

@end

@implementation CLDeckVC

- (UISegmentedControl *)segment {
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"Stack", @"Train", ]];
        [self.view addSubview:_segment];
        [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(10);
            make.centerX.equalTo(self.view);
            make.left.equalTo(self.view).offset(20);
            make.height.equalTo(@30);
        }];
        _segment.backgroundColor = kAppThemeColor;
        _segment.tintColor = kCardTableColor;
//        _segment.
        
    }
    return _segment;
}

- (NSArray *)deck {
    if (!_deck) {
        _deck = [CLDeck fullDeck];
    }
    return _deck;
}

- (UIButton *)preButton {
    if (!_preButton) {
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_preButton];
        
        [_preButton addTarget:self action:@selector(preCard) forControlEvents:UIControlEventTouchUpInside];
        _preButton.backgroundColor = kAppThemeColor;
        [_preButton setTitle:@"Pre" forState:UIControlStateNormal];
        [_preButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
            make.left.equalTo(self.view).with.offset(20);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(88);
        }];
        _preButton.layer.cornerRadius = 5;
    }
    return _preButton;
}


- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_nextButton];

        [_nextButton addTarget:self action:@selector(nextCard) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.backgroundColor = kAppThemeColor;
        [_nextButton setTitle:@"Next" forState:UIControlStateNormal];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
            make.right.equalTo(self.view).with.offset(-20);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(88);
        }];
        _nextButton.layer.cornerRadius = 5;
    }
    return _nextButton;
}

- (void)preCard {
    NSInteger preIndex = self.deckView.currentIndex-1;

    if (self.nextButton.enabled == NO) {
        self.nextButton.enabled = YES;
    }
    self.preButton.enabled = (preIndex> 0);


    [self.deckView scrollToIndex:preIndex animated:YES];
}

- (void)nextCard {
    
    NSInteger nextIndex = self.deckView.currentIndex+1;
    if (self.preButton.enabled == NO) {
        self.preButton.enabled = YES;
    }
    self.nextButton.enabled = (nextIndex < [self.deckView.dataSource numberOfViews]-1);

    NSLog(@"%ld",nextIndex);
    [self.deckView scrollToIndex:nextIndex animated:YES];

}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
            _indexLabel = [[UILabel alloc] init];
            [self.view addSubview:_indexLabel];
            [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.centerY.equalTo(self.deckView.mas_top).multipliedBy(0.5);
        //        make.top.equalTo(self.view).offset(100);
                make.width.height.equalTo(@160);
            }];
            _indexLabel.font = [UIFont boldSystemFontOfSize:64];
            _indexLabel.textColor = [UIColor whiteColor];
            _indexLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _indexLabel;
}

- (LTInfiniteScrollView *)deckView {
    if (!_deckView) {
        CGSize size;
        if (self.deckImageList.count > 0) {
            UIImage *image = self.deckImageList[0];
            size = CGSizeMake(image.size.width/2, image.size.height);
            
        }
        _deckView = [[LTInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, size.height*2)];
        [self.view addSubview:_deckView];

        _deckView.center = self.view.center;
        _deckView.maxScrollDistance = 5;
        _deckView.dataSource = self;
        _deckView.delegate = self;
        _deckView.clipsToBounds = YES;
    }
    return _deckView;
}

- (NSArray *)deckImageList {
    if (!_deckImageList) {
        _deckImageList = [CLDeck fullDeckImageList];
    }
    return _deckImageList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Mnemonicosis";
    self.view.backgroundColor = kCardTableColor;
    
    // Do any additional setup after loading the view.
    CGSize size;
    if (self.deckImageList.count > 0) {
        UIImage *image = self.deckImageList[0];
        size = CGSizeMake(image.size.width/2, image.size.height);
        
    }
    
    [self deckView];
    [self preButton];
    [self nextButton];
    [self segment];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:kCardTableColor];
    
    [self.deckView reloadDataWithInitialIndex:0];
    
    CGFloat inset = self.deckView.frame.size.width / [self.deckView.dataSource numberOfVisibleViews] * 2.0;
    self.deckView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    [self sortViews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:kAppThemeColor];
//    backgroundColor = kAppThemeColor;

}

- (void)sortViews
{
    NSMutableArray *views = [[self.deckView allViews] mutableCopy];
    [views sortUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        return view1.tag > view2.tag;
    }];
    for (UIView *view in views) {
        [view.superview bringSubviewToFront:view];
    }
}

- (void)infiniteScrollPicker:(InfiniteScrollPicker *)infiniteScrollPicker didSelectAtImage:(UIImage *)image
{

}

- (void)infiniteScrollPicker:(InfiniteScrollPicker *)infiniteScrollPicker didMoveToImage:(UIImage *)image
{
    NSInteger index = 0;
    
    for (UIImage *img in self.deckImageList) {
        if (img == image) {
            break;
        } else {
            index++;
        }
    }
    _indexLabel.text = [NSString stringWithFormat:@"%ld", index+1];
}

# pragma mark - LTInfiniteScrollView dataSource
- (NSInteger)numberOfViews
{
    return self.deckImageList.count;
}

- (NSInteger)numberOfVisibleViews
{
    return 5;
}

# pragma mark - LTInfiniteScrollView delegate
- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view;
{
    if (view) {
        UIImage *image = [UIImage imageNamed:@"redBack"];
        [((UIButton *)view) setImage:image forState:UIControlStateNormal];
        
    } else {
        view = [self cardViewWithIndex:index];
    }
 
    return view;
}

- (UIButton *)cardViewWithIndex:(NSInteger) index {
    CGSize size;
    
    if (self.deckImageList.count > 0) {
//        UIImage *image = self.deckImageList[0];
        
        UIImage *image = [UIImage imageNamed:@"redBack"];

        size = CGSizeMake(image.size.width, image.size.height);
        
    }
    
    UIButton *aView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [aView setImage:self.deckImageList[index] forState:UIControlStateNormal];

    aView.imageView.contentMode = UIViewContentModeScaleToFill;
    aView.backgroundColor = [UIColor clearColor];
    aView.imageView.layer.masksToBounds = YES;
    [aView addTarget:self action:@selector(cardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    aView.enabled = NO;
    
    return aView;
}

- (void)cardButtonClicked:(UIButton *)button {
//    NSLog(@"%@", [NSString stringWithFormat:@"点击了第%ld张", button.tag+1]);
    UIImage *cardFace = self.deckImageList[button.tag];
    UIImage *cardBack = [UIImage imageNamed:@"redBack"];
    if (button.imageView.image == cardFace) {
        [button setImage:cardBack forState:UIControlStateNormal];

    } else {
        [button setImage:self.deckImageList[button.tag] forState:UIControlStateNormal];

    }
}

//- (void)updateView:(UIView *)view withProgress:(CGFloat)progress scrollDirection:(ScrollDirection)direction
//{
//    // adjust z-index of each views
//    [self sortViews];
//    UIButton *btn = (UIButton *)view;
//
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    // scale
//    CGFloat scale = 1 + (progress) * 0.03;
//    transform = CGAffineTransformScale(transform, scale, scale);
//    
//    // translation
//    CGFloat translation = 0;
//    if (progress > 0) {
//        translation = fabs(progress) * kScreenW / 2.2;
//    } else {
//        translation = fabs(progress) * kScreenW / 15;
//    }
//    
//    transform = CGAffineTransformTranslate(transform, translation, 0);
//    view.transform = transform;
//    
//    // rotate
//        if (fabs(progress) < 1) {
//
//            if (fabs(progress) <= 0.5) {
//           
//                if (btn.enabled == NO) {
//                    [btn setEnabled:YES];
//                }
//    
//            } else {
//                if (btn.enabled == YES) {
//                    [btn setEnabled:NO];
//                    if (btn.backgroundColor != [UIColor clearColor]) {
//                        btn.backgroundColor = [UIColor clearColor];
//                    }
//                }
//            }
//        } else {
//            if (btn.enabled == YES) {
//                [btn setEnabled:NO];
//                if (btn.backgroundColor != [UIColor clearColor]) {
//                    btn.backgroundColor = [UIColor clearColor];
//                }
//            }
//        }
//}

// 翻转效果
- (void)updateView:(UIView *)view withProgress:(CGFloat)progress scrollDirection:(ScrollDirection)direction
{
    
    UIButton *btn = (UIButton *)view;
    UIImage *cardBack = [UIImage imageNamed:@"redBack"];
    UIImage *cardFace = self.deckImageList[view.tag];

    // you can appy animations duration scrolling here
    
    CATransform3D transform = CATransform3DIdentity;
    
    CGSize imageSize;
    if (self.deckImageList.count > 0) {
        UIImage *image = self.deckImageList[0];
        imageSize = CGSizeMake(image.size.width, image.size.height);
        
    }
    
    // scale
    CGFloat w = imageSize.width;
    CGFloat h = imageSize.height;
    CGPoint center = view.center;
    view.center = center;
    w = w * (1.4 - 0.3 * (fabs(progress)));
    h = h * (1.4 - 0.3 * (fabs(progress)));
    view.frame = CGRectMake(0, 0, w, h);

    view.center = center;
    
    // translate
    CGFloat translate = imageSize.width / 3 * progress;
    if (progress > 1) {
        translate = imageSize.width / 3;
    } else if (progress < -1) {
        translate = -imageSize.width / 3;
    }
    transform = CATransform3DTranslate(transform, translate, 0, 0);
    
    // rotate
    if (fabs(progress) < 1) {
        CGFloat angle = 0;
        if(progress > 0) {
            angle = - M_PI * (1 - fabs(progress));
        } else {
            angle =  M_PI * (1 - fabs(progress));
        }
        transform.m34 = 1.0 / -600;
        if (fabs(progress) <= 0.5) {
            angle =  M_PI * progress;
            
            if (btn.imageView.image != cardFace) {
                [btn setImage:cardFace forState:UIControlStateNormal];
                self.indexLabel.text = [NSString stringWithFormat:@"%ld", view.tag+1];
//                [btn setEnabled:YES];

            }
            if (btn.imageView.image != cardFace) {
//                [btn setEnabled:NO];
                [btn setImage:cardFace forState:UIControlStateNormal];
            }

        } else {

            if (btn.imageView.image != cardBack) {
//                [btn setEnabled:NO];
                [btn setImage:cardBack forState:UIControlStateNormal];
            }
            
        }
        transform = CATransform3DRotate(transform, angle , 0.0f, 1.0f, 0.0f);
    } else {
        if (btn.imageView.image != cardBack) {
            [btn setImage:cardBack forState:UIControlStateNormal];
        }
    }
    
    view.layer.transform = transform;
    
}

- (void)scrollView:(LTInfiniteScrollView *)scrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@"scroll to: %ld", index);

}

@end
