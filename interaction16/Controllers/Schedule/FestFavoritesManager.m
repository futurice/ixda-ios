//
//  FestFavouritesManager.m
//  FestApp
//
//  Created by Oleg Grenrus on 13/06/14.
//  Copyright (c) 2014 Futurice Oy. All rights reserved.
//

#import "FestFavoritesManager.h"

#import "Session.h"

#import "NSDate+Additions.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#define kFestFavouriteKey @"Favourites"

@interface FestFavoritesManager ()

@property (nonatomic, strong) RACSubject *favouritesSignal;

@end

@implementation FestFavoritesManager

+ (FestFavoritesManager *)sharedManager {
    static FestFavoritesManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *favourites = [defaults arrayForKey:kFestFavouriteKey];

        self.favouritesSignal = [RACBehaviorSubject behaviorSubjectWithDefaultValue:favourites];
    }
    return self;
}

- (void)toggleFavorite:(Session *)session favorite:(BOOL)favourite
{
    if (!session) {
        NSLog(@"error, toggling favourites without session");
        return;
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favourites = [defaults arrayForKey:kFestFavouriteKey];
    RACSubject *favouritesSubject = (RACSubject *)self.favouritesSignal;

    if (favourites == nil) {
        favourites = @[];
    }

    NSMutableArray *mutableFavourites = [NSMutableArray arrayWithArray:favourites];
    if (favourite) {
        // add only if not already there
        if ([session isKindOfClass:Session.class]) {
            if (![mutableFavourites containsObject:session.event_key]) {
                [mutableFavourites addObject:session.event_key];
            }
        }
    } else {
        // remove while there are objects
        if ([session isKindOfClass:Session.class]) {
            while ([mutableFavourites containsObject:session.event_key]) {
                [mutableFavourites removeObject:session.event_key];
            }
        }
    }

    [self toggleNotification:session favourite:favourite];

    [defaults setObject:mutableFavourites forKey:kFestFavouriteKey];
    [defaults synchronize];

    [favouritesSubject sendNext:mutableFavourites];
}

- (void)toggleNotification:(Session *)session favourite:(BOOL)favourite
{
    if (favourite) {
        
        if ([session isKindOfClass:Session.class]) {
            
            if ([session.event_start after:[NSDate date]]) {
                
                NSString *alertText = [NSString stringWithFormat:@"%@\n%@-%@ (%@)", session.name, [session.event_start hourAndMinuteString], [session.event_end hourAndMinuteString], session.venue];
                
                UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                if (localNotif == nil) {return;}
                localNotif.fireDate = [session.event_start dateByAddingTimeInterval:-kAlertIntervalInMinutes*kOneMinute];
                localNotif.alertBody = alertText;
                localNotif.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
                
                NSLog(@"added alert: %@", alertText);
            }else {
            
                UILocalNotification *notificationToCancel = nil;
                for (UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
                    if([aNotif.alertBody rangeOfString:session.name].location == 0) {
                        notificationToCancel = aNotif;
                        break;
                    }
                }
                if (notificationToCancel != nil) {
                    NSLog(@"removed alert: %@", notificationToCancel.alertBody);
                    [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
                }
            }
        }
    }
}
@end
