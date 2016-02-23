//
//  IXDAMyScheduleEmptyStateView.m
//  interaction16
//
//  Created by Erich Grunewald on 23/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAMyScheduleEmptyStateView.h"

#import "UIColor+IXDA.h"
#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDAMyScheduleEmptyStateView

- (id)initWithTitle:(NSString *)title message:(NSString *)message {
    
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor ixda_baseBackgroundColorB];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont ixda_infoCellTitleFont];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.centerX.equalTo(self);
    }];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont ixda_infoCellDescriptionFont];
    messageLabel.text = message;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.trailing.equalTo(self).with.insets(UIEdgeInsetsMake(0, 20, 0, 20));
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
    }];
    
    return self;
}

@end
