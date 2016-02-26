//
//  IXDASessionDetailBar.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 20/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASessionDetailBar.h"

#import "UIColor+IXDA.h"
#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDASessionDetailBar

- (instancetype)initWithTitle:(NSString *)title venue:(NSString *)venue date:(NSString *)date {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor ixda_baseBackgroundColorB];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"arrwoWhite"] forState:UIControlStateNormal];
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
    }];
    self.backButtonSignal = [backButton rac_signalForControlEvents:UIControlEventTouchUpInside];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont ixda_sessionDetailsTitle];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backButton);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(backButton.mas_bottom).offset(20);
    }];
    
    UILabel *venueLabel = [[UILabel alloc] init];
    venueLabel.font = [UIFont ixda_sessionDetailsSubTitle];
    venueLabel.text = venue;
    venueLabel.textColor = [UIColor whiteColor];
    [self addSubview:venueLabel];
    [venueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont ixda_sessionDetailsSubTitle];
    timeLabel.text = date;
    timeLabel.textColor = [UIColor whiteColor];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(venueLabel);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(venueLabel.mas_bottom).offset(15);
    }];
    
    return self;
}

@end
