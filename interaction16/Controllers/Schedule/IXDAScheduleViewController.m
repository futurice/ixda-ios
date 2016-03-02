//
//  IXDAScheduleViewController.m
//  interaction16
//
//  Created by Erich Grunewald on 01/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAScheduleViewController.h"
#import "IXDAScheduleNavigationView.h"
#import "IXDAScheduleTimelineView.h"

#import "IXDASessionsViewModel.h"
#import "UIColor+IXDA.h"
#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDAScheduleViewController ()

@property (nonatomic, strong) IXDASessionsViewModel *viewModel;
@property (nonatomic, strong) IXDAScheduleNavigationView *navigationView;

// An array of NSDate objects representing the days shown in the schedule.
@property (nonatomic, strong) NSArray *days;

@end

@implementation IXDAScheduleViewController

#pragma mark - Life Cycle

- (instancetype)initWithSessionsViewModel:(IXDASessionsViewModel *)sessionsViewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = sessionsViewModel;
    
    self.view.backgroundColor = [UIColor ixda_statusBarBackgroundColorB];
    
    // Normally you would get dates on which there are talks directly from the
    // view model, like so:
    //
    // self.days = [self.viewModel talkDays];
    //
    // However, since we only wish to include 03-01 through 03-04 (even though
    // there are talks on other dates, too), we hardcode the days here.
    
    self.days = [self.viewModel daysWithStrings:@[@"2016-03-01", @"2016-03-02", @"2016-03-03", @"2016-03-04"]];
    
    // Format day strings for showing in the navigation view's day-selecting menu.
    NSDictionary *dayAttrs = @{NSFontAttributeName:[UIFont ixda_infoCellSubTitleFont],
                               NSForegroundColorAttributeName:[UIColor ixda_infoSubtitleColor]};
    NSDictionary *dateAttrs = @{NSFontAttributeName:[UIFont ixda_socialCellDateFont],
                                NSForegroundColorAttributeName:[UIColor ixda_infoSubtitleColor]};
    NSArray *dayStrings = [self.viewModel attributedDayStringsWithDates:self.days dayAttributes:dayAttrs dateAttributes:dateAttrs];
    
    CGFloat titlBarTopMargin = 20.0;
    CGFloat titleBarBaseHeight = 60.0;
    CGFloat titleBarRowHeight = 44.0;
    CGFloat titleBarBottomPadding = 10.0;
    
    self.navigationView = [[IXDAScheduleNavigationView alloc] initWithDayStrings:dayStrings baseHeight:titleBarBaseHeight rowHeight:titleBarRowHeight];
    [self.view addSubview:self.navigationView];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(titlBarTopMargin);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(titleBarBaseHeight + titleBarRowHeight)); // Only 1 row is visible.
    }];
    
    @weakify(self)
    [self.navigationView.backButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[RACObserve(self.navigationView, expanded) deliverOnMainThread] subscribeNext:^(NSNumber *expanded) {
        @strongify(self)
        // Update the navigation view's height, animating the changes.
        [UIView animateWithDuration:0.2 animations:^{
            NSUInteger visibleRows = [expanded boolValue] ? self.days.count : 1;
            CGFloat height = titleBarBaseHeight + visibleRows * titleBarRowHeight + titleBarBottomPadding;
            [self.navigationView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(height));
            }];
            [self.view layoutIfNeeded];
        }];
    }];
    
    IXDAScheduleViewModel *scheduleViewModel = [self.viewModel scheduleViewModelWithDays:self.days];
    IXDAScheduleTimelineView *timelineView = [[IXDAScheduleTimelineView alloc] initWithScheduleViewModel:scheduleViewModel];
    [self.view addSubview:timelineView];
    [timelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(titlBarTopMargin + titleBarBaseHeight + titleBarRowHeight + titleBarBottomPadding);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    // Make sure navigation view is on top.
    [self.view bringSubviewToFront:self.navigationView];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
