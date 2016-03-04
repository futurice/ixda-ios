//
//  IXDAScheduleViewController.h
//  interaction16
//
//  Created by Erich Grunewald on 01/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IXDASessionsViewModel;

@interface IXDAScheduleViewController : UIViewController

- (instancetype)initWithSessionsViewModel:(IXDASessionsViewModel *)sessionsViewModel;

@end
