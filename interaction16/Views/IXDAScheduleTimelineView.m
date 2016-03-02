//
//  IXDAScheduleTimelineView.m
//  interaction16
//
//  Created by Erich Grunewald on 02/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAScheduleTimelineView.h"

#import "IXDAScheduleViewModel.h"

#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

@interface IXDAScheduleTimelineView () <UIScrollViewDelegate>

@property (nonatomic, strong) IXDAScheduleViewModel *viewModel;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *timeLabels;

@end

@implementation IXDAScheduleTimelineView

- (id)initWithScheduleViewModel:(IXDAScheduleViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    
    self.backgroundColor = [UIColor ixda_timelineBackgroundColor];
    
    // Set up scroll view.
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 20, 5, 20);
    
    CGFloat rowHeight = 24.0;
    CGFloat dayMargin = 48.0;
    
    CGFloat timeLabelWidth = 60.0;
    CGFloat columnWidth = 180.0;
    
    NSUInteger numberOfColumns = [self.viewModel maxNumberOfRoomsPerDay];
    CGFloat dividerWidth = timeLabelWidth + columnWidth * numberOfColumns;
    
    self.timeLabels = [NSMutableArray array];
    
    // Enumerate through days, drawing the appropriate views for each one.
    [self.viewModel.days enumerateObjectsUsingBlock:^(NSDate *day, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // Draw time labels for the current day.
        [[self.viewModel timeLabelStringsForDay:idx] enumerateObjectsUsingBlock:^(NSString *timeString, NSUInteger timeIdx, BOOL * _Nonnull stop) {
            UILabel *timeLabel = [[UILabel alloc] init];
            timeLabel.text = timeString;
            timeLabel.font = [UIFont ixda_scheduleTimeLabel];
            timeLabel.textColor = [UIColor ixda_timelineTimeLabelColor];
            
            [self.scrollView addSubview:timeLabel];
            
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView).offset(insets.left);
                make.height.equalTo(@(rowHeight));
                make.width.equalTo(@(timeLabelWidth));
                
                UILabel *prev = [self.timeLabels lastObject];
                if (idx == 0 && timeIdx == 0) { // The very first time label.
                    make.top.equalTo(self.scrollView).offset(insets.top);
                } else if (timeIdx == 0) { // The first time label for a certain day
                    make.top.equalTo(prev.mas_bottom).offset(dayMargin);
                } else {
                    make.top.equalTo(prev.mas_bottom);
                }
            }];
            
            [self.timeLabels addObject:timeLabel];
            
            // Add horizontal divider at the top of each time label (except the first one of each day).
            if (timeIdx != 0) {
                UIView *horizontalDivider = [[UIView alloc] init];
                horizontalDivider.backgroundColor = [UIColor whiteColor];
                horizontalDivider.alpha = 0.49;
                [self.scrollView addSubview:horizontalDivider];
                [horizontalDivider mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo([self.timeLabels lastObject]);
                    make.left.equalTo(self.scrollView).offset(insets.left);
                    make.right.equalTo(self.scrollView).offset(-insets.right);
                    make.height.equalTo(@1);
                    make.width.equalTo(@(dividerWidth));
                }];
            }
        }];
    }];
    
    // Constrain last time label to scroll view.
    UILabel *lastTimeLabel = [self.timeLabels lastObject];
    [lastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView).offset(-insets.bottom);
    }];
    
    return self;
}


#pragma mark - UIScrollViewDelegate

@end
