//
//  IDXAProgramViewController.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IXDASessionsViewModel;

@interface IXDAProgramViewController : UIViewController

- (instancetype)initWithSessionsViewModel:(IXDASessionsViewModel *)sessionsViewModel;

@end
