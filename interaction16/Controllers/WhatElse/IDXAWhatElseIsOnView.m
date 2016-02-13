//
//  IDXAWhatElseIsOnView.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IDXAWhatElseIsOnView.h"

#import "UIColor+IDXA.h"
#import "UIFont+IDXA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IDXAWhatElseIsOnView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor idxa_baseBackgroundColorA];
    
    CGFloat leftPadding = 42;
    
    UIImage *swipeUpImage = [UIImage imageNamed:@"swipeUp"];
    UIButton *backToMenuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backToMenuButton setBackgroundImage:swipeUpImage forState:UIControlStateNormal];
    [self addSubview:backToMenuButton];
    [backToMenuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(50);
        make.left.equalTo(self).offset(leftPadding);
        make.size.equalTo(@55);
    }];
    self.backToMenuButtonSignal = [backToMenuButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UILabel *backToMenuLabel = [[UILabel alloc] init];
    backToMenuLabel.textColor = [UIColor whiteColor];
    backToMenuLabel.font = [UIFont idxa_menuItemFontSmall];
    backToMenuLabel.text = @"Back to the main menu";
    [self addSubview:backToMenuLabel];
    [backToMenuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backToMenuButton);
        make.left.equalTo(backToMenuButton.mas_right).offset(20);
    }];
    
    UIImage *educationImage = [UIImage imageNamed:@"education"];
    UIImageView *educationImageView = [[UIImageView alloc] initWithImage:educationImage];
    educationImageView.userInteractionEnabled = YES;
    [self addSubview:educationImageView];
    [educationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backToMenuButton.mas_bottom).offset(100);
        make.left.equalTo(backToMenuButton);
    }];
    UITapGestureRecognizer *eduTap = [[UITapGestureRecognizer alloc] init];
    [educationImageView addGestureRecognizer:eduTap];
    self.educationButtonSignal = [eduTap rac_gestureSignal];
    
    UIImage *awardsImage = [UIImage imageNamed:@"awards"];
    UIImageView *awardsImageView = [[UIImageView alloc] initWithImage:awardsImage];
    awardsImageView.userInteractionEnabled = YES;
    [self addSubview:awardsImageView];
    [awardsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(educationImageView.mas_bottom).offset(20);
        make.left.equalTo(backToMenuButton);
    }];
    UITapGestureRecognizer *awardsTap = [[UITapGestureRecognizer alloc] init];
    [awardsImageView addGestureRecognizer:awardsTap];
    self.awardsButtonSignal = [awardsTap rac_gestureSignal];
    
    UIImage *challengeImage = [UIImage imageNamed:@"education"];
    UIImageView *challengeImageView = [[UIImageView alloc] initWithImage:challengeImage];
    challengeImageView.userInteractionEnabled = YES;
    [self addSubview:challengeImageView];
    [challengeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(awardsImageView.mas_bottom).offset(20);
        make.left.equalTo(backToMenuButton);
    }];
    UITapGestureRecognizer *challengeTap = [[UITapGestureRecognizer alloc] init];
    [awardsImageView addGestureRecognizer:challengeTap];
    self.challengeButtonSignal = [challengeTap rac_gestureSignal];
    
    UIImage *sponsoringImage = [UIImage imageNamed:@"sponsoring"];
    UIImageView *sponsoringImageView = [[UIImageView alloc] initWithImage:sponsoringImage];
    [self addSubview:sponsoringImageView];
    [sponsoringImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(62);
        make.bottom.equalTo(self).offset(-35);
    }];
    
    return self;
}

@end
