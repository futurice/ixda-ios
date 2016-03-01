//
//  IXDAScheduleNavigationView.m
//  interaction16
//
//  Created by Erich Grunewald on 01/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAScheduleNavigationView.h"

#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDAScheduleNavigationView()

@property (nonatomic, strong) NSArray *days;

@end

@implementation IXDAScheduleNavigationView

- (instancetype)initWithDays:(NSArray *)days {
    self = [super init];
    if (!self) return nil;
    
    self.days = days;
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont ixda_menuItemFontSmall];
    title.text = @"Schedule";
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"arrowBlue"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.width.height.equalTo(@44);
        make.left.equalTo(self);
    }];
    self.backButtonSignal = [backButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

@end
