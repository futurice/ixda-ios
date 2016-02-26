//
//  IXDASocialEventDetailBar.m
//  interaction16
//
//  Created by Martin Hartl on 22/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASocialEventDetailBar.h"

#import "UIColor+IXDA.h"
#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDASocialEventDetailBar

- (instancetype)initWithTitle:(NSString *)title venue:(NSString *)venue date:(NSString *)date time:(NSString *)time {
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
    
    UIView *dayBackgroundView = [[UIView alloc] init];
    dayBackgroundView.backgroundColor = [UIColor blackColor];
    [self addSubview:dayBackgroundView];
    
    [dayBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(108);
        make.top.equalTo(self).offset(68);
        make.left.equalTo(self);
    }];
    
    UILabel *dayLabel = [[UILabel alloc] init];
    dayLabel.textColor = [UIColor whiteColor];
    dayLabel.font = [UIFont ixda_socialCellDateFont];
    dayLabel.text = date;
    [dayBackgroundView addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(dayBackgroundView).insets(UIEdgeInsetsMake(0, 16, 0, 0));
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont ixda_socialCellDateFont];
    timeLabel.text = time;
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.top.equalTo(self).offset(68);
        make.left.equalTo(dayBackgroundView.mas_right).offset(10);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont ixda_sessionDetailsTitle];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backButton);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(dayBackgroundView.mas_bottom).offset(14);
    }];
    
    UILabel *venueLabel = [[UILabel alloc] init];
    venueLabel.font = [UIFont ixda_sessionDetailsDescription];
    venueLabel.text = venue;
    venueLabel.textColor = [UIColor blackColor];
    [self addSubview:venueLabel];
    [venueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
    }];
    
    return self;
}

@end
