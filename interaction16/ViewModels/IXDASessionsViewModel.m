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
    NSMutableDictionary *mutableDiict = [[NSMutableDictionary alloc] init];
    for (Speaker *speaker in speakersArray) {
        [mutableDiict addEntriesFromDictionary:@{ speaker.name : speaker }];
    }
    return [mutableDiict copy];
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
