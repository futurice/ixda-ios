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

- (RACSignal *)speakers {
    return [[[IXDASessionManager sharedManager] GET:@"user/list?fields=name,role,avatar,about,company,position,location&" parameters:nil] map:^NSArray *(NSArray *array) {
        return [[[[array rac_sequence] filter:^BOOL(NSDictionary *dict) {
            return [dict[@"role"] isEqualToString:@"speaker"];
        }] map:^NSArray *(NSDictionary *dict) {
            NSError *error = nil;
            return [MTLJSONAdapter modelOfClass:Speaker.class fromJSONDictionary:dict error:&error];
        }] array];
    }];
}


- (RACSignal *)speakersFromFile {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"speakers" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        __autoreleasing NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (!error) {
            NSArray *array = [self speakersArrayFromJSONArray:result];
            [subscriber sendNext:array];
            [subscriber sendCompleted];
        } else {
            [subscriber sendError:error];
        }
        
        return nil;
    }];
}

#pragma mark - Private Helpers

- (NSArray *)speakersArrayFromJSONArray:(NSArray *)JSONArray {
    return [[[JSONArray rac_sequence] map:^NSArray *(NSDictionary *dict) {
        NSError *error = nil;
        return [MTLJSONAdapter modelOfClass:Speaker.class fromJSONDictionary:dict error:&error];
    }] array];
}

@end
