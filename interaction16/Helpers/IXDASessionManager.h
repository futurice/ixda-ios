//
//  IXDASessionManager.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class RACSignal;

@interface IXDASessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (RACSignal *)GET:(NSString *)URLString parameters:(id)parameters;

@end
