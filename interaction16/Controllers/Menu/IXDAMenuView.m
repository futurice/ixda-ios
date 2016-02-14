//
//  IXDAMenuView.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAMenuView.h"

#import "UIButton+IXDA.h"
#import "UIColor+IXDA.h"
#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDAMenuView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor ixda_statusBarBackgroundColorA];;
    
    UIView *logoView = [[UIView alloc] init];
    logoView.backgroundColor = [UIColor ixda_baseBackgroundColorA];
    [self addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.right.equalTo(self);
        make.height.equalTo(@140);
    }];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    [logoView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(logoView).offset(42);
    }];
    
    
    UIView *sponsoringView = [[UIView alloc] init];
    sponsoringView.backgroundColor = [UIColor ixda_baseBackgroundColorA];
    [self addSubview:sponsoringView];
    [sponsoringView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@50);
    }];
    
    UIImage *sponsoringImage = [UIImage imageNamed:@"sponsoring"];
    UIImageView *sponsoringImageView = [[UIImageView alloc] initWithImage:sponsoringImage];
    sponsoringImageView.userInteractionEnabled = YES;
    [sponsoringView addSubview:sponsoringImageView];
    [sponsoringImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sponsoringView).offset(62);
        make.bottom.equalTo(sponsoringView).offset(-15);
    }];
    UITapGestureRecognizer *sponsoringTap = [[UITapGestureRecognizer alloc] init];
    [sponsoringImageView addGestureRecognizer:sponsoringTap];
    self.sponsoringImageViewSignal = [sponsoringTap rac_gestureSignal];
    
    
    CGFloat topPadding = 10;
    CGFloat buttonSpace = 5;
    CGFloat leftPadding = 42;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"backgroundSlice"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundImageView.userInteractionEnabled = YES;
    [self addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoView.mas_bottom);
        make.bottom.equalTo(sponsoringView.mas_top);
        make.left.right.equalTo(self);
    }];
    
    UIButton *programButton = [UIButton ixda_menuButtonWithTitle:@"Program"];
    [backgroundImageView addSubview:programButton];
    [programButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundImageView).offset(topPadding);
        make.left.equalTo(backgroundImageView).offset(leftPadding);
    }];
    self.programButtonSignal = [programButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UIButton *speakersButton = [UIButton ixda_menuButtonWithTitle:@"Speakers"];
    [backgroundImageView addSubview:speakersButton];
    [speakersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(programButton.mas_bottom).offset(buttonSpace);
        make.left.equalTo(programButton);
    }];
    self.speakersButtonSignal = [speakersButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UIButton *workshopsButton = [UIButton ixda_menuButtonWithTitle:@"Workshops"];
    [backgroundImageView addSubview:workshopsButton];
    [workshopsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(speakersButton.mas_bottom).offset(buttonSpace);
        make.left.equalTo(speakersButton);
    }];
    self.workshopsButtonSignal = [workshopsButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UIButton *scheduleButton = [UIButton ixda_menuButtonWithTitle:@"Schedule"];
    [backgroundImageView addSubview:scheduleButton];
    [scheduleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(workshopsButton.mas_bottom).offset(buttonSpace);
        make.left.equalTo(workshopsButton);
    }];
    self.scheduleButtonSignal = [scheduleButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UIButton *venueAndMapButton = [UIButton ixda_menuButtonWithTitle:@"Venue and map"];
    [backgroundImageView addSubview:venueAndMapButton];
    [venueAndMapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scheduleButton.mas_bottom).offset(buttonSpace);
        make.left.equalTo(scheduleButton);
    }];
    self.venueAndMapButtonSignal = [venueAndMapButton rac_signalForControlEvents:UIControlEventTouchUpInside];

    UIButton *infoButton = [UIButton ixda_menuButtonWithTitle:@"Info"];
    [backgroundImageView addSubview:infoButton];
    [infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(venueAndMapButton.mas_bottom).offset(buttonSpace);
        make.left.equalTo(venueAndMapButton);
    }];
    self.infoButtonSignal = [infoButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *swipeDownImage = [UIImage imageNamed:@"swipeDown"];
    UIButton *whatElseIsOnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [whatElseIsOnButton setBackgroundImage:swipeDownImage forState:UIControlStateNormal];
    [backgroundImageView addSubview:whatElseIsOnButton];
    [whatElseIsOnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backgroundImageView).offset(-20);
        make.left.equalTo(venueAndMapButton);
        make.size.equalTo(@50);
    }];
    self.whatElseIsOnButtonSignal = [whatElseIsOnButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UILabel *whatElseIsOnLabel = [[UILabel alloc] init];
    whatElseIsOnLabel.textColor = [UIColor whiteColor];
    whatElseIsOnLabel.font = [UIFont ixda_menuItemFontSmall];
    whatElseIsOnLabel.text = @"What else is on?";
    [backgroundImageView addSubview:whatElseIsOnLabel];
    [whatElseIsOnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(whatElseIsOnButton);
        make.left.equalTo(whatElseIsOnButton.mas_right).offset(20);
    }];
    
    return self;
}

@end
