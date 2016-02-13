//
//  WhatElseIsOnViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IDXAWhatElseIsOnViewController.h"
#import "IDXAWhatElseIsOnView.h"

#import "UIColor+IDXA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IDXAWhatElseIsOnViewController


#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.view.backgroundColor = [UIColor idxa_baseBackgroundColorA];

    IDXAWhatElseIsOnView *whatElseIsOnView = [[IDXAWhatElseIsOnView alloc] init];
    [self.view addSubview:whatElseIsOnView];
    [whatElseIsOnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self);
    [whatElseIsOnView.backToMenuButtonSignal subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [whatElseIsOnView.educationButtonSignal subscribeNext:^(id x) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://edusummit.ixda.org"]];
    }];
    
    [whatElseIsOnView.awardsButtonSignal subscribeNext:^(id x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sdc.ixda.org"]];
    }];
    
    [whatElseIsOnView.challengeButtonSignal subscribeNext:^(id x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sdc.ixda.org"]];
    }];
    
    return self;
}


#pragma mark - Appearance

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
