//
//  FestMapViewController.m
//  FestApp
//
//  Created by Oleg Grenrus on 10/06/14.
//  Copyright (c) 2014 Futurice Oy. All rights reserved.
//

#import "IXDAMapViewController.h"

#import "IXDATitleBarView.h"

#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDAMapViewController ()  <UIScrollViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *mapView;

@end

@implementation IXDAMapViewController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.view.backgroundColor = [UIColor ixda_statusBarBackgroundColorB];
    
    CGFloat statusBarHeight = 20.0;
    CGFloat titleBarHeight = 50.0;
    
    IXDATitleBarView *navigationView = [[IXDATitleBarView alloc] initWithTitle:@"Map"];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusBarHeight);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(titleBarHeight));
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.bounces = NO;
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    self.mapView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map"]];
    [self.scrollView addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
    }];
    
    
    
    CGFloat minimumZoomScale = (self.view.frame.size.height - (statusBarHeight + titleBarHeight)) / self.mapView.image.size.height;
    CGFloat maxZoomScale = 2.0f;
    self.scrollView.minimumZoomScale = minimumZoomScale;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        CGFloat zoomScale = self.scrollView.zoomScale;
        if (zoomScale > minimumZoomScale) {
            [self.scrollView setZoomScale:minimumZoomScale animated:YES];
        } else {
            [self.scrollView setZoomScale:maxZoomScale animated:YES];
        }
    }];
    
    @weakify(self)
    [navigationView.backButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    return self;
}

#pragma mark - Appearance

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - View Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
}

#pragma mark - UIScrollViewDelegate

-(void) scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect cFrame = self.view.frame;
    cFrame.origin = CGPointZero;
    self.view.frame = cFrame;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mapView;
}

@end
