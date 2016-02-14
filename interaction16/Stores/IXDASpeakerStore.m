//
//  IXDAUserStore.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakerStore.h"

#import "Speaker.h"

#import "IXDASessionManager.h"

#import <Mantle/Mantle.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDASpeakerStore


#pragma mark - Singleton

+ (instancetype)sharedStore
{
    static IXDASpeakerStore *_sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [[[self class] alloc] init];
    });
    
    return _sharedStore;
}

#pragma mark - Public Methods

- (RACSignal *)speaker {
    return [[[IXDASessionManager sharedManager] GET:@"user/list?fields=name,role,avatar,about,company,position,location&" parameters:nil] map:^NSArray *(NSArray *array) {
        return [[[[array rac_sequence] map:^NSArray *(NSDictionary *dict) {
            NSError *error = nil;
            return [MTLJSONAdapter modelOfClass:Speaker.class fromJSONDictionary:dict error:&error];
        }] filter:^BOOL(Speaker *speaker) {
            return [speaker.role isEqualToString:@"speaker"];
        }] array];
    }];
}

@end
