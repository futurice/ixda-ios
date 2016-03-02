//
//  IXDAScheduleTimelineView.m
//  interaction16
//
//  Created by Erich Grunewald on 02/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAScheduleTimelineView.h"
#import "IXDAScheduleViewModel.h"
#import "IXDAScheduleSessionView.h"

#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

@interface IXDAScheduleTimelineView () <UIScrollViewDelegate>

@property (nonatomic, strong) IXDAScheduleViewModel *viewModel;
@property (nonatomic, strong) NSArray *sessionsByDayAndVenue;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *timeLabelsByDay;

@end

@implementation IXDAScheduleTimelineView

- (id)initWithScheduleViewModel:(IXDAScheduleViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    self.viewModel = viewModel;
    self.sessionsByDayAndVenue = [self.viewModel sessionsByDayAndVenue];
    
    self.backgroundColor = [UIColor ixda_timelineBackgroundColor];
    
    // Set up scroll view.
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.directionalLockEnabled = YES;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 20, 5, 20);
    
    CGFloat rowHeight = 24.0;
    CGFloat dayMargin = 48.0;
    
    CGFloat timeLabelWidth = 60.0;
    CGFloat columnWidth = 180.0;
    CGFloat columnMargin = 10.0;
    
    NSUInteger numberOfColumns = [self.viewModel maxNumberOfVenuesPerDay];
    CGFloat dividerWidth = timeLabelWidth + columnWidth * numberOfColumns;
    
    self.timeLabelsByDay = [NSMutableArray array];
    
    // Enumerate through days, drawing the appropriate views for each one.
    [self.viewModel.sessionsByDayAndVenue enumerateObjectsUsingBlock:^(NSArray *arrayOfVenues, NSUInteger dayIdx, BOOL * _Nonnull stop) {
        
        [self.timeLabelsByDay addObject:[NSMutableArray array]];
        
        // Draw time labels for the current day.
        [[self.viewModel timeIntervalStringsForDayIndex:dayIdx] enumerateObjectsUsingBlock:^(NSString *timeString, NSUInteger timeIdx, BOOL * _Nonnull stop) {
            UILabel *timeLabel = [[UILabel alloc] init];
            timeLabel.text = timeString;
            timeLabel.font = [UIFont ixda_scheduleTimeLabel];
            timeLabel.textColor = [UIColor ixda_timelineTimeLabelColor];
            
            [self.scrollView addSubview:timeLabel];
            
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scrollView).offset(insets.left);
                make.height.equalTo(@(rowHeight));
                make.width.equalTo(@(timeLabelWidth));
                
                if (dayIdx == 0 && timeIdx == 0) { // The very first time label.
                    make.top.equalTo(self.scrollView).offset(insets.top);
                } else if (timeIdx == 0) { // The first time label for a certain day
                    UILabel *prev = [self.timeLabelsByDay[dayIdx-1] lastObject];
                    make.top.equalTo(prev.mas_bottom).offset(dayMargin);
                } else {
                    UILabel *prev = [self.timeLabelsByDay[dayIdx] lastObject];
                    make.top.equalTo(prev.mas_bottom);
                }
            }];
            
            [self.timeLabelsByDay[dayIdx] addObject:timeLabel];
            
            // Add horizontal divider at the top of each time label (except the first one of each day).
            if (timeIdx != 0) {
                UIView *horizontalDivider = [[UIView alloc] init];
                horizontalDivider.backgroundColor = [UIColor whiteColor];
                horizontalDivider.alpha = 0.49;
                [self.scrollView addSubview:horizontalDivider];
                [horizontalDivider mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo([self.timeLabelsByDay[dayIdx] lastObject]);
                    make.left.equalTo(self.scrollView).offset(insets.left);
                    make.right.equalTo(self.scrollView).offset(-insets.right);
                    make.height.equalTo(@1);
                    make.width.equalTo(@(dividerWidth));
                }];
            }
        }];
        
        NSArray *timeLabelsForDay = self.timeLabelsByDay[dayIdx];
        
        // Enumerate through venues/columns.
        [arrayOfVenues enumerateObjectsUsingBlock:^(NSArray *arrayOfSessions, NSUInteger venueIdx, BOOL * _Nonnull stop) {
            
            // Enumerate through sessions on the given day and in the given venue.
            [arrayOfSessions enumerateObjectsUsingBlock:^(id session, NSUInteger sessionIdx, BOOL * _Nonnull stop) {
                NSString *title = [self.viewModel typeForSessionOfArray:arrayOfSessions forIndex:sessionIdx];
                NSString *subtitle = [self.viewModel titleForSessionOfArray:arrayOfSessions forIndex:sessionIdx];
                NSArray *names = [self.viewModel speakerNamesForSessionOfArray:arrayOfSessions forIndex:sessionIdx];
                NSArray *companies = [self.viewModel companiesForSessionOfArray:arrayOfSessions forIndex:sessionIdx];
                
                IXDAScheduleSessionView *sessionView = [[IXDAScheduleSessionView alloc] initWithTitle:title subtitle:subtitle names:names companies:companies];
                [self.scrollView addSubview:sessionView];
                
                RACTuple *timeIndices = [self.viewModel timeIntervalIndicesForSessionOfArray:arrayOfSessions index:sessionIdx day:dayIdx];
                UILabel *startTimeLabel = timeLabelsForDay[[timeIndices.first unsignedIntegerValue]];
                CGFloat height = ([timeIndices.second unsignedIntegerValue] - [timeIndices.first unsignedIntegerValue]) * rowHeight;
                [sessionView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(startTimeLabel.mas_centerY);
                    make.left.equalTo(self.scrollView).offset(insets.left + timeLabelWidth + columnWidth * venueIdx);
                    make.width.equalTo(@(columnWidth - columnMargin));
                    make.height.equalTo(@(height));
                }];
            }];
        }];
    }];
    
    // Constrain last time label to scroll view.
    UILabel *lastTimeLabel = [[self.timeLabelsByDay lastObject] lastObject];
    [lastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView).offset(-insets.bottom);
    }];
    
    return self;
}


#pragma mark - UIScrollViewDelegate

@end
