//
//  IXDATitleBarView.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 17/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface IXDATitleBarView : UIView

@property (nonatomic, strong) RACSignal *backButtonSignal;

- (instancetype)initWithTitle:(NSString *)title;

@end
