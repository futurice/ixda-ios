//
//  IXDAStarredSessionStore.h
//  interaction16
//
//  Created by Martin Hartl on 22/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSubject;

@interface IXDAStarredSessionStore : NSObject

+ (instancetype)sharedStore;

- (RACSubject *)starredEventsKeys;

- (BOOL)starredForEventKey:(NSString *)eventKey;
- (void)setStarred:(BOOL)starred forEventKey:(NSString *)eventKey;

@end
