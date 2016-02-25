//
//  IXDAStarredSessionStore.m
//  interaction16
//
//  Created by Martin Hartl on 22/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAStarredSessionStore.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

NSString * const IXDAStarredEventsUserDefaultKey = @"IXDAStarredEventsUserDefaultKey";

@interface IXDAStarredSessionStore ()

@property (nonatomic, strong) NSSet *starredEventsKeysSet;
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) RACSubject *starredEventsKeys;

@end

@implementation IXDAStarredSessionStore


#pragma mark - Singleton

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
    self.starredEventsKeysSet = [NSSet setWithSet:[NSKeyedUnarchiver unarchiveObjectWithData:savedKeysData]];
    if (!self.starredEventsKeysSet) {
        self.starredEventsKeysSet = [NSSet set];
        [self saveStarredEventsKeysToDefaults];
    }
    
    self.starredEventsKeys = [RACBehaviorSubject behaviorSubjectWithDefaultValue:self.starredEventsKeysSet];
    
    return self;
}

#pragma mark - Public Methods

- (BOOL)starredForEventKey:(NSString *)eventKey {
    return [self.starredEventsKeysSet containsObject:eventKey];
}

- (void)setStarred:(BOOL)starred forEventKey:(NSString *)eventKey {
    NSMutableSet *mutableStarredEventsKeys = [NSMutableSet setWithSet:self.starredEventsKeysSet];
    
    if (starred && ![self.starredEventsKeysSet containsObject:eventKey]) {
        // Event should be starred and it isn't already starred.
        [mutableStarredEventsKeys addObject:eventKey];
    } else if (!starred && [self.starredEventsKeysSet containsObject:eventKey]) {
        // Event is starred and should be unstarred.
        [mutableStarredEventsKeys removeObject:eventKey];
    }
    
    self.starredEventsKeysSet = [NSSet setWithSet:mutableStarredEventsKeys];
    
    [self saveStarredEventsKeysToDefaults];
}

#pragma mark - Helper

- (void)saveStarredEventsKeysToDefaults {
    NSData *keysDataToSave = [NSKeyedArchiver archivedDataWithRootObject:[self starredEventsKeysSet]];
    [self.userDefaults setObject:keysDataToSave forKey:IXDAStarredEventsUserDefaultKey];
    [self.userDefaults synchronize];
    
    [self.starredEventsKeys sendNext:self.starredEventsKeysSet];
}

@end
