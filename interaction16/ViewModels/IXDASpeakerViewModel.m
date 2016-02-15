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
    
    [self loadSpeakers];
    
    return self;
}



- (void)loadSpeakers {
    @weakify(self)
    [[[IXDASpeakerStore sharedStore] speakersFromFile] subscribeNext:^(NSArray *speakersArray) {
        @strongify(self)
        self.speakerArray = speakersArray;
        [self loadSpeakerFromBackend];
    }];
}

- (void)loadSpeakerFromBackend {
    [[[IXDASpeakerStore sharedStore] speakers] subscribeNext:^(NSArray *speakersArray) {
        self.speakerArray = speakersArray;
    }];
}

@end
