//
//  ViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IDXAMenuViewController.h"

#import "UIColor+IDXA.h"

#import <Masonry/Masonry.h>

@implementation IDXAMenuViewController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.view.backgroundColor = [UIColor idxa_statusBarBackgroundColorA];;
    
    UIView *logoView = [[UIView alloc] init];
    logoView.backgroundColor = [UIColor idxa_baseBackgroundColorA];
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@160);
    }];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    [logoView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(logoView).offset(42);
    }];
    
    
    
    UIView *sponsoringView = [[UIView alloc] init];
    sponsoringView.backgroundColor = [UIColor idxa_baseBackgroundColorA];
    [self.view addSubview:sponsoringView];
    [sponsoringView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@80);
    }];
    
    UIImage *sponsoringImage = [UIImage imageNamed:@"sponsoring"];
    UIImageView *sponsoringImageView = [[UIImageView alloc] initWithImage:sponsoringImage];
    [sponsoringView addSubview:sponsoringImageView];
    [sponsoringImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sponsoringView).offset(42);
        make.centerY.equalTo(sponsoringView);
    }];
    
    
    UIImage *backgroundImage = [UIImage imageNamed:@"backgroundSlice"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [self.view addSubview:backgroundImageView];
    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoView.mas_bottom);
        make.bottom.equalTo(sponsoringView.mas_top);
        make.left.right.equalTo(self.view);
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

@end
