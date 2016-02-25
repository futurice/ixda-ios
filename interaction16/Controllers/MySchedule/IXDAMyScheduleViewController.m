//
//  IXDAMyScheduleViewController.m
//  interaction16
//
//  Created by Erich Grunewald on 23/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAMyScheduleViewController.h"

#import "IXDATitleBarView.h"
#import "IXDATalksTableViewCell.h"
#import "IXDASessionsViewModel.h"
#import "IXDATalkDetailViewController.h"
#import "IXDAMyScheduleEmptyStateView.h"

#import "Session.h"

#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *IDXA_MYSCHEDULETABLEVIEWCELL = @"IDXA_MYSCHEDULETABLEVIEWCELL";

@interface IXDAMyScheduleViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IXDASessionsViewModel *viewModel;
@property (nonatomic, strong) NSArray *starredTalksArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *emptyStateView;

@end

@implementation IXDAMyScheduleViewController

- (instancetype)initWithSessionsViewModel:(IXDASessionsViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    
    self.view.backgroundColor = [UIColor ixda_statusBarBackgroundColorB];
    
    IXDATitleBarView *navigationView = [[IXDATitleBarView alloc] initWithTitle:@"My Schedule"];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    @weakify(self)
    [navigationView.backButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.viewModel.starredTalks subscribeNext:^(NSArray *starredSessions) {
        self.starredTalksArray = starredSessions;
    }];
    
    // Set up table view.
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor ixda_baseBackgroundColorB];
    self.tableView.backgroundView = nil;
    [self.tableView registerClass:IXDATalksTableViewCell.class forCellReuseIdentifier:IDXA_MYSCHEDULETABLEVIEWCELL];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    // Set up empty state view.
    self.emptyStateView = [[IXDAMyScheduleEmptyStateView alloc] initWithTitle:NSLocalizedString(@"Nothing saved yet", @"String for title in empty state view for starred talks (My Schedule)") message:NSLocalizedString(@"Create your own talk schedule by tapping the star icon next to the talks you wouldn't want to miss.", @"String for message in empty state view for starred talks (My Schedule)")];
    self.emptyStateView.hidden = YES;
    [self.view addSubview:self.emptyStateView];
    [self.emptyStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [[RACObserve(self, starredTalksArray) deliverOnMainThread] subscribeNext:^(id x) {
        [self.tableView reloadData];
        
        // Show empty state view if there are no starred talks.
        self.emptyStateView.hidden = self.starredTalksArray.count > 0;
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
    return [self.starredTalksArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IXDATalksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDXA_MYSCHEDULETABLEVIEWCELL];
    [cell showStar:NO];
    Session *session = [self talkAtIndexPath:indexPath];
    [cell setTitle:session.name];
    [cell setSpeaker:session.speakers];
    cell.backgroundColor = ((indexPath.row % 2 == 0)
                            ? [UIColor ixda_baseBackgroundColorA]
                            : [UIColor ixda_baseBackgroundColorB]);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IXDASessionDetailsViewModel *detailViewModel = [self.viewModel sessionsDetailViewModelOfArray:self.starredTalksArray forIndex:indexPath.row];
    IXDATalkDetailViewController *vc = [[IXDATalkDetailViewController alloc] initWithViewModel:detailViewModel];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helpers

- (Session *)talkAtIndexPath:(NSIndexPath *)indexPath {
    return self.starredTalksArray[indexPath.row];
}

@end
