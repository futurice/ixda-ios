//
//  SessionsStore.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "SessionsStore.h"

#import "IXDASessionManager.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation SessionsStore

#pragma mark - Singleton

+ (instancetype)sharedStore
{
    static SessionsStore *_sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [[[self class] alloc] init];
    });
    
    return _sharedStore;
}

#pragma mark - Public Methods

- (RACSignal *)sessions {
    return [[IXDASessionManager sharedManager] GET:@"session/list?" parameters:nil];
}

@end
