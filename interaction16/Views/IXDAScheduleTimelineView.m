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
#import "IXDASessionDetailsViewModel.h"
#import "IXDAScheduleVenuesView.h"

#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

static const CGFloat rowHeight = 24.0;
static const CGFloat dayMargin = 48.0;
static const CGFloat timeLabelWidth = 60.0;
static const CGFloat columnWidth = 180.0;
static const CGFloat columnMargin = 10.0;

@interface IXDAScheduleTimelineView () <UIScrollViewDelegate>

@property (nonatomic, strong) IXDAScheduleViewModel *viewModel;
@property (nonatomic, strong) NSArray *sessionsByDayAndVenue;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *timeLabelsByDay;
@property (nonatomic, strong) IXDAScheduleVenuesView *venuesView;

@end

@implementation IXDAScheduleTimelineView

- (id)initWithScheduleViewModel:(IXDAScheduleViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    self.viewModel = viewModel;
    self.sessionsByDayAndVenue = [self.viewModel sessionsByDayAndVenue];
    self.selectSessionSignal = [RACSubject subject];
    
    self.backgroundColor = [UIColor ixda_timelineBackgroundColor];
    
    // Set up scroll view.
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.directionalLockEnabled = YES;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(dayMargin, 20, 20, 20);
    
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
    }];
    
    // Constrain last time label to scroll view.
    UILabel *lastTimeLabel = [[self.timeLabelsByDay lastObject] lastObject];
    [lastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView).offset(-insets.bottom);
    }];
    
    // Venues view - horizontal banner at top showing venues.
    self.venuesView = [[IXDAScheduleVenuesView alloc] initWithNumberOfVenues:numberOfColumns leadSpacing:(insets.left + timeLabelWidth) tailSpacing:insets.right itemSpacing:columnMargin columnWidth:columnWidth];
    self.venuesView.userInteractionEnabled = NO;
    [self.venuesView setVenueTexts:[self.viewModel venuesWithDayIndex:0]];
    [self addSubview:self.venuesView];
    [self.venuesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(insets.top));
    }];
    
    [self setUpScrollSignal];
    
    // Update venue labels whenever the user scrolls to a new day.
    @weakify(self)
    [[self.scrollSignal deliverOnMainThread] subscribeNext:^(NSNumber *visibleDay) {
        @strongify(self)
        [self.venuesView setVenueTexts:[self.viewModel venuesWithDayIndex:[visibleDay unsignedIntegerValue]]];
    }];
    
    // Draw the session views asynchronously, since it takes some time.
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *sessionViews = [self setUpSessionViewsWithInsets:insets];
        
        // Fade in all of the session views.
        [UIView animateWithDuration:0.2 animations:^{
            [sessionViews enumerateObjectsUsingBlock:^(IXDAScheduleSessionView *sessionView, NSUInteger idx, BOOL * _Nonnull stop) {
                sessionView.alpha = 1.0;
            }];
        }];
    });
    
    return self;
}

- (NSArray *)setUpSessionViewsWithInsets:(UIEdgeInsets)insets {
    NSMutableArray *sessionViews = [NSMutableArray array];
    
    // Enumerate through days, drawing the appropriate views for each one.
    [self.viewModel.sessionsByDayAndVenue enumerateObjectsUsingBlock:^(NSArray *arrayOfVenues, NSUInteger dayIdx, BOOL * _Nonnull stop) {
    
        NSArray *timeLabelsForDay = self.timeLabelsByDay[dayIdx];
        
        // Enumerate through venues/columns.
        [arrayOfVenues enumerateObjectsUsingBlock:^(NSArray *arrayOfSessions, NSUInteger venueIdx, BOOL * _Nonnull stop) {
            
            // Enumerate through sessions on the given day and in the given venue.
            [arrayOfSessions enumerateObjectsUsingBlock:^(id session, NSUInteger sessionIdx, BOOL * _Nonnull stop) {
                IXDASessionDetailsViewModel *detailsViewModel = [self.viewModel sessionsDetailViewModelOfArray:arrayOfSessions forIndex:sessionIdx];
                IXDAScheduleSessionView *sessionView = [[IXDAScheduleSessionView alloc] initWithSessionDetailsViewModel:detailsViewModel];
                [self.scrollView addSubview:sessionView];
                
                RACTuple *timeIndices = [self.viewModel timeIntervalIndicesForSessionOfArray:arrayOfSessions index:sessionIdx day:dayIdx];
                UILabel *startTimeLabel = timeLabelsForDay[[timeIndices.first unsignedIntegerValue]];
                CGFloat height = ([timeIndices.second unsignedIntegerValue] - [timeIndices.first unsignedIntegerValue]) * rowHeight;
                height = fmaxf(0.0, height - 2);
                [sessionView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(startTimeLabel.mas_centerY);
                    make.left.equalTo(self.scrollView).offset(insets.left + timeLabelWidth + columnWidth * venueIdx);
                    make.width.equalTo(@(columnWidth - columnMargin));
                    make.height.equalTo(@(height));
                }];
                
                // When the session view panel is pressed, emit corresponding session key in selectSessionSignal.
                [sessionView.sessionButtonSignal subscribeNext:^(UIButton *button) {
                    [self.selectSessionSignal sendNext:[self.viewModel eventKeyForSessionOfArray:arrayOfSessions forIndex:sessionIdx]];
                }];
                
                // When the plus button is pressed, set the session to be starred/unstarred.
                [sessionView.plusButtonSignal subscribeNext:^(UIButton *button) {
                    BOOL newStarred = ![detailsViewModel starred];
                    [detailsViewModel setStarred:newStarred];
                }];
                
                // Hide session views and add them to an array to be shown later.
                sessionView.alpha = 0.0;
                [sessionViews addObject:sessionView];
            }];
        }];
    }];
    
    return sessionViews;
}


#pragma mark - Scroll View

- (void)setUpScrollSignal {
    // This signal returns an NSNumber with the index of the day that is currently being viewed.
    self.scrollSignal = [[self rac_signalForSelector:@selector(scrollViewDidScroll:) fromProtocol:@protocol(UIScrollViewDelegate)] map:^id(RACTuple *tuple) {
        UIScrollView *scrollView = tuple.first;
        __block NSInteger dayIndex = -1;
        [self.timeLabelsByDay enumerateObjectsUsingBlock:^(NSArray *timeLabels, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *firstTimeLabelOfDay = [timeLabels firstObject];
            if (scrollView.contentOffset.y > (firstTimeLabelOfDay.frame.origin.y - dayMargin)) {
                dayIndex++;
            } else {
                *stop = YES;
            }
        }];
        dayIndex = MIN(self.timeLabelsByDay.count, MAX(dayIndex, 0));
        return @(dayIndex);
    }];
}

// Need to implement this in order to bind the scrolling signal.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update x-position of venues view so that it corresponds to the columns in the scroll view.
    [self.venuesView setContentOffsetX:scrollView.contentOffset.x];
}

// Scrolls to the top of the selected day, unless that day is already being shown.
- (void)scrollToDayWithIndex:(NSUInteger)dayIndex animated:(BOOL)animated {
    UILabel *firstTimeLabelOfDay = [self.timeLabelsByDay[dayIndex] firstObject];
    
    CGFloat currentY = self.scrollView.contentOffset.y;
    CGFloat dayY = firstTimeLabelOfDay.frame.origin.y - dayMargin + 1.0;
    CGFloat contentHeight = self.bounds.size.height;
    
    if (currentY < dayY || currentY > (dayY + contentHeight)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, dayY) animated:animated];
    }
}

@end
