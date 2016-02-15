//
//  IXDASpeakersViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakersViewController.h"
#import "IXDASpeakersTableViewCell.h"

#import "IXDASpeakerViewModel.h"
#import "Speaker.h"

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

- (instancetype)initWithSpeakersViewModel:(IXDASpeakerViewModel *)viewModel {
    self = [super init];
    if (!self) return nil;
    
    self.viewModel = viewModel;
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:IXDASpeakersTableViewCell.class
           forCellReuseIdentifier:IXDA_SPEAKERSTABLEVIEWCELL];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [RACObserve(self.viewModel, speakerArray) subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    
    return self;
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

#pragma mark - Helpers

- (Speaker *)speakerAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewModel.speakerArray[indexPath.row];
}


@end
