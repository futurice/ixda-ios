//
//  WhatElseIsOnViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "WhatElseIsOnViewController.h"

#import "UIColor+IDXA.h"

@implementation WhatElseIsOnViewController


#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.view.backgroundColor = [UIColor idxa_statusBarBackgroundColorA];;
    
    return self;
}

@end
