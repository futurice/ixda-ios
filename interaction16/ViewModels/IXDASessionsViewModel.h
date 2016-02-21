//
//  IXDASessionsViewModel.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IXDASessionDay) {
    IXDASessionDayWednesday,
    IXDASessionDayThursday,
    IXDASessionDayFriday,
    IXDASessionDaySaturday
};

@class IXDASessionDetailsViewModel;

@interface IXDASessionsViewModel : NSObject

@property (nonatomic, strong) NSArray *sessions;
@property (nonatomic, strong) NSDictionary *speakers;

- (void)loadSessionsFromBackend;
- (NSArray *)keynotes;
- (NSArray *)longTalks;
- (NSArray *)mediumTalks;
- (NSArray *)lightningTalks;
- (NSArray *)workshops;
- (NSArray *)socialEvents;

- (NSArray *)sessionsOfDay:(IXDASessionDay)day;
- (IXDASessionDetailsViewModel *)sessionsDetailViewModelOfArray:(NSArray *)selectedSessions forIndex:(NSUInteger)index;


@end
