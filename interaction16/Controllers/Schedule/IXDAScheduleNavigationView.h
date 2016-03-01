//
//  IXDAScheduleNavigationView.h
//  interaction16
//
//  Created by Erich Grunewald on 01/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface IXDAScheduleNavigationView : UIView

@property (nonatomic, strong) RACSignal *backButtonSignal;

- (instancetype)initWithDays:(NSArray *)days;
@property (nonatomic, strong) NSString *selectedDay;

@end
