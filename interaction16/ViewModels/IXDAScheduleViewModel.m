//
//  IXDAScheduleViewModel.m
//  interaction16
//
//  Created by Erich Grunewald on 02/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAScheduleViewModel.h"
#import "IXDASessionDetailsViewModel.h"
#import "Session.h"
#import "Speaker.h"
#import "NSDate+Additions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

static const NSTimeInterval tickInterval = 15 * 60; // 15 minutes.

@interface IXDAScheduleViewModel ()

@property (nonatomic, strong) NSArray *days;
@property (nonatomic, strong) NSArray *sessions;
@property (nonatomic, strong) NSDictionary *speakers;
@property (nonatomic, strong) NSArray *timeIntervalsByDay;

@end

@implementation IXDAScheduleViewModel

- (instancetype)initWithSessions:(NSArray *)sessions speakers:(NSDictionary *)speakers days:(NSArray *)days {
    self = [super init];
    if (!self) return nil;
    
    self.sessions = sessions;
    self.speakers = speakers;
    self.days = days;
    
    // The maximum number of different venues that are being occupied on any given day.
    self.maxNumberOfVenuesPerDay = [[[[self.days rac_sequence] map:^id(NSDate *day) {
        return @([self venueIdsForDay:day].count);
    }] foldLeftWithStart:@0 reduce:^id(NSNumber *max, NSNumber *numberOfVenues) {
        return @(MAX([max integerValue], [numberOfVenues integerValue]));
    }] unsignedIntegerValue];;
    
    self.timeIntervalsByDay = [[[self.days rac_sequence] map:^id(NSDate *day) {
        return [self timeIntervalsForDay:day];
    }] array];
    
    return self;
}

// Returns an array of days, each of which holds an array of venues, each
// of which holds an array of sessions on that day and in that venue.
- (NSArray *)sessionsByDayAndVenue {
    return [[[self.days rac_sequence] map:^id(NSDate *day) {
        return [[[[self venueIdsForDay:day] rac_sequence] map:^id(NSString *venue) {
            // Filter out sessions that aren't on the day and venue in question.
            return [[[[self.sessions rac_sequence] filter:^BOOL(Session *session) {
                return ([session.venue_id isEqual:venue] && [self session:session isOnDay:day]);
            }] array] sortedArrayUsingComparator:^NSComparisonResult(Session *first, Session *second) {
                return [first.event_start compare:second.event_start];
            }];
        }] array];
    }] array];
}

- (NSArray *)venuesWithDayIndex:(NSUInteger)dayIndex {
    return [self venuesForDay:self.days[dayIndex]];
}

// E.g. ["08:45", "09:00", "09:15", "09:30" ...]
- (NSArray *)timeIntervalStringsForDayIndex:(NSUInteger)day {
    return [[[self.timeIntervalsByDay[day] rac_sequence] map:^id(NSNumber *timeInterval) {
        return [[NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]] hourAndMinuteString];
    }] array];
}

- (RACTuple *)timeIntervalIndicesForSessionOfArray:(NSArray *)selectedSessions index:(NSUInteger)sessionIndex day:(NSUInteger)dayIndex {
    Session *session = selectedSessions[sessionIndex];
    NSTimeInterval sessionStart = [session.event_start timeIntervalSince1970];
    NSTimeInterval sessionEnd = [session.event_end timeIntervalSince1970];
    NSUInteger startIndex = 0;
    NSUInteger endIndex = 0;
    
    for (NSNumber *timeInterval in self.timeIntervalsByDay[dayIndex]) {
        if ([timeInterval doubleValue] < sessionStart) startIndex++;
        if ([timeInterval doubleValue] < sessionEnd) endIndex++;
    }
    
    return RACTuplePack(@(startIndex), @(endIndex));
}

