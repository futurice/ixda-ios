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

#import "UIFont+IXDA.h"

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
    CGFloat mapSwitcherHeight = 50.0;
    
    IXDATitleBarView *navigationView = [[IXDATitleBarView alloc] initWithTitle:@"Map"];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusBarHeight);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(titleBarHeight));
    }];
    
    UIView *buttonView = [[UIView alloc] init];
    buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonView];
    
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(mapSwitcherHeight);
    }];
    
    UIButton *firstFloorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstFloorButton.titleLabel.font = [UIFont ixda_infoCellDescriptionFont];
    [firstFloorButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [firstFloorButton setTitleColor:[UIColor ixda_baseBackgroundColorA] forState:UIControlStateSelected];
    [firstFloorButton setTitleColor:[UIColor ixda_baseBackgroundColorA] forState:UIControlStateHighlighted];
    [firstFloorButton setTitle:@"Floor 1" forState:UIControlStateNormal];
    [buttonView addSubview:firstFloorButton];
    [firstFloorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(buttonView);
        make.bottom.equalTo(buttonView);
        make.width.equalTo(buttonView).dividedBy(2);
    }];
    
    firstFloorButton.selected = YES;
    
    UIButton *secondFlootButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondFlootButton.titleLabel.font = [UIFont ixda_infoCellDescriptionFont];
    [secondFlootButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [secondFlootButton setTitleColor:[UIColor ixda_baseBackgroundColorA] forState:UIControlStateHighlighted];
    [secondFlootButton setTitleColor:[UIColor ixda_baseBackgroundColorA] forState:UIControlStateSelected];
    [secondFlootButton setTitle:@"Floor 2" forState:UIControlStateNormal];
    [buttonView addSubview:secondFlootButton];
    [secondFlootButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(buttonView);
        make.bottom.equalTo(buttonView);
        make.width.equalTo(buttonView).dividedBy(2);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.bounces = NO;
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    self.mapView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map1"]];
    [self.scrollView addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
    }];
    
    @weakify(self);
    [[firstFloorButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        secondFlootButton.selected = NO;
        button.selected = YES;
        @strongify(self)
        [self.mapView setImage:[UIImage imageNamed:@"map1"]];
    }];

    [[secondFlootButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        firstFloorButton.selected = NO;
        button.selected = YES;
        @strongify(self)
        [self.mapView setImage:[UIImage imageNamed:@"map2"]];
    }];
    
    CGFloat minimumZoomScale = (self.view.frame.size.height - (statusBarHeight + titleBarHeight + mapSwitcherHeight)) / self.mapView.image.size.height;
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
