//
//  IXDAInfoViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 17/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAInfoViewController.h"

#import "IXDATitleBarView.h"

#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDAInfoViewController ()

@end

@implementation IXDAInfoViewController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.view.backgroundColor = [UIColor ixda_statusBarBackgroundColorB];
    
    CGFloat statusBarHeight = 20.0;
    CGFloat titleBarHeight = 50.0;
    
    IXDATitleBarView *navigationView = [[IXDATitleBarView alloc] initWithTitle:@"Info and Venue"];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusBarHeight);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(titleBarHeight));
    }];
    
    UIWebView *webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    NSString *urlAddress = @"http://interaction16.ixda.org/partners/";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    return self;
}

#pragma mark - Appearance

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

@end
