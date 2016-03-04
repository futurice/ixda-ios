//
//  IXDAScheduleViewModel.h
//  interaction16
//
//  Created by Erich Grunewald on 02/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IXDASessionDetailsViewModel, RACTuple;

@interface IXDAScheduleViewModel : NSObject

@property (nonatomic, assign) NSUInteger maxNumberOfVenuesPerDay;

- (instancetype)initWithSessions:(NSArray *)sessions speakers:(NSDictionary *)speakers days:(NSArray *)days;

// Returns an array of days, each of which holds an array of venues, each
// of which holds an array of sessions on that day and in that venue.
- (NSArray *)sessionsByDayAndVenue;

- (NSArray *)venuesWithDayIndex:(NSUInteger)dayIndex;

// E.g. ["08:45", "09:00", "09:15", "09:30" ...]
- (NSArray *)timeIntervalStringsForDayIndex:(NSUInteger)day;

// Returns a tuple containing the indices of the intervals corresponding to
// a given session's start and end times.
- (RACTuple *)timeIntervalIndicesForSessionOfArray:(NSArray *)selectedSessions index:(NSUInteger)sessionIndex day:(NSUInteger)dayIndex;

- (NSString *)eventKeyForSessionOfArray:(NSArray *)selectedSessions forIndex:(NSUInteger)index;

- (IXDASessionDetailsViewModel *)sessionsDetailViewModelOfArray:(NSArray *)selectedSessions forIndex:(NSUInteger)index;

@end
