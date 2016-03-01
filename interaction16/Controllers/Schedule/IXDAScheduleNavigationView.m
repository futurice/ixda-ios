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

@property (nonatomic, strong) NSMutableArray *dayButtons;
@property (nonatomic, assign) CGFloat baseHeight;
@property (nonatomic, assign) CGFloat rowHeight;

@end

@implementation IXDAScheduleNavigationView

- (instancetype)initWithDays:(NSArray *)days baseHeight:(CGFloat)baseHeight rowHeight:(CGFloat)rowHeight {
    self = [super init];
    if (!self) return nil;
    
    self.days = days;
    self.dayButtons = [NSMutableArray array];
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
    [expandButton setImage:[UIImage imageNamed:@"arrowBlueDown"] forState:UIControlStateNormal];
    expandButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
    [self addSubview:expandButton];
    [expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.baseHeight);
        make.width.height.equalTo(@44);
        make.right.equalTo(self);
    }];
    
    UIButton *contractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contractButton setImage:[UIImage imageNamed:@"arrowBlueUp"] forState:UIControlStateNormal];
    contractButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
    [self addSubview:contractButton];
    [contractButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.width.height.equalTo(expandButton);
    }];
    
    [[expandButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.expanded = @YES;
    }];
    [[contractButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.expanded = @NO;
    }];
    
    NSDictionary *dayAttrs = @{NSFontAttributeName:[UIFont ixda_infoCellSubTitleFont],
                            NSForegroundColorAttributeName:[UIColor ixda_infoSubtitleColor]};
    NSDictionary *dateAttrs = @{NSFontAttributeName:[UIFont ixda_socialCellDateFont],
                            NSForegroundColorAttributeName:[UIColor ixda_infoSubtitleColor]};
    
    static NSDateFormatter *_dayFormatter = nil;
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dayFormatter = [[NSDateFormatter alloc] init];
        [_dayFormatter setDateFormat:@"EEEE"];
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MMMM d"];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });
    
    // Create a button for each day.
    [self.days enumerateObjectsUsingBlock:^(NSDate *day, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *dayButton = [UIButton buttonWithType:UIButtonTypeSystem];
        dayButton.tag = idx;
        dayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.dayButtons addObject:dayButton];
        
        NSString *weekday = [_dayFormatter stringFromDate:day];
        NSString *date = [_dateFormatter stringFromDate:day];
        NSString *titleString = [NSString stringWithFormat:@"%@, %@", weekday, date];
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:titleString attributes:dayAttrs];
        [attributedTitle setAttributes:dateAttrs range:NSMakeRange(weekday.length + 1, titleString.length - weekday.length - 1)];
        [dayButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
        
        [self addSubview:dayButton];
        
        [dayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.height.equalTo(@(rowHeight));
            
            // If it's the first button, constrain it to top.
            if (idx == 0) {
                make.top.equalTo(self).offset(self.baseHeight);
            } else {
                // Otherwise, constrain it to the previous button.
                UIButton *prev = self.dayButtons[idx - 1];
                make.top.equalTo(prev.mas_bottom);
            }
        }];
        
        [[dayButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if ([self.expanded isEqual:@NO]) {
                self.expanded = @YES;
            } else {
                self.selectedDay = @(dayButton.tag);
                self.expanded = @NO;
            }
        }];
    }];
    
    // Update the view when it is expanded or contracted, or when a new day has been selected.
    [[[RACObserve(self, expanded) deliverOnMainThread] combineLatestWith:RACObserve(self, selectedDay)]
     subscribeNext:^(RACTuple *tuple) {
         BOOL expanded = [tuple.first boolValue];
         NSUInteger selectedDay = [tuple.second unsignedIntegerValue];
         
         // Animate the changes.
         [UIView animateWithDuration:0.2 animations:^{
             expandButton.alpha = !expanded;
             contractButton.alpha = expanded;
             
             [self.dayButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
                 // Button should be visible if the view is expanded or if it's the selected one.
                 BOOL visible = expanded || idx == selectedDay;
                 button.alpha = visible;
                 [button mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.height.equalTo(@(visible ? self.rowHeight : 0.0));
                 }];
             }];
             
             [self layoutIfNeeded];
         }];
     }];
    
    self.expanded = @NO;
    self.selectedDay = @0;
    
    return self;
}

@end
