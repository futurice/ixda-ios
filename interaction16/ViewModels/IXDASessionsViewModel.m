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
        [self sortSessionsArrayIntoSubArrays:sessions];
        [self loadSessionsFromBackend];
    }];
}

- (void)loadSessionsFromBackend {
    @weakify(self)
    [[[IXDASessionStore sharedStore] sessions] subscribeNext:^(NSArray *sessions) {
        @strongify(self)
        [self sortSessionsArrayIntoSubArrays:sessions];
    }];
}

#pragma mark - Private Helpers

- (void)sortSessionsArrayIntoSubArrays:(NSArray *)sessionsArray {
    NSMutableArray *keynotesMutableArray = [NSMutableArray new];
    NSMutableArray *longTalksMutableArray = [NSMutableArray new];
    NSMutableArray *mediumTalksMutableArray = [NSMutableArray new];
    NSMutableArray *lightningTalksMutableArray = [NSMutableArray new];
    NSMutableArray *workshopsMutableArray = [NSMutableArray new];
    for (Session *session in sessionsArray) {
        if ([session.event_type isEqualToString:@"Keynote"]) {
            [keynotesMutableArray addObject:session];
        } else if ([session.event_type isEqualToString:@"Long Talk"]){
            [longTalksMutableArray addObject:session];
        } else if ([session.event_type isEqualToString:@"Medium Talk"]) {
            [mediumTalksMutableArray addObject:session];
        } else if ([session.event_type isEqualToString:@"Lightning Talk"]) {
            [lightningTalksMutableArray addObject:session];
        } else if ([session.event_type isEqualToString:@"Workshop"]) {
            [workshopsMutableArray addObject:session];
        }
    }
    self.keynotesArray = [keynotesMutableArray copy];
    self.longTalksArray = [longTalksMutableArray copy];
    self.mediumTalksArray = [mediumTalksMutableArray copy];
    self.lightningTalksArray = [lightningTalksMutableArray copy];
    self.workshopsArray = [workshopsMutableArray copy];
}

@end
