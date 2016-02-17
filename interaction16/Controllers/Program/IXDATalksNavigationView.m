//
//  IXDATalksNavigationView.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 15/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDATalksNavigationView.h"

#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"


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
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"arrowBlue"] forState:UIControlStateNormal];
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.width.height.equalTo(@20);
        make.left.equalTo(self).offset(15);
    }];
    self.backButtonSignal = [backButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIScrollView *navigationScrollView = [[UIScrollView alloc] init];
    [navigationScrollView setShowsHorizontalScrollIndicator:NO];
    [navigationScrollView setShowsVerticalScrollIndicator:NO];
    //navigationScrollView.bounces = NO;
    navigationScrollView.delegate = self;
    [self addSubview:navigationScrollView];
    [navigationScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@50);
    }];
    
    UIButton *keynoteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [keynoteButton setTitle:@"Keynotes" forState:UIControlStateNormal];
    [navigationScrollView addSubview:keynoteButton];
    [keynoteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(20);
        make.centerY.height.equalTo(navigationScrollView);
    }];
    [[keynoteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.talkType = @(TalkTypeKeyNote);
    }];
    
    UIButton *longTalksButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [longTalksButton setTitle:@"Long talks and panels" forState:UIControlStateNormal];
    [navigationScrollView addSubview:longTalksButton];
    [longTalksButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(keynoteButton.mas_right).offset(20);
        make.centerY.height.equalTo(keynoteButton);
    }];
    [[longTalksButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.talkType = @(TalkTypeLongTalk);
    }];
    
    UIButton *mediumTalksButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [mediumTalksButton setTitle:@"Medium talks" forState:UIControlStateNormal];
    [navigationScrollView addSubview:mediumTalksButton];
    [mediumTalksButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(longTalksButton.mas_right).offset(20);
        make.centerY.height.equalTo(longTalksButton);
    }];
    [[mediumTalksButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.talkType = @(TalkTypeMediumTalk);
    }];
    
    UIButton *lightningTalksButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [lightningTalksButton setTitle:@"Lightning talks" forState:UIControlStateNormal];
    [navigationScrollView addSubview:lightningTalksButton];
    [lightningTalksButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mediumTalksButton.mas_right).offset(20);
        make.centerY.height.equalTo(mediumTalksButton);
    }];
    [[lightningTalksButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.talkType = @(TalkTypeLightningTalk);
    }];
    
    UIButton *socialEventsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [socialEventsButton setTitle:@"Social Event" forState:UIControlStateNormal];
    [navigationScrollView addSubview:socialEventsButton];
    [socialEventsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lightningTalksButton.mas_right).offset(20);
        make.centerY.height.equalTo(lightningTalksButton);
        make.right.equalTo(navigationScrollView.mas_right).offset(-20);
    }];
    [[socialEventsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.talkType = @(TalkTypeSocialEvent);
    }];
    
    [RACObserve(self, talkType) subscribeNext:^(NSNumber *talkType) {
        
        keynoteButton.titleLabel.font = [UIFont ixda_programNavigationItem];
        keynoteButton.tintColor = [UIColor blackColor];
        longTalksButton.titleLabel.font = [UIFont ixda_programNavigationItem];
        longTalksButton.tintColor = [UIColor blackColor];
        mediumTalksButton.titleLabel.font = [UIFont ixda_programNavigationItem];
        mediumTalksButton.tintColor = [UIColor blackColor];
        lightningTalksButton.titleLabel.font = [UIFont ixda_programNavigationItem];
        lightningTalksButton.tintColor = [UIColor blackColor];
        socialEventsButton.titleLabel.font = [UIFont ixda_programNavigationItem];
        socialEventsButton.tintColor = [UIColor blackColor];
        
        UIButton *selectedButton = nil;
        switch ([talkType unsignedIntegerValue]) {
            case TalkTypeLongTalk:
                selectedButton = longTalksButton;
                [navigationScrollView setContentOffset:CGPointMake(selectedButton.frame.size.width/2 +selectedButton.frame.origin.x - self.frame.size.width/2, 0) animated:YES];
                break;
            case TalkTypeMediumTalk:
                selectedButton = mediumTalksButton;
                [navigationScrollView setContentOffset:CGPointMake(selectedButton.frame.size.width/2 +selectedButton.frame.origin.x - self.frame.size.width/2, 0) animated:YES];
                break;
            case TalkTypeLightningTalk:
                selectedButton = lightningTalksButton;
                [navigationScrollView setContentOffset:CGPointMake(selectedButton.frame.size.width/2 +selectedButton.frame.origin.x - self.frame.size.width/2, 0) animated:YES];
                break;
            case TalkTypeSocialEvent:
                selectedButton = socialEventsButton;
                [navigationScrollView setContentOffset:CGPointMake(navigationScrollView.frame.size.width, 0) animated:YES];
                break;
            default:
                selectedButton = keynoteButton;
                [navigationScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                break;
        }
        selectedButton.titleLabel.font = [UIFont ixda_programNavigationItemSelected];
        selectedButton.tintColor = [UIColor ixda_baseBackgroundColorA];

    }];
    
    return self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x,0)];
}

@end
