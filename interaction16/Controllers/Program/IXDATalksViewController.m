//
//  IDXAProgramViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDATalksViewController.h"
#import "IXDATalksTableViewCell.h"
#import "IXDATalksNavigationView.h"

#import "IXDASessionsViewModel.h"
#import "IXDASessionStore.h"
#import "Session.h"
#import "UIColor+IXDA.h"
#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *IXDA_PROGRAMTABLEVIEWCELL = @"IDXA_TALKSTABLEVIEWCELL";

@interface IXDATalksViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) IXDASessionsViewModel *viewModel;
@property (nonatomic, strong) NSArray *talksArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation IXDATalksViewController

#pragma mark - Life Cycle

- (instancetype)initWithSessionsViewModel:(IXDASessionsViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    
    self.view.backgroundColor = [UIColor ixda_statusBarBackgroundColorB];
    
    IXDATalksNavigationView *navigationView = [[IXDATalksNavigationView alloc] init];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@130);
    }];
    
    @weakify(self)
    [navigationView.backButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [RACObserve(navigationView, talkType) subscribeNext:^(NSNumber *talkType) {
        switch ([talkType unsignedIntegerValue]) {
            case TalkTypeKeyNote:
                self.talksArray = self.viewModel.keynotesArray;
                break;
            case TalkTypeLongTalk:
                self.talksArray = self.viewModel.longTalksArray;
                break;
            case TalkTypeMediumTalk:
                self.talksArray = self.viewModel.mediumTalksArray;
                break;
            case TalkTypeLightningTalk:
                self.talksArray = self.viewModel.lightningTalksArray;
                break;
            default:
                self.talksArray = self.viewModel.keynotesArray;
                break;
        }
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:IXDATalksTableViewCell.class
           forCellReuseIdentifier:IXDA_PROGRAMTABLEVIEWCELL];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navigationView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];

    [[RACObserve(self, talksArray) deliverOnMainThread] subscribeNext:^(id x) {
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

-(void)viewDidLayoutSubviews{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.talksArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IXDATalksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IXDA_PROGRAMTABLEVIEWCELL];
    
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
    return self.talksArray[indexPath.row];
}


@end
