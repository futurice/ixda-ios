//
//  IXDAScheduleViewModel.h
//  interaction16
//
//  Created by Erich Grunewald on 02/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IXDASessionDetailsViewModel;

@interface IXDAScheduleViewModel : NSObject

@property (nonatomic, strong) NSArray *days;

- (NSUInteger)maxNumberOfRoomsPerDay;
- (NSArray *)roomsForDayIndex:(NSUInteger)day;
- (NSArray *)roomsForDay:(NSDate *)day;
- (NSString *)roomWithIndexPath:(NSIndexPath *)indexPath; // Where section is day and row is room.
- (NSArray *)timeLabelStringsForDay:(NSUInteger)day;

- (instancetype)initWithSessions:(NSArray *)sessions speakers:(NSDictionary *)speakers days:(NSArray *)days;

- (IXDASessionDetailsViewModel *)sessionsDetailViewModelOfArray:(NSArray *)selectedSessions forIndex:(NSUInteger)index;

@end
