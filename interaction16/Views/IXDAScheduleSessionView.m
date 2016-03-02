//
//  IXDAScheduleSessionView.m
//  interaction16
//
//  Created by Erich Grunewald on 02/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAScheduleSessionView.h"

#import "UIFont+IXDA.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

@implementation IXDAScheduleSessionView

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle names:(NSArray *)names companies:(NSArray *)companies {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor blackColor];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont ixda_scheduleSessionTitle];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self).with.insets(insets);
    }];
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.numberOfLines = 0;
    subtitleLabel.text = subtitle;
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.font = [UIFont ixda_scheduleSessionSubtitle];
    [self addSubview:subtitleLabel];
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).with.insets(insets);
        make.top.equalTo(titleLabel).offset(20);
    }];
    
    return self;
}

@end
