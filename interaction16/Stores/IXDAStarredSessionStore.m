//
//  IXDAStarredSessionStore.m
//  interaction16
//
//  Created by Martin Hartl on 22/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAStarredSessionStore.h"

NSString * const IXDAStarredEventsUserDefaultKey = @"IXDAStarredEventsUserDefaultKey";

@interface IXDAStarredSessionStore ()

@property (nonatomic, strong) NSMutableSet *mutableStarredEventsKeys;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation IXDAStarredSessionStore

+ (instancetype)sharedStore
{
    static IXDAStarredSessionStore *_sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [[[self class] alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    });
    
    return _sharedStore;
}

- (instancetype)initWithUserDefaults:(NSUserDefaults *)userDefaults {
    self = [super init];
    if (!self) return nil;
    
    self.userDefaults = userDefaults;
    NSData *savedKeysData = [userDefaults objectForKey:IXDAStarredEventsUserDefaultKey];
    self.mutableStarredEventsKeys = [NSMutableSet setWithSet:[NSKeyedUnarchiver unarchiveObjectWithData:savedKeysData]];
    if (!self.starredEventsKeys) {
        self.mutableStarredEventsKeys = [NSMutableSet set];
        [self saveStarredEventsKeysToDefaults];
    }
    
    return self;
}

- (BOOL)starredForEventKey:(NSString *)eventKey {
    return [self.starredEventsKeys containsObject:eventKey];
}

- (void)setStarred:(BOOL)starred forEventKey:(NSString *)eventKey {
    if (starred) {
        [self.mutableStarredEventsKeys addObject:eventKey];
    } else {
        [self.mutableStarredEventsKeys removeObject:eventKey];
    }
    
    NSLog(@"set: %@", self.mutableStarredEventsKeys);
    
    [self saveStarredEventsKeysToDefaults];
}

#pragma mark - Getter

- (NSSet *)starredEventsKeys {
    return [NSSet setWithSet:self.mutableStarredEventsKeys];
}

#pragma mark - Helper

- (void)saveStarredEventsKeysToDefaults {
    NSData *keysDataToSave = [NSKeyedArchiver archivedDataWithRootObject:[self starredEventsKeys]];
    [self.userDefaults setObject:keysDataToSave forKey:IXDAStarredEventsUserDefaultKey];
    [self.userDefaults synchronize];
}

@end
