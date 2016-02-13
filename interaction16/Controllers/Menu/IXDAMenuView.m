//
//  IXDAMenuView.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAMenuView.h"

#import "UIButton+IXDA.h"
#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDAMenuView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    CGFloat topPadding = 21;
    CGFloat buttonSpace = 15;
    CGFloat leftPadding = 42;
  
    
    UIButton *programButton = [UIButton ixda_menuButtonWithTitle:@"Program"];
    [self addSubview:programButton];
    [programButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(topPadding);
        make.left.equalTo(self).offset(leftPadding);
    }];
    self.programButtonSignal = [programButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UIButton *speakersButton = [UIButton ixda_menuButtonWithTitle:@"Speakers"];
    [self addSubview:speakersButton];
    [speakersButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(programButton.mas_bottom).offset(buttonSpace);
        make.left.equalTo(programButton);
    }];
    self.speakersButtonSignal = [speakersButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UIButton *workshopsButton = [UIButton ixda_menuButtonWithTitle:@"Workshops"];
    [self addSubview:workshopsButton];
    [workshopsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(speakersButton.mas_bottom).offset(buttonSpace);
        make.left.equalTo(speakersButton);
    }];
    self.workshopsButtonSignal = [workshopsButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UIButton *scheduleButton = [UIButton ixda_menuButtonWithTitle:@"Schedule"];
    [self addSubview:scheduleButton];
    [scheduleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(workshopsButton.mas_bottom).offset(buttonSpace);
        make.left.equalTo(workshopsButton);
    }];
    self.scheduleButtonSignal = [scheduleButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UIButton *venueAndMapButton = [UIButton ixda_menuButtonWithTitle:@"Venue and map"];
    [self addSubview:venueAndMapButton];
    [venueAndMapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scheduleButton.mas_bottom).offset(buttonSpace);
        make.left.equalTo(scheduleButton);
    }];
    self.venueAndMapButtonSignal = [venueAndMapButton rac_signalForControlEvents:UIControlEventTouchUpInside];

    UIButton *infoButton = [UIButton ixda_menuButtonWithTitle:@"Info"];
    [self addSubview:infoButton];
    [infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(venueAndMapButton.mas_bottom).offset(buttonSpace);
        make.left.equalTo(venueAndMapButton);
    }];
    self.infoButtonSignal = [infoButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *swipeDownImage = [UIImage imageNamed:@"swipeDown"];
    UIButton *whatElseIsOnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [whatElseIsOnButton setBackgroundImage:swipeDownImage forState:UIControlStateNormal];
    [self addSubview:whatElseIsOnButton];
    [whatElseIsOnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.left.equalTo(venueAndMapButton);
        make.size.equalTo(@55);
    }];
    self.whatElseIsOnButtonSignal = [whatElseIsOnButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UILabel *whatElseIsOnLabel = [[UILabel alloc] init];
    whatElseIsOnLabel.textColor = [UIColor whiteColor];
    whatElseIsOnLabel.font = [UIFont ixda_menuItemFontSmall];
    whatElseIsOnLabel.text = @"What else is on?";
    [self addSubview:whatElseIsOnLabel];
    [whatElseIsOnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(whatElseIsOnButton);
        make.left.equalTo(whatElseIsOnButton.mas_right).offset(20);
    }];
    
    return self;
}

@end
