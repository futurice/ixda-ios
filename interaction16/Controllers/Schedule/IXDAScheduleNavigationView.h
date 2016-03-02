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
@property (nonatomic, strong) NSNumber *expanded;
@property (nonatomic, strong) NSNumber *selectedDay;

// Takes an array of strings or attributed strings, a base height and a row height.
- (instancetype)initWithDayStrings:(NSArray *)dayStrings baseHeight:(CGFloat)baseHeight rowHeight:(CGFloat)rowHeight;

@end
