//
//  SessionsStore.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface IXDASessionStore : NSObject

+ (instancetype)sharedStore;
- (RACSignal *)sessions;
- (RACSignal *)sessionsFromFile;

@end
