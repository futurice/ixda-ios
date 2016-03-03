//
//  IXDAScheduleNavigationView.h
//  interaction16
//
//  Created by Erich Grunewald on 01/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal, RACSubject;

@interface IXDAScheduleNavigationView : UIView

@property (nonatomic, strong) RACSignal *backButtonSignal;

// This boolean is true when the menu is expanded and false otherwise.
@property (nonatomic, strong) NSNumber *expanded;

// This signal only emits values when a menu button is pressed, not when a day
// is selected by other means (e.g. with the -setSelectedDayIndex: method).
@property (nonatomic, strong) RACSubject *selectedDaySignal;

// Takes an array of strings or attributed strings, a base height and a row height.
- (instancetype)initWithDayStrings:(NSArray *)dayStrings baseHeight:(CGFloat)baseHeight rowHeight:(CGFloat)rowHeight;

- (void)setSelectedDayIndex:(NSUInteger)dayIndex;

@end
