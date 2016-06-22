//
//  CLFullStackVC.m
//  Mook
//
//  Created by 陈林 on 16/6/21.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLFullStackVC.h"
#import "CLDeck.h"
#import "CLCard.h"
#import "LTInfiniteScrollView.h"

#define kCardTableColor     [UIColor colorWithRed:21/225.0 green:102/225.0 blue:46/225.0 alpha:1.0]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define COLOR [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]

@interface CLFullStackVC ()<LTInfiniteScrollViewDelegate,LTInfiniteScrollViewDataSource>

@property (strong, nonatomic) LTInfiniteScrollView *scrollView;

@property (strong, nonatomic) NSArray *deckImageList;


@end

@implementation CLFullStackVC

- (NSArray *)deckImageList {
    if (!_deckImageList) {
        _deckImageList = [CLDeck fullDeckImageList];
    }
    return _deckImageList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kCardTableColor;
    // Do any additional setup after loading the view.
    self.scrollView = [[LTInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.dataSource = self;
    self.scrollView.delegate = self;
    self.scrollView.maxScrollDistance = 3;
    self.scrollView.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView reloadDataWithInitialIndex:0];
    CGFloat inset = self.scrollView.frame.size.width / [self.scrollView.dataSource numberOfVisibleViews] * 2.0;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    [self sortViews];
    [self.navigationController.navigationBar setBarTintColor:kCardTableColor];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:kAppThemeColor];
    //    backgroundColor = kAppThemeColor;
    
}

- (void)sortViews
{
    NSMutableArray *views = [[self.scrollView allViews] mutableCopy];
    [views sortUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        return view1.tag > view2.tag;
    }];
    for (UIView *view in views) {
        [view.superview bringSubviewToFront:view];
    }
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
- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view) {
        
        UILabel *indexLabel;
        UIButton *card;
        
        for (UIView *aView in view.subviews) {
            if ([aView isKindOfClass:[UILabel class]]) {
                indexLabel = (UILabel *)aView;
                
            } else if ([aView isKindOfClass:[UIButton class]]) {
                
                card = (UIButton *)aView;
            }
        }
        
        if (indexLabel) {
            indexLabel.text = [NSString stringWithFormat:@"%ld", index+1];
        }
        if (card) {
            card.tag = index;
            UIImage *cardFace = self.deckImageList[index];
            UIImage *cardBack = [UIImage imageNamed:@"redBack"];
            [card setImage:cardFace forState:UIControlStateNormal];
        }
        
        
    } else {
        view = [self newCardWithIndex:index];

    }
    
    return view;
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

- (UIView *)newCardWithIndex:(NSInteger)index
{
    UIImage *cardFace = self.deckImageList[index];
    UIImage *cardBack = [UIImage imageNamed:@"redBack"];
    
    CGFloat width =  SCREEN_WIDTH / 10 * 7.2;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 500)];
    
    UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    indexLabel.backgroundColor = [UIColor clearColor];
    indexLabel.layer.cornerRadius = 5;
    indexLabel.font = [UIFont boldSystemFontOfSize:30];
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.text = [NSString stringWithFormat:@"%ld", index+1];

    UIButton *card = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, cardFace.size.width, cardFace.size.height)];
    card.tag = index;
    

//    [card setBackgroundImage:[UIImage imageNamed:@"redBack"] forState:UIControlStateNormal];
    [card setImage:cardFace forState:UIControlStateNormal];
    card.imageView.contentMode = UIViewContentModeScaleAspectFit;
    card.backgroundColor = [UIColor clearColor];
    card.imageView.layer.masksToBounds = YES;
    [card addTarget:self action:@selector(cardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    card.backgroundColor = [UIColor clearColor];
    card.layer.cornerRadius = 5;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:card.bounds];
    card.layer.shadowColor = [UIColor blackColor].CGColor;
    card.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    card.layer.shadowOpacity = .3;
    card.layer.shadowPath = shadowPath.CGPath;
    
    
    [view addSubview:indexLabel];
    [view addSubview:card];
    return view;
}

- (void)updateView:(UIView *)view withProgress:(CGFloat)progress scrollDirection:(ScrollDirection)direction
{
    // adjust z-index of each views
    [self sortViews];

    
//    // alpha
//    CGFloat alpha = 1;
//    if (progress >= 0) {
//        alpha = 1;
//    } else {
//        alpha = 1 - fabs(progress) * 0.2;
//    }
//    view.alpha = alpha;
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // scale
    CGFloat scale = 1 + (progress) * 0.03;
//    CGFloat scale = 1;
    transform = CGAffineTransformScale(transform, scale, scale);
    
    // translation
    CGFloat translation = 0;
    if (progress > 0) {
        translation = fabs(progress) * SCREEN_WIDTH / 2.2;
    } else {
        translation = fabs(progress) * SCREEN_WIDTH / 15;
    }
    
    transform = CGAffineTransformTranslate(transform, translation, 0);
    view.transform = transform;
}



@end
