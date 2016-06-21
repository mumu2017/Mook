//
//  CLAddView.m
//  Mook
//
//  Created by 陈林 on 16/6/15.
//  Copyright © 2016年 Chen Lin. All rights reserved.
//

#import "CLAddView.h"
#import "MASonry.h"
@interface CLAddView()



@end

@implementation CLAddView

- (void)initSubViews {

    CGFloat padding = (self.frame.size.width-kAddButtonHeight*2)/3;
    
    _ideaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_ideaBtn];
    [_ideaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@kAddButtonHeight);
        make.top.equalTo(self.mas_top).offset(-padding);
        make.left.equalTo(self).offset(-padding);

    }];
    _ideaBtn.layer.cornerRadius = kAddButtonHeight/2;
    [_ideaBtn setTitle:@"灵感" forState:UIControlStateNormal];

    // 演出
    _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_showBtn];
    [_showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@kAddButtonHeight);
        make.top.equalTo(self.mas_top).offset(-padding);
        make.right.equalTo(self).offset(padding);
    }];
    _showBtn.layer.cornerRadius = kAddButtonHeight/2;
    [_showBtn setTitle:@"演出" forState:UIControlStateNormal];

    // 流程
    _routineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_routineBtn];
    [_routineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@kAddButtonHeight);
//        make.top.equalTo(_ideaBtn.mas_bottom).offset(-padding);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(-padding);
    }];
    _routineBtn.layer.cornerRadius = kAddButtonHeight/2;
    [_routineBtn setTitle:@"流程" forState:UIControlStateNormal];

    // 技巧
    _sleightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_sleightBtn];
    [_sleightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@kAddButtonHeight);
//        make.top.equalTo(_showBtn.mas_bottom).offset(-padding);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(padding);
    }];
    _sleightBtn.layer.cornerRadius = kAddButtonHeight/2;
    [_sleightBtn setTitle:@"技巧" forState:UIControlStateNormal];

    // 道具
    _propBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_propBtn];
    [_propBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@kAddButtonHeight);
        make.bottom.equalTo(self).offset(padding);
        make.left.equalTo(self).offset(-padding);
    }];
    _propBtn.layer.cornerRadius = kAddButtonHeight/2;
    [_propBtn setTitle:@"道具" forState:UIControlStateNormal];

    // 台词
    _linesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_linesBtn];
    [_linesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@kAddButtonHeight);
        make.bottom.equalTo(self).offset(padding);
        make.right.equalTo(self).offset(padding);
    }];
    _linesBtn.layer.cornerRadius = kAddButtonHeight/2;
    [_linesBtn setTitle:@"台词" forState:UIControlStateNormal];
    
}

- (void)updateColor:(UIColor *)color {
    _ideaBtn.backgroundColor = color;
    _showBtn.backgroundColor = color;
    _routineBtn.backgroundColor = color;
    _sleightBtn.backgroundColor = color;
    _propBtn.backgroundColor = color;
    _linesBtn.backgroundColor = color;

}

