//
//  IXDASpeakerDetailBar.h
//  interaction16
//
//  Created by Erich Grunewald on 23/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface IXDASpeakerDetailBar : UIView

@property (nonatomic, strong) RACSignal *backButtonSignal;

- (instancetype)initWithImageURL:(NSString *)url;

@end
