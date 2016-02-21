//
//  IXDATalkDetailViewController.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 20/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IXDASessionDetailsViewModel;

@interface IXDATalkDetailViewController : UIViewController

- (instancetype)initWithViewModel:(IXDASessionDetailsViewModel *)viewModel;

@end
