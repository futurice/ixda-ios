//
//  IXDAScheduleSessionView.h
//  interaction16
//
//  Created by Erich Grunewald on 02/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal, IXDASessionDetailsViewModel;

@interface IXDAScheduleSessionView : UIView

@property (nonatomic, strong) RACSignal *sessionButtonSignal;
@property (nonatomic, strong) RACSignal *plusButtonSignal;

- (instancetype)initWithSessionDetailsViewModel:(IXDASessionDetailsViewModel *)viewModel;

@end
