//
//  ViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAMenuViewController.h"
#import "IXDAMenuView.h"

#import "IXDAWhatElseIsOnViewController.h"
#import "IXDAMapViewController.h"

#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDAMenuViewController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.view.backgroundColor = [UIColor ixda_statusBarBackgroundColorA];;
    
    UIView *logoView = [[UIView alloc] init];
    logoView.backgroundColor = [UIColor ixda_baseBackgroundColorA];
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@145);
    }];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    [logoView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(logoView).offset(42);
    }];
    
    
    
    UIView *sponsoringView = [[UIView alloc] init];
    sponsoringView.backgroundColor = [UIColor ixda_baseBackgroundColorA];
    [self.view addSubview:sponsoringView];
    [sponsoringView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@75);
    }];
    
    UIImage *sponsoringImage = [UIImage imageNamed:@"sponsoring"];
    UIImageView *sponsoringImageView = [[UIImageView alloc] initWithImage:sponsoringImage];
    [sponsoringView addSubview:sponsoringImageView];
    [sponsoringImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sponsoringView).offset(62);
        make.bottom.equalTo(sponsoringView).offset(-35);
    }];
    
    
    UIImage *backgroundImage = [UIImage imageNamed:@"backgroundSlice"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoView.mas_bottom);
        make.bottom.equalTo(sponsoringView.mas_top);
        make.left.right.equalTo(self.view);
    }];
    
    IXDAMenuView *menuView = [[IXDAMenuView alloc] init];
    [backgroundImageView addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backgroundImageView);
    }];
    
    @weakify(self)
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
