//
//  IXDAMenuView.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface IXDAMenuView : UIView

@property (nonatomic, strong) RACSignal *programButtonSignal;
@property (nonatomic, strong) RACSignal *speakersButtonSignal;
@property (nonatomic, strong) RACSignal *scheduleButtonSignal;
@property (nonatomic, strong) RACSignal *workshopsButtonSignal;
@property (nonatomic, strong) RACSignal *venueAndMapButtonSignal;
@property (nonatomic, strong) RACSignal *infoButtonSignal;
@property (nonatomic, strong) RACSignal *whatElseIsOnButtonSignal;

@end
