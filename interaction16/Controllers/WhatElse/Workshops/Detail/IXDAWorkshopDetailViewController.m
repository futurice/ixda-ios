//
//  IXDAWorkshopDetailViewController.m
//  interaction16
//
//  Created by Erich Grunewald on 23/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAWorkshopDetailViewController.h"
#import "IXDASessionDetailsViewModel.h"
#import "IXDASpeakerInformationDetailView.h"
#import "IXDASessionDetailBar.h"

#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDAWorkshopDetailViewController ()

@property (nonatomic, strong) IXDASessionDetailsViewModel *viewModel;

@end

@implementation IXDAWorkshopDetailViewController

- (instancetype)initWithViewModel:(IXDASessionDetailsViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    
    self.view.backgroundColor = [UIColor ixda_statusBarBackgroundColorA];
    
    CGFloat statusBarHeight = 20.0;
    CGFloat titleBarHeight = 220.0;
    
    UIView *generalNavigationView;
    
    IXDASessionDetailBar *navigationView = [[IXDASessionDetailBar alloc] initWithTitle:self.viewModel.sessionName   venue:self.viewModel.venueName date:self.viewModel.dayAndTime];
    @weakify(self)
    [navigationView.backButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    generalNavigationView = navigationView;
    
    [self.view addSubview:generalNavigationView];
    [generalNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusBarHeight);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(titleBarHeight));
    }];
    
    
    if (self.viewModel.speakers > 0) {
        NSString *description = [self.viewModel descriptionNameFromIndex:0];
        IXDASpeakerInformationDetailView *speakersInformationView = [[IXDASpeakerInformationDetailView alloc] initWithNames:self.viewModel.speakerNames companies:self.viewModel.speakerCompanies description:description];
        [self.view addSubview:speakersInformationView];
        [speakersInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(generalNavigationView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    
    
    return self;
}

@end
