//
//  IDXAProgramViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAProgramViewController.h"
#import "IXDAProgramTableViewCell.h"

#import "IXDASessionsViewModel.h"
#import "IXDASessionStore.h"
#import "Session.h"
#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *IXDA_PROGRAMTABLEVIEWCELL = @"IDXA_PROGRAMTABLEVIEWCELL";

@interface IXDAProgramViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IXDASessionsViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation IXDAProgramViewController

- (instancetype)initWithSessionsViewModel:(IXDASessionsViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:IXDAProgramTableViewCell.class
           forCellReuseIdentifier:IXDA_PROGRAMTABLEVIEWCELL];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [[RACObserve(self.viewModel, workshopsArray) deliverOnMainThread] subscribeNext:^(id x) {
        NSLog(@"Array changed");
        [self.tableView reloadData];
    }];
    
    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.keynotesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IXDAProgramTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IXDA_PROGRAMTABLEVIEWCELL];
    
    Session *session = [self keyNoteAtIndexPath:indexPath];
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

- (Session *)keyNoteAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.workshopsArray[indexPath.row];
}


@end
