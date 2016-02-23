//
//  IXDAWorkshopDetailViewController.h
//  interaction16
//
//  Created by Erich Grunewald on 23/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IXDASessionDetailsViewModel;

@interface IXDAWorkshopDetailViewController : UIViewController

- (instancetype)initWithViewModel:(IXDASessionDetailsViewModel *)viewModel;

@end
