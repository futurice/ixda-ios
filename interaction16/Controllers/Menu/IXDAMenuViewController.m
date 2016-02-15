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
@property (nonatomic, strong) IXDAMenuView *menuView;
@property (nonatomic, strong) IXDAWhatElseIsOnView *whatElseIsOnView;

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

    [self setupMenuView];
    [self setupWhatElseIsOnView];

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

#pragma mark - Private Helpers

- (void)setupMenuView {
    self.menuView = [[IXDAMenuView alloc] init];
    [self.scrollView addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.view);
        make.top.equalTo(self.scrollView.mas_top);
    }];
    
    @weakify(self)
    [self.menuView.programButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        IXDAProgramViewController *vc = [[IXDAProgramViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.menuView.speakersButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        IXDASpeakersViewController *vc = [[IXDASpeakersViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.menuView.venueAndMapButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        IXDAMapViewController *vc = [[IXDAMapViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.menuView.whatElseIsOnButtonSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.scrollView setContentOffset:CGPointMake(0.0f, self.scrollView.frame.size.height) animated:YES];
    }];
    
    [self.menuView.sponsoringImageViewSignal subscribeNext:^(id x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://futurice.com"]];
    }];
}

- (void)setupWhatElseIsOnView {
    self.whatElseIsOnView = [[IXDAWhatElseIsOnView alloc] init];
    [self.scrollView addSubview:self.whatElseIsOnView];
    [self.whatElseIsOnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom);
        make.left.right.height.equalTo(self.menuView);
        make.bottom.equalTo(self.scrollView.mas_bottom);
    }];
    
    @weakify(self)
    [self.whatElseIsOnView.backToMenuButtonSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
    }];
    
    [self.whatElseIsOnView.educationButtonSignal subscribeNext:^(id x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://edusummit.ixda.org"]];
    }];
    
    [self.whatElseIsOnView.awardsButtonSignal subscribeNext:^(id x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sdc.ixda.org"]];
    }];
    
    [self.whatElseIsOnView.challengeButtonSignal subscribeNext:^(id x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sdc.ixda.org"]];
    }];
    
    [self.whatElseIsOnView.sponsoringImageViewSignal subscribeNext:^(id x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://futurice.com"]];
    }];
}

@end
