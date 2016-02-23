//
//  IXDASpeakerDetailViewController.m
//  interaction16
//
//  Created by Erich Grunewald on 23/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakerDetailViewController.h"
#import "IXDASpeakerDetailViewModel.h"
#import "IXDASpeakerDetailBar.h"
#import "IXDASpeakerDetailView.h"

#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDASpeakerDetailViewController ()

@property (nonatomic, strong) IXDASpeakerDetailViewModel *viewModel;

@end

@implementation IXDASpeakerDetailViewController

- (instancetype)initWithViewModel:(IXDASpeakerDetailViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    
    // TODO: This should probably not use the timeline's background color (or name should be changed)?
    self.view.backgroundColor = [UIColor ixda_timelineBackgroundColor];
    
    CGFloat statusBarHeight = 20.0;
    CGFloat titleBarHeight = 220.0;
    
    IXDASpeakerDetailBar *navigationView = [[IXDASpeakerDetailBar alloc] initWithImageURL:self.viewModel.speakerAvatarURL];
    @weakify(self)
    [navigationView.backButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusBarHeight);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(titleBarHeight));
    }];
    
    IXDASpeakerDetailView *speakerDetailView = [[IXDASpeakerDetailView alloc] initWithName:self.viewModel.speakerName position:self.viewModel.speakerPosition company:self.viewModel.speakerCompany description:self.viewModel.speakerAbout];
    [self.view addSubview:speakerDetailView];
    [speakerDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    return self;
}

@end
