//
//  ViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAMenuViewController.h"
#import "IXDAMenuView.h"

#import "IXDAProgramViewController.h"
#import "IXDASpeakersViewController.h"
#import "IXDAMapViewController.h"
#import "IXDAWhatElseIsOnViewController.h"

#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDAMenuViewController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    IXDAMenuView *menuView = [[IXDAMenuView alloc] init];
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self)
    [menuView.programButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        IXDAProgramViewController *vc = [[IXDAProgramViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [menuView.speakersButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        IXDASpeakersViewController *vc = [[IXDASpeakersViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [menuView.venueAndMapButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        IXDAMapViewController *vc = [[IXDAMapViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];        
    }];
    
    [menuView.whatElseIsOnButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        IXDAWhatElseIsOnViewController *vc = [[IXDAWhatElseIsOnViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
    return self;
}

#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - Appearance

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
