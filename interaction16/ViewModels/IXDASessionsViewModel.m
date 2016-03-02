//
//  IXDASessionsViewModel.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASessionsViewModel.h"
#import "IXDASessionDetailsViewModel.h"

#import "Session.h"
#import "Speaker.h"
#import "IXDASessionStore.h"
#import "IXDASpeakerStore.h"
#import "IXDAStarredSessionStore.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDASessionsViewModel

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    [self loadSessions];
    [self loadSpeakers];
    
    return self;
}



- (void)loadSpeakers {
    @weakify(self)
    [[[IXDASpeakerStore sharedStore] speakersFromFile] subscribeNext:^(NSArray *speakersArray) {
        @strongify(self)
        self.speakers = [self mapSpeakersArrayToDict:speakersArray];
        [self loadSpeakerFromBackend];
    }];
}

- (void)loadSpeakerFromBackend {
    [[[IXDASpeakerStore sharedStore] speakers] subscribeNext:^(NSArray *speakersArray) {
        self.speakers = [self mapSpeakersArrayToDict:speakersArray];
    }];
}


- (void)loadSessions {
    @weakify(self)
    [[[IXDASessionStore sharedStore] sessionsFromFile] subscribeNext:^(NSArray *sessions) {
        @strongify(self)
        self.sessions = sessions;
        [self loadSessionsFromBackend];
    }];
}

- (void)loadSessionsFromBackend {
    @weakify(self)
    [[[IXDASessionStore sharedStore] sessions] subscribeNext:^(NSArray *sessions) {
        @strongify(self)
        self.sessions = sessions;
    }];
}

- (NSArray *)keynotes {
    return [self sessionsOfTypeSortedByStartDate:@"Keynote"];
}

- (NSArray *)longTalks {
    return [self sessionsOfTypeSortedByStartDate:@"Long Talk"];
}

- (NSArray *)mediumTalks {
    return [self sessionsOfTypeSortedByStartDate:@"Medium Talk"];
}

- (NSArray *)lightningTalks {
    return [self sessionsOfTypeSortedByStartDate:@"Lightning Talk"];
}

- (NSArray *)workshops {
    return [self sessionsOfTypeSortedByStartDate:@"Workshop"];
}

- (NSArray *)socialEvents {
    return [self sessionsOfTypeSortedByStartDate:@"Social Event"];
}

- (RACSignal *)starredTalks {
    // Observe changes to sessions and starred events set, and then return the sessions that have been starred.
    return [[RACObserve(self, sessions) combineLatestWith:[[IXDAStarredSessionStore sharedStore] starredEventsKeys]]
            map:^id(RACTuple *tuple) {
                NSArray *sessions = tuple.first;
                NSSet *starredEventsKeys = tuple.second;
                
                return [[[[sessions rac_sequence] filter:^BOOL(Session *session) {
                    return [starredEventsKeys containsObject:session.event_key];
                }] array] sortedArrayUsingComparator:^NSComparisonResult(Session *a, Session *b) {
                    return [a.event_start compare:b.event_start];
                }];
    }];
}

// Returns an array of days (without time components) on which there are talks or workshops.
- (NSArray *)talkDays {
    // Look through all talks and add the dates for which there are sessions.
    return [[[[[self.sessions rac_sequence] filter:^BOOL(Session *session) {
        return ([session.event_type isEqualToString:@"Keynote"]
                || [session.event_type isEqualToString:@"Long Talk"]
                || [session.event_type isEqualToString:@"Medium Talk"]
                || [session.event_type isEqualToString:@"Lightning Talk"]
                || [session.event_type isEqualToString:@"Workshop"]);
    }] foldLeftWithStart:@[] reduce:^id(NSArray *acc, Session *session) {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:acc];
        RACTuple *days = [self sessionDays:session];
        
        if (![newArr containsObject:days.first]) {
            [newArr addObject:days.first];
        }
        if (![newArr containsObject:days.second]) {
            [newArr addObject:days.second];
        }
        
        return newArr;
    }] array] sortedArrayUsingComparator:^NSComparisonResult(NSDate *one, NSDate *two) {
        return [one compare:two];
    }];
}

// Takes an array of NSString objects representing dates (e.g. "2016-03-02") and returns an array of
// NSDate objects representing days (i.e. without time components).
- (NSArray *)daysWithStrings:(NSArray *)dayStrings {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });
    
    return [[[dayStrings rac_sequence] map:^id(NSString *dateString) {
        return [_dateFormatter dateFromString:dateString];
    }] array];
}

// Takes an array of NSDate objects and returns an array of attributed string (e.g. "Tuesday, March 1").
- (NSArray *)attributedDayStringsWithDates:(NSArray *)dates dayAttributes:(NSDictionary *)dayAttributes dateAttributes:(NSDictionary *)dateAttributes {
    // Initialise date formatters once.
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
    
    return [[[dates rac_sequence] map:^id(NSDate *day) {
        NSString *weekday = [_dayFormatter stringFromDate:day];
        NSString *date = [_dateFormatter stringFromDate:day];
        NSString *titleString = [NSString stringWithFormat:@"%@, %@", weekday, date];
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:titleString attributes:dayAttributes];
        [attributedTitle setAttributes:dateAttributes range:NSMakeRange(weekday.length + 1, titleString.length - weekday.length - 1)];
        return attributedTitle;
    }] array];
    
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

- (NSArray *)sessionsOfType:(NSString *)sessionType {
    return [[[self.sessions rac_sequence] filter:^BOOL(Session *session) {
        return [session.event_type isEqualToString:sessionType];
    }] array];
}

- (NSArray *)sessionsOfTypeSortedByStartDate:(NSString *)sessionType {
    return [[[[self.sessions rac_sequence] filter:^BOOL(Session *session) {
        return [session.event_type isEqualToString:sessionType];
    }] array] sortedArrayUsingComparator:^NSComparisonResult(Session *a, Session *b) {
        return [a.event_start compare:b.event_start];
    }];
}

- (NSArray *)sessionsOfDay:(IXDASessionDay)sessionType {
    return [[[self.sessions rac_sequence] filter:^BOOL(Session *session) {
        NSInteger day = [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:session.event_start] day];
        return day == sessionType;
    }] array];
}

- (NSDictionary *)mapSpeakersArrayToDict:(NSArray *)speakersArray {
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
    for (Speaker *speaker in speakersArray) {
        [mutableDict addEntriesFromDictionary:@{ speaker.name : speaker }];
    }
    return [mutableDict copy];
}

- (NSArray *)speakersOfSession:(NSString *)speakersString {
    return [[[[speakersString componentsSeparatedByString:@", "] rac_sequence] map:^Speaker*(NSString *name) {
        return [self speakerBy:name];
    }] array];
}

- (Speaker *)speakerBy:(NSString *)name {
    return self.speakers[name];
}

// Returns the start day and end day (without time components) of a given session.
- (RACTuple *)sessionDays:(Session *)session {
    unsigned int flags = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *startComponents = [[NSCalendar currentCalendar] components:flags fromDate:session.event_start];
    NSDateComponents *endComponents = [[NSCalendar currentCalendar] components:flags fromDate:session.event_end];
    [startComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [endComponents setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate *startDay = [[NSCalendar currentCalendar] dateFromComponents:startComponents];
    NSDate *endDay = [[NSCalendar currentCalendar] dateFromComponents:endComponents];
    
    return RACTuplePack(startDay, endDay);
}

@end
