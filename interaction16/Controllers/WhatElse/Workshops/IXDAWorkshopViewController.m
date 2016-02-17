//
//  IXDAWorkshopViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 17/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAWorkshopViewController.h"
#import "IXDATitleBarView.h"
#import "IXDATalksTableViewCell.h"
#import "IXDASessionsViewModel.h"

#import "Session.h"

#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *IDXA_WORKSHOPTABLEVIEWCELL = @"IDXA_WORKSHOPTABLEVIEWCELL";

@interface IXDAWorkshopViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IXDASessionsViewModel *viewModel;
@property (nonatomic, strong) NSArray *workshopsArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation IXDAWorkshopViewController

- (instancetype)initWithSessionsViewModel:(IXDASessionsViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    
    self.view.backgroundColor = [UIColor ixda_statusBarBackgroundColorB];
    
    IXDATitleBarView *navigationView = [[IXDATitleBarView alloc] initWithTitle:@"Workshops"];
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
    
    [RACObserve(self.viewModel, workshopsArray) subscribeNext:^(NSNumber *talkType) {
        self.workshopsArray = self.viewModel.workshopsArray;
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:IXDATalksTableViewCell.class forCellReuseIdentifier:IDXA_WORKSHOPTABLEVIEWCELL];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [[RACObserve(self, workshopsArray) deliverOnMainThread] subscribeNext:^(id x) {
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
    return [self.workshopsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IXDATalksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDXA_WORKSHOPTABLEVIEWCELL];
    
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
    return self.workshopsArray[indexPath.row];
}

@end
