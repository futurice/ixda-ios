//
//  IXDAScheduleTimelineView.h
//  interaction16
//
//  Created by Erich Grunewald on 02/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IXDAScheduleViewModel, RACSignal, RACSubject;

@interface IXDAScheduleTimelineView : UIView

@property (nonatomic, strong) RACSignal *scrollSignal;

// For navigationg to session detail views (emits session ids).
@property (nonatomic, strong) RACSubject *selectSessionSignal;

- (instancetype)initWithScheduleViewModel:(IXDAScheduleViewModel *)viewModel;

- (void)scrollToDayWithIndex:(NSUInteger)dayIndex animated:(BOOL)animated;

@end
