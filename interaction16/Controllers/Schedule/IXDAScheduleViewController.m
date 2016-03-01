//
//  IXDAScheduleViewController.m
//  interaction16
//
//  Created by Erich Grunewald on 01/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAScheduleViewController.h"
#import "IXDAScheduleNavigationView.h"

#import "IXDASessionsViewModel.h"
#import "UIColor+IXDA.h"
#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDAScheduleViewController ()

@property (nonatomic, strong) IXDASessionsViewModel *viewModel;

@end

@implementation IXDAScheduleViewController

#pragma mark - Life Cycle

- (instancetype)initWithSessionsViewModel:(IXDASessionsViewModel *)sessionsViewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = sessionsViewModel;
    
    self.view.backgroundColor = [UIColor ixda_statusBarBackgroundColorB];
    
    CGFloat titleBarHeight = 130.0;
    
    // Normally you would get dates on which there are talks directly from the
    // view model, like so:
    //
    // NSArray *days = [self.viewModel talkDays];
    //
    // However, since we wish only wish to include 03-01 to 03-04 (even though
    // there are talks on other dates, too), we hardcode the days here.
    
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    });
    
    NSArray *days = [[[@[@"2016-03-01", @"2016-03-02", @"2016-03-03", @"2016-03-04"] rac_sequence] map:^id(NSString *dateString) {
        return [_dateFormatter dateFromString:dateString];
    }] array];
    
    IXDAScheduleNavigationView *navigationView = [[IXDAScheduleNavigationView alloc] initWithDays:days];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(titleBarHeight));
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
