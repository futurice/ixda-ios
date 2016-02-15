//
//  IXDATalksNavigationView.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 15/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDATalksNavigationView.h"

#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDATalksNavigationView () <UIScrollViewDelegate>

@end

@implementation IXDATalksNavigationView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.talkType = @(TalkTypeKeyNote);
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont ixda_menuItemFontSmall];
    title.text = @"Talks";
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
    }];
    
    
    UIScrollView *navigationScrollView = [[UIScrollView alloc] init];
    [navigationScrollView setShowsHorizontalScrollIndicator:NO];
    [navigationScrollView setShowsVerticalScrollIndicator:NO];
    navigationScrollView.bounces = NO;
    navigationScrollView.delegate = self;
    [self addSubview:navigationScrollView];
    [navigationScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@30);
    }];
    
    UIButton *keynoteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [keynoteButton setTitle:@"Keynotes" forState:UIControlStateNormal];
    [navigationScrollView addSubview:keynoteButton];
    [keynoteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(10);
        make.centerY.height.equalTo(navigationScrollView);
    }];
    [[keynoteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.talkType = @(TalkTypeKeyNote);
    }];
    
    UIButton *longTalksButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [longTalksButton setTitle:@"Long talks and panels" forState:UIControlStateNormal];
    [navigationScrollView addSubview:longTalksButton];
    [longTalksButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(keynoteButton.mas_right).offset(10);
        make.centerY.height.equalTo(keynoteButton);
    }];
    [[longTalksButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.talkType = @(TalkTypeLongTalk);
    }];
    
    UIButton *mediumTalksButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [mediumTalksButton setTitle:@"Medium talks" forState:UIControlStateNormal];
    [navigationScrollView addSubview:mediumTalksButton];
    [mediumTalksButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(longTalksButton.mas_right).offset(10);
        make.centerY.height.equalTo(longTalksButton);
    }];
    [[mediumTalksButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.talkType = @(TalkTypeMediumTalk);
    }];
    
    UIButton *lightningTalksButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [lightningTalksButton setTitle:@"Lightning talks" forState:UIControlStateNormal];
    [navigationScrollView addSubview:lightningTalksButton];
    [lightningTalksButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mediumTalksButton.mas_right).offset(10);
        make.centerY.height.equalTo(mediumTalksButton);
        make.right.equalTo(navigationScrollView.mas_right).offset(-10);
    }];
    [[lightningTalksButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.talkType = @(TalkTypeLightningTalk);
    }];
    
    return self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x,0)];
}

@end
