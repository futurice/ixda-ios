//
//  IXDATalkDetailViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 20/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDATalkDetailViewController.h"
#import "IXDASpeakerInformationDetailView.h"
#import "IXDASessionDetailBar.h"
#import "IXDASocialEventDetailBar.h"
#import "IXDASessionDetailsViewModel.h"

#import "UIColor+IXDA.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDATalkDetailViewController ()

@property (nonatomic, strong) IXDASessionDetailsViewModel *viewModel;

@end

@implementation IXDATalkDetailViewController

- (instancetype)initWithViewModel:(IXDASessionDetailsViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    
    self.view.backgroundColor = [UIColor ixda_statusBarBackgroundColorA];

    CGFloat statusBarHeight = 20.0;
    CGFloat titleBarHeight = 220.0;
    
    UIView *generalNavigationView;
    
    if ([self.viewModel.sessionType isEqualToString:@"Social Event"]) {
        IXDASocialEventDetailBar *navigationView = [[IXDASocialEventDetailBar alloc] initWithTitle:self.viewModel.sessionName venue:self.viewModel.venueName date:self.viewModel.date time:self.viewModel.startToEndTime];

        @weakify(self)
        [navigationView.backButtonSignal subscribeNext:^(id x) {
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
        generalNavigationView = navigationView;
    } else {
        IXDASessionDetailBar *navigationView = [[IXDASessionDetailBar alloc] initWithTitle:self.viewModel.sessionName   venue:self.viewModel.venueName date:self.viewModel.startToEndTime];
        @weakify(self)
        [navigationView.backButtonSignal subscribeNext:^(id x) {
            @strongify(self)
            [self.navigationController popViewControllerAnimated:YES];
        }];
        generalNavigationView = navigationView;
    }
    [self.view addSubview:generalNavigationView];
    [generalNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusBarHeight);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(titleBarHeight));
    }];
    
    if (self.viewModel.speakers > 0) {
        NSString *name = [self.viewModel speakerNameFromIndex:0];
        NSString *company = [self.viewModel companyNameFromIndex:0];
        NSString *description = [self.viewModel descriptionNameFromIndex:0];
        IXDASpeakerInformationDetailView *speakersInformationView = [[IXDASpeakerInformationDetailView alloc] initWithName:name company:company description:description];
        [self.view addSubview:speakersInformationView];
        [speakersInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(generalNavigationView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }

    
    return self;
}

@end
