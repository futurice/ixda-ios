//
//  SessionsStore.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASessionStore.h"

#import "IXDASessionManager.h"
#import "Session.h"

#import <Mantle/Mantle.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDASessionStore

#pragma mark - Singleton

+ (instancetype)sharedStore
{
    static IXDASessionStore *_sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [[[self class] alloc] init];
    });
    
    return _sharedStore;
}

#pragma mark - Public Methods

- (RACSignal *)sessions {
    @weakify(self)
    return [[[IXDASessionManager sharedManager] GET:@"session/list?" parameters:nil] map:^NSArray *(NSArray *array) {
        @strongify(self)
        return [self sessionsArrayFromJSONArray:array];
    }];
}

- (RACSignal *)sessionsFromFile {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sessions" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        __autoreleasing NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (!error) {
            NSArray *array = [self sessionsArrayFromJSONArray:result];
            [subscriber sendNext:array];
            [subscriber sendCompleted];
        } else {
            [subscriber sendError:error];
        }
        
        return nil;
    }];
}

#pragma mark - Private Helpers

- (NSArray *)sessionsArrayFromJSONArray:(NSArray *)JSONArray {
    return [[[JSONArray rac_sequence] map:^NSArray *(NSDictionary *dict) {
        NSError *error = nil;
        return [MTLJSONAdapter modelOfClass:Session.class fromJSONDictionary:dict error:&error];
    }] array];
}
@end
