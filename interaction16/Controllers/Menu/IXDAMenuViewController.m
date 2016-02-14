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
#import "IXDAWhatElseIsOnView.h"

#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDAMenuViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation IXDAMenuViewController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    // Otherwise ScrollView has an initial offset on top
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    
    IXDAMenuView *menuView = [[IXDAMenuView alloc] init];
    [self.scrollView addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.view);
        make.top.equalTo(self.scrollView.mas_top);
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
        @strongify(self);
        [self.scrollView setContentOffset:CGPointMake(0.0f, self.scrollView.frame.size.height) animated:YES];
    }];
    
    
    
    IXDAWhatElseIsOnView  *whatElseIsOnView = [[IXDAWhatElseIsOnView alloc] init];
    [self.scrollView addSubview:whatElseIsOnView];
    [whatElseIsOnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(menuView.mas_bottom);
        make.left.right.height.equalTo(menuView);
        make.bottom.equalTo(self.scrollView.mas_bottom);
    }];
    
    [whatElseIsOnView.backToMenuButtonSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
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

#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scrollView.contentOffset = CGPointMake(0.0, 0.0);
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
