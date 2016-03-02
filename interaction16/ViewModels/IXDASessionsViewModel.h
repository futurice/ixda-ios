//
//  IXDASessionsViewModel.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IXDASessionDay) {
    IXDASessionDayTuesday = 1,
    IXDASessionDayWednesday = 2,
    IXDASessionDayThursday = 3,
    IXDASessionDayFriday = 4
};

@class IXDASessionDetailsViewModel, IXDAScheduleViewModel, RACSignal;

@interface IXDASessionsViewModel : NSObject

@property (nonatomic, strong) NSArray *sessions;
@property (nonatomic, strong) NSDictionary *speakers;

- (void)loadSessionsFromBackend;

// The following are all sorted by start date.
- (NSArray *)keynotes;
- (NSArray *)longTalks;
- (NSArray *)mediumTalks;
- (NSArray *)lightningTalks;
- (NSArray *)workshops;
- (NSArray *)socialEvents;
- (RACSignal *)starredTalks; // A stream of the currently starred talks.

// An array of days (dates at midnight) on which there are talks or workshops.
- (NSArray *)talkDays;

// Takes an array of NSString objects representing dates (e.g. "2016-03-02") and returns an array of
// NSDate objects representing days (i.e. dates at midnight).
- (NSArray *)daysWithStrings:(NSArray *)dates;

// Takes an array of NSDate objects and returns an array of attributed string (e.g. "Tuesday, March 1").
- (NSArray *)attributedDayStringsWithDates:(NSArray *)dates dayAttributes:(NSDictionary *)dayAttributes dateAttributes:(NSDictionary *)dateAttributes;

- (NSArray *)sessionsOfDay:(IXDASessionDay)day;
- (IXDASessionDetailsViewModel *)sessionsDetailViewModelOfArray:(NSArray *)selectedSessions forIndex:(NSUInteger)index;
- (IXDAScheduleViewModel *)scheduleViewModelWithDays:(NSArray *)days;


@end
