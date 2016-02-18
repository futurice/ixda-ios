//
//  IXDASessionsViewModel.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASessionsViewModel.h"

#import "Session.h"
#import "IXDASessionStore.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDASessionsViewModel

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    [self loadSessions];
    
    return self;
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
    return [self sessionsOfType:@"Keynote"];
}

- (NSArray *)longTalks {
    return [self sessionsOfType:@"Long Talk"];
}

- (NSArray *)mediumTalks {
    return [self sessionsOfType:@"Medium Talk"];
}

- (NSArray *)lightningTalks {
    return [self sessionsOfType:@"Lightning Talk"];
}

- (NSArray *)workshops {
    return [self sessionsOfType:@"Workshop"];
}

- (NSArray *)socialEvents {
    return [self sessionsOfType:@"Social Event"];
}

#pragma mark - Private Helpers

- (NSArray *)sessionsOfType:(NSString *)sessionType {
    return [[[self.sessions rac_sequence] filter:^BOOL(Session *session) {
        return [session.event_type isEqualToString:sessionType];
    }] array];
}

- (NSArray *)sessionsOfDay:(IXDASessionDay)sessionType {
    return [[[self.sessions rac_sequence] filter:^BOOL(Session *session) {
        NSInteger day = [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:session.event_start] day];
        return day == sessionType;
    }] array];
}

@end
