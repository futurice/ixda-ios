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

#import "Session.h"

#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *IDXA_MYSCHEDULETABLEVIEWCELL = @"IDXA_MYSCHEDULETABLEVIEWCELL";

@interface IXDAMyScheduleViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IXDASessionsViewModel *viewModel;
@property (nonatomic, strong) NSArray *starredTalksArray;
@property (nonatomic, strong) UITableView *tableView;

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
    
    [RACObserve(self.viewModel, sessions) subscribeNext:^(NSNumber *talkType) {
        self.starredTalksArray = [self.viewModel starredTalks];
    }];
    
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
    
    [[RACObserve(self, starredTalksArray) deliverOnMainThread] subscribeNext:^(id x) {
        [self.tableView reloadData];
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

#pragma mark - Helpers

- (Session *)talkAtIndexPath:(NSIndexPath *)indexPath {
    return self.starredTalksArray[indexPath.row];
}

@end
