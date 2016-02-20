//
//  IXDASessionsViewModel.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASessionsViewModel.h"

#import "Session.h"
#import "Speaker.h"
#import "IXDASessionStore.h"
#import "IXDASpeakerStore.h"

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

- (NSDictionary *)mapSpeakersArrayToDict:(NSArray *)speakersArray {
    NSMutableDictionary *mutableDiict = [[NSMutableDictionary alloc] init];
    for (Speaker *speaker in speakersArray) {
        [mutableDiict addEntriesFromDictionary:@{ speaker.name : speaker }];
    }
    return [mutableDiict copy];
}

@end
