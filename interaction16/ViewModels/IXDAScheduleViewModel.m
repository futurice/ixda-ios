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

@interface IXDAScheduleViewModel ()

@property (nonatomic, strong) NSArray *sessions;
@property (nonatomic, strong) NSDictionary *speakers;

@end

@implementation IXDAScheduleViewModel

- (instancetype)initWithSessions:(NSArray *)sessions speakers:(NSDictionary *)speakers days:(NSArray *)days {
    self = [super init];
    if (!self) return nil;
    
    self.sessions = sessions;
    self.speakers = speakers;
    self.days = days;
    
    return self;
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

- (NSUInteger)maxNumberOfRoomsPerDay {
    return [[[[self.days rac_sequence] map:^id(NSDate *day) {
        return @([self roomsForDay:day].count);
    }] foldLeftWithStart:@0 reduce:^id(NSNumber *max, NSNumber *numberOfRooms) {
        return @(MAX([max integerValue], [numberOfRooms integerValue]));
    }] unsignedIntegerValue];
}

- (NSArray *)roomsForDay:(NSDate *)day {
    return [[[[self sessionsOfDay:day] rac_sequence] map:^id(Session *session) {
        return session.venue;
    }] foldLeftWithStart:@[] reduce:^id(NSArray *acc, NSString *venue) {
        NSMutableArray *rooms = [NSMutableArray arrayWithArray:acc];
        if (![rooms containsObject:venue]) {
            [rooms addObject:venue];
        }
        return rooms;
    }];
}

- (NSArray *)roomsForDayIndex:(NSUInteger)day {
    return [self roomsForDay:self.days[day]];
}

- (NSString *)roomWithIndexPath:(NSIndexPath *)indexPath {
    NSArray *rooms = [self roomsForDayIndex:indexPath.section];
    return rooms[indexPath.row];
}

// TODO: Implement this.
- (NSArray *)timeLabelStringsForDay:(NSUInteger)day {
    NSDate *dayStart = [self firstSessionOfDay:self.days[day]].event_start;
    NSDate *dayEnd = [self lastSessionOfDay:self.days[day]].event_end;
    
    NSInteger interval = 15; // Minutes.
    NSInteger currentHour = [dayStart hour];
    NSInteger currentMinute = 0;
    NSMutableArray *timeStrings = [NSMutableArray array];
    
    while (currentHour <= [dayEnd hour]) {
        NSDate *time = [[NSCalendar currentCalendar] dateBySettingHour:currentHour minute:currentMinute second:0 ofDate:[NSDate date] options:0];
        [timeStrings addObject:[time hourAndMinuteString]];
        
        // Increment times.
        if (currentMinute + interval >= 60) {
            currentHour++;
            currentMinute = 0;
        } else {
            currentMinute += interval;
        }
    }
    
    return timeStrings;
}


#pragma mark - Private Helpers

// Where day is an NSDate at midnight (i.e. without time components).
- (NSArray *)sessionsOfDay:(NSDate *)day {
    return [[[self.sessions rac_sequence] filter:^BOOL(Session *session) {
        return [day isEqual:[session.event_start sameDateWithMidnightTimestamp]];
    }] array];
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