- (NSString *)eventKeyForSessionOfArray:(NSArray *)selectedSessions forIndex:(NSUInteger)index {
    NSString *eventKey = @"";
    if ([selectedSessions objectAtIndex:index]) {
        Session *session = selectedSessions[index];
        eventKey = session.event_key;
    }
    return eventKey;
}

- (IXDASessionDetailsViewModel *)sessionsDetailViewModelOfArray:(NSArray *)selectedSessions forIndex:(NSUInteger)index {
    IXDASessionDetailsViewModel *viewModel = nil;
    if ([selectedSessions objectAtIndex:index]) {
        Session *session = selectedSessions[index];
        NSArray *speakers = [self speakersOfSession:session.speakers];
        viewModel = [[IXDASessionDetailsViewModel alloc] initWithSession:session speakers:speakers];
    }
    return viewModel;
}


#pragma mark - Private Helpers

// E.g. [92_347_832, 92_348_732, 92_349_632 ...]
- (NSArray *)timeIntervalsForDay:(NSDate *)day {
    NSDate *dayStart = [self firstSessionOfDay:day].event_start;
    NSDate *dayEnd = [self lastSessionOfDay:day].event_end;
    
    NSTimeInterval currentTime = [dayStart timeIntervalSince1970] - fmod([dayStart timeIntervalSince1970], tickInterval);
    NSTimeInterval lastTime = [dayEnd timeIntervalSince1970];
    NSMutableArray *timeIntervals = [NSMutableArray array];
    
    while (currentTime <= lastTime) {
        [timeIntervals addObject:@(currentTime)];
        currentTime += tickInterval;
    }
    
    
    return timeIntervals;
}

- (NSArray *)venuesForDay:(NSDate *)day {
    return [[[[[self sessionsOfDay:day] rac_sequence] map:^id(Session *session) {
        return session.venue;
    }] map:^id(NSString *venue) {
        return [venue capitalizedString];
    }] foldLeftWithStart:@[] reduce:^id(NSArray *acc, NSString *venue) {
        NSMutableArray *venues = [NSMutableArray arrayWithArray:acc];
        if (![venues containsObject:venue]) {
            [venues addObject:venue];
        }
        return venues;
    }];
}

- (NSArray *)venueIdsForDay:(NSDate *)day {
    return [[[[self sessionsOfDay:day] rac_sequence] map:^id(Session *session) {
        return session.venue_id;
    }] foldLeftWithStart:@[] reduce:^id(NSArray *acc, NSString *venueId) {
        NSMutableArray *venueIds = [NSMutableArray arrayWithArray:acc];
        if (![venueIds containsObject:venueId]) {
            [venueIds addObject:venueId];
        }
        return venueIds;
    }];
}

// Where day is an NSDate at midnight (i.e. without time components).
- (NSArray *)sessionsOfDay:(NSDate *)day {
    return [[[self.sessions rac_sequence] filter:^BOOL(Session *session) {
        return [self session:session isOnDay:day];
    }] array];
}

- (BOOL)session:(Session *)session isOnDay:(NSDate *)day {
    return [day isEqual:[session.event_start sameDateWithMidnightTimestamp]];
}

- (Session *)firstSessionOfDay:(NSDate *)day {
    return [[[self sessionsOfDay:day] sortedArrayUsingComparator:^NSComparisonResult(Session *first, Session *second) {
        return [first.event_start compare:second.event_start];
    }] firstObject];
}

- (Session *)lastSessionOfDay:(NSDate *)day {
    return [[[self sessionsOfDay:day] sortedArrayUsingComparator:^NSComparisonResult(Session *first, Session *second) {
        return [first.event_end compare:second.event_end];
    }] lastObject];
}

- (NSArray *)speakersOfSession:(NSString *)speakersString {
    return [[[[speakersString componentsSeparatedByString:@", "] rac_sequence] map:^Speaker*(NSString *name) {
        return [self speakerBy:name];
    }] array];
}

- (Speaker *)speakerBy:(NSString *)name {
    return self.speakers[name];
}

@end
