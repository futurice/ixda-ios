//
//  IXDAScheduleTimelineView.m
//  interaction16
//
//  Created by Erich Grunewald on 02/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAScheduleTimelineView.h"

#import "IXDAScheduleViewModel.h"

#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"

@interface IXDAScheduleTimelineView ()

@property (nonatomic, strong) IXDAScheduleViewModel *viewModel;

@end

@implementation IXDAScheduleTimelineView

- (id)initWithScheduleViewModel:(IXDAScheduleViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    
    self.backgroundColor = [UIColor ixda_timelineBackgroundColor];
    
    return self;
}

@end
