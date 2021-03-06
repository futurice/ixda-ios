//
//  IXDASessionManager.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASessionManager.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDASessionManager

+ (instancetype)sharedManager
{
    static IXDASessionManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:@"https://interaction16.sched.org/api"];
        _sharedManager = [[[self class] alloc] initWithBaseURL:baseURL];
        _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedManager;
}

- (RACSignal *)GET:(NSString *)URLString parameters:(id)parameters
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *urlAdditions = [NSString stringWithFormat:@"api_key=%@&format=json", [[self class] apiKey]];
        NSString *urlWithAPIKeyAndFormat = [URLString stringByAppendingString:urlAdditions];
        [super GET:urlWithAPIKeyAndFormat parameters:parameters progress:nil
           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               [subscriber sendNext:responseObject];
               [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

+ (NSString *)apiKey {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"IXDACredentials" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return dictionary[@"apiKey"];
}

@end
