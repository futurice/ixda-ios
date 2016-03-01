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

@property (nonatomic, assign) CGFloat baseHeight;
@property (nonatomic, assign) CGFloat rowHeight;

@end

@implementation IXDAScheduleNavigationView

- (instancetype)initWithDays:(NSArray *)days baseHeight:(CGFloat)baseHeight rowHeight:(CGFloat)rowHeight {
    self = [super init];
    if (!self) return nil;
    
    self.days = days;
    self.baseHeight = baseHeight;
    self.rowHeight = rowHeight;
    
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
    
    UIButton *expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    expandButton.tag = 0;
    [expandButton setImage:[UIImage imageNamed:@"arrowBlueDown"] forState:UIControlStateNormal];
    expandButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
    [self addSubview:expandButton];
    [expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset((self.baseHeight + self.rowHeight - 44) / 2.0);
        make.width.height.equalTo(@44);
        make.right.equalTo(self);
    }];
    
    UIButton *contractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contractButton.tag = 1;
    contractButton.alpha = 0.0;
    [contractButton setImage:[UIImage imageNamed:@"arrowBlueUp"] forState:UIControlStateNormal];
    contractButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
    [self addSubview:contractButton];
    [contractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.width.height.equalTo(expandButton);
    }];
    
    [[expandButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.expanded = [NSNumber numberWithBool:YES];
    }];
    [[contractButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.expanded = [NSNumber numberWithBool:NO];
    }];
    
    // Update the view when it is expanded or contracted.
    [[RACObserve(self, expanded) deliverOnMainThread] subscribeNext:^(NSNumber *exp) {
        BOOL expanded = [exp boolValue];
        
        // Animate the changes.
        [UIView animateWithDuration:0.2 animations:^{
            expandButton.alpha = !expanded;
            contractButton.alpha = expanded;
        }];
    }];
    
    return self;
}

@end
