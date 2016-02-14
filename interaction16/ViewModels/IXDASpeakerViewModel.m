//
//  IXDASpeakerViewModel.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakerViewModel.h"

#import "IXDASpeakerStore.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDASpeakerViewModel

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    [self loadSpeaker];
    
    return self;
}

- (void)loadSpeaker {
    [[[IXDASpeakerStore sharedStore] speaker] subscribeNext:^(NSArray *speakersArray) {
        self.speakerArray = speakersArray;
    }];
}

@end
