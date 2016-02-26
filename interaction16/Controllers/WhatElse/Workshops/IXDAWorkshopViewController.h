//
//  IXDAWorkshopViewController.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 17/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IXDASessionsViewModel;

@interface IXDAWorkshopViewController : UIViewController

- (instancetype)initWithSessionsViewModel:(IXDASessionsViewModel *)viewModel;

@end
