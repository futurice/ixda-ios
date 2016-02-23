//
//  IXDASpeakersViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakersViewController.h"
#import "IXDASpeakersTableViewCell.h"
#import "IXDATitleBarView.h"
#import "IXDASpeakerViewModel.h"
#import "Speaker.h"
#import "IXDASpeakerDetailViewController.h"

#import "UIColor+IXDA.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *IXDA_SPEAKERSTABLEVIEWCELL = @"IDXA_SPEAKERSTABLEVIEWCELL";

@interface IXDASpeakersViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IXDASpeakerViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation IXDASpeakersViewController

#pragma mark - Life Cycle

- (instancetype)initWithSpeakersViewModel:(IXDASpeakerViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    
    self.view.backgroundColor = [UIColor ixda_statusBarBackgroundColorB];
    
    CGFloat statusBarHeight = 20.0;
    CGFloat titleBarHeight = 50.0;
    
    IXDATitleBarView *navigationView = [[IXDATitleBarView alloc] initWithTitle:@"Speakers"];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(statusBarHeight);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(titleBarHeight));
    }];

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:IXDASpeakersTableViewCell.class
           forCellReuseIdentifier:IXDA_SPEAKERSTABLEVIEWCELL];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [RACObserve(self.viewModel, speakerArray) subscribeNext:^(id x) {
        [self.tableView reloadData];
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

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.speakerArray count];;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IXDASpeakersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IXDA_SPEAKERSTABLEVIEWCELL];
    [cell showStar:NO];
    Speaker *speaker = [self speakerAtIndexPath:indexPath];
    [cell setName:speaker.name];
    [cell setJob:speaker.position];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    if  (speaker.avatarURL && speaker.avatarURL.length > 10) {
        [cell.backgroundImageView setImageWithURL:[NSURL URLWithString:speaker.avatarURL] placeholderImage:placeholderImage];
    } else {
        cell.backgroundImageView.image = placeholderImage;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  240;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IXDASpeakerDetailViewModel *detailViewModel = [self.viewModel speakerDetailViewModelOfArray:self.viewModel.speakerArray forIndex:indexPath.row];
    IXDASpeakerDetailViewController *vc = [[IXDASpeakerDetailViewController alloc] initWithViewModel:detailViewModel];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helpers

- (Speaker *)speakerAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.speakerArray[indexPath.row];
}


@end
