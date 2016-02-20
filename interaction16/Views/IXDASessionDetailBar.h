//
//  IXDASessionDetailBar.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 20/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface IXDASessionDetailBar : UIView

@property (nonatomic, strong) RACSignal *backButtonSignal;

- (instancetype)initWithTitle:(NSString *)title venue:(NSString *)venue date:(NSString *)date ;

@end
