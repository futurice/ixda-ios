//
//  IDXAWhatElseIsOnView.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface IDXAWhatElseIsOnView : UIView

@property (nonatomic, strong) RACSignal *backToMenuButtonSignal;
@property (nonatomic, strong) RACSignal *educationButtonSignal;
@property (nonatomic, strong) RACSignal *awardsButtonSignal;
@property (nonatomic, strong) RACSignal *challengeButtonSignal;

@end
