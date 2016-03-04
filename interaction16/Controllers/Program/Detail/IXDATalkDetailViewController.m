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
#import "UIFont+IXDA.h"
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
        IXDASessionDetailBar *navigationView = [[IXDASessionDetailBar alloc] initWithTitle:self.viewModel.sessionName   venue:self.viewModel.venueName date:self.viewModel.dayAndTime];
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
    
    
    if (self.viewModel.speakers.count > 0) {
        NSString *description = [self.viewModel descriptionNameFromIndex:0];
        IXDASpeakerInformationDetailView *speakersInformationView = [[IXDASpeakerInformationDetailView alloc] initWithNames:self.viewModel.speakerNames companies:self.viewModel.speakerCompanies description:description];
        [self.view addSubview:speakersInformationView];
        [speakersInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(generalNavigationView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    
    UIButton *favoritesButton = [[UIButton alloc] init];
    favoritesButton.backgroundColor = [UIColor blackColor];
    [favoritesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];;
    favoritesButton.titleLabel.font = [UIFont ixda_sessionDetailsSubTitle];
    [favoritesButton setTitle:@"Add to my schedule" forState:UIControlStateNormal];
    [self.view addSubview:favoritesButton];
    
    if (viewModel.starred) {
        [favoritesButton setTitle:@"Remove from my schedule" forState:UIControlStateNormal];
    } else {
        [favoritesButton setTitle:@"Add to my schedule" forState:UIControlStateNormal];
    }
    
    [favoritesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(230);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
    }];
    
    [[favoritesButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        if (viewModel.starred) {
            [viewModel setStarred:NO];
            [favoritesButton setTitle:@"Add to my schedule" forState:UIControlStateNormal];
        } else {
            [viewModel setStarred:YES];
            [favoritesButton setTitle:@"Remove from my schedule" forState:UIControlStateNormal];
        }
        
    }];

    
    return self;
}

@end
