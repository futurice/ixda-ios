//
//  IXDASpeakerDetailViewController.h
//  interaction16
//
//  Created by Erich Grunewald on 23/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IXDASpeakerDetailViewModel;

@interface IXDASpeakerDetailViewController : UIViewController

- (instancetype)initWithViewModel:(IXDASpeakerDetailViewModel *)viewModel;

@end