//{
//    CGFloat viewW = self.frame.size.width;
//    CGFloat viewH = self.frame.size.height;
//    CGFloat padding = (viewW - kAddButtonHeight*2)/3;
//    
//    _ideaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:_ideaBtn];
//    [_ideaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@kAddButtonHeight);
//        make.top.equalTo(self.mas_top).offset(-padding);
//        make.left.equalTo(self.mas_left).offset(-padding);
//        
//    }];
//    _ideaBtn.layer.cornerRadius = kAddButtonHeight/2;
//    _ideaBtn.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//    [_ideaBtn setTitle:@"灵感" forState:UIControlStateNormal];
//    
//    // 演出
//    _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:_showBtn];
//    [_showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@kAddButtonHeight);
//        make.top.equalTo(self.mas_top).offset(-padding);
//        make.left.equalTo(_ideaBtn.mas_right).offset(-padding);
//    }];
//    _showBtn.layer.cornerRadius = kAddButtonHeight/2;
//    _showBtn.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//    [_showBtn setTitle:@"演出" forState:UIControlStateNormal];
//    
//    // 流程
//    _routineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:_routineBtn];
//    [_routineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@kAddButtonHeight);
//        make.top.equalTo(_ideaBtn.mas_bottom).offset(-padding);
//        make.left.equalTo(self.mas_left).offset(-padding);
//    }];
//    _routineBtn.layer.cornerRadius = kAddButtonHeight/2;
//    _routineBtn.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//    [_routineBtn setTitle:@"流程" forState:UIControlStateNormal];
//    
//    // 技巧
//    _sleightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:_sleightBtn];
//    [_sleightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@kAddButtonHeight);
//        make.top.equalTo(_showBtn.mas_bottom).offset(-padding);
//        make.left.equalTo(_routineBtn.mas_right).offset(-padding);
//    }];
//    _sleightBtn.layer.cornerRadius = kAddButtonHeight/2;
//    _sleightBtn.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//    [_sleightBtn setTitle:@"技巧" forState:UIControlStateNormal];
//    
//    // 道具
//    _propBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:_propBtn];
//    [_propBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@kAddButtonHeight);
//        make.top.equalTo(_routineBtn.mas_bottom).offset(-padding);
//        make.left.equalTo(self.mas_left).offset(-padding);
//    }];
//    _propBtn.layer.cornerRadius = kAddButtonHeight/2;
//    _propBtn.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//    [_propBtn setTitle:@"道具" forState:UIControlStateNormal];
//    
//    // 台词
//    _linesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:_linesBtn];
//    [_linesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@kAddButtonHeight);
//        make.top.equalTo(_sleightBtn.mas_bottom).offset(-padding);
//        make.left.equalTo(_routineBtn.mas_right).offset(-padding);
//    }];
//    _linesBtn.layer.cornerRadius = kAddButtonHeight/2;
//    _linesBtn.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//    [_linesBtn setTitle:@"台词" forState:UIControlStateNormal];
//    
//
//}


 
// {
//     _ideaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//     [self addSubview:_ideaBtn];
//     [_ideaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.width.height.equalTo(@kAddButtonHeight);
//         
//         make.centerX.equalTo(self);
//         make.top.equalTo(self.mas_top).offset(padding);
//         
//     }];
//     _ideaBtn.layer.cornerRadius = kAddButtonHeight/2;
//     _ideaBtn.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//     [_ideaBtn setTitle:@"灵感" forState:UIControlStateNormal];
//     
//     // 演出
//     _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//     [self addSubview:_showBtn];
//     [_showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.width.height.equalTo(@kAddButtonHeight);
//         make.centerX.equalTo(self);
//         make.top.equalTo(_ideaBtn.mas_bottom).offset(padding);
//     }];
//     _showBtn.layer.cornerRadius = kAddButtonHeight/2;
//     _showBtn.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//     [_showBtn setTitle:@"演出" forState:UIControlStateNormal];
//     
//     // 流程
//     _routineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//     [self addSubview:_routineBtn];
//     [_routineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.width.height.equalTo(@kAddButtonHeight);
//         make.centerX.equalTo(self);
//         make.top.equalTo(_showBtn.mas_bottom).offset(padding);
//     }];
//     _routineBtn.layer.cornerRadius = kAddButtonHeight/2;
//     _routineBtn.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//     [_routineBtn setTitle:@"流程" forState:UIControlStateNormal];
//     
//     // 技巧
//     _sleightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//     [self addSubview:_sleightBtn];
//     [_sleightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.width.height.equalTo(@kAddButtonHeight);
//         make.centerX.equalTo(self);
//         make.top.equalTo(_routineBtn.mas_bottom).offset(padding);
//     }];
//     _sleightBtn.layer.cornerRadius = kAddButtonHeight/2;
//     _sleightBtn.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//     [_sleightBtn setTitle:@"技巧" forState:UIControlStateNormal];
//     
//     // 道具
//     _propBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//     [self addSubview:_propBtn];
//     [_propBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.width.height.equalTo(@kAddButtonHeight);
//         make.centerX.equalTo(self);
//         make.top.equalTo(_sleightBtn.mas_bottom).offset(padding);
//     }];
//     _propBtn.layer.cornerRadius = kAddButtonHeight/2;
//     _propBtn.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//     [_propBtn setTitle:@"道具" forState:UIControlStateNormal];
//     
//     // 台词
//     _linesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//     [self addSubview:_linesBtn];
//     [_linesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.width.height.equalTo(@kAddButtonHeight);
//         make.centerX.equalTo(self);
//         make.top.equalTo(_propBtn.mas_bottom).offset(padding);
//     }];
//     _linesBtn.layer.cornerRadius = kAddButtonHeight/2;
//     _linesBtn.backgroundColor = [kAppThemeColor darkenByPercentage:0.05];
//     [_linesBtn setTitle:@"台词" forState:UIControlStateNormal];
// }

@end
