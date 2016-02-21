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
    
    IXDASessionDetailBar *navigationView = [[IXDASessionDetailBar alloc] initWithTitle:self.viewModel.sessionName   venue:self.viewModel.venueName date:self.viewModel.startToEndTime];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusBarHeight);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(titleBarHeight));
    }];
    
    @weakify(self)
    [navigationView.backButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    if (self.viewModel.speakers > 0) {
        NSString *name = [self.viewModel speakerNameFromIndex:0];
        NSString *company = [self.viewModel companyNameFromIndex:0];
        NSString *description = [self.viewModel descriptionNameFromIndex:0];
        IXDASpeakerInformationDetailView *speakersInformationView = [[IXDASpeakerInformationDetailView alloc] initWithName:name company:company description:description];
        [self.view addSubview:speakersInformationView];
        [speakersInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(navigationView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }

    
    return self;
}

@end
