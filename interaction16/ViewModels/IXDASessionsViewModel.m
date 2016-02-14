//
//  IXDASessionsViewModel.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASessionsViewModel.h"

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
    [[[IXDASessionStore sharedStore] sessions] subscribeNext:^(NSArray *array) {
        self.keynotesArray = array;
    }];
}

@end
