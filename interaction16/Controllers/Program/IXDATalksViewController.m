//
//  IDXAProgramViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDATalksViewController.h"
#import "IXDATalksTableViewCell.h"
#import "IXDASpeakersTableViewCell.h"
#import "IXDASocialEventTableViewCell.h"
#import "IXDATalksNavigationView.h"
#import "IXDATalkDetailViewController.h"

#import "IXDASessionDetailsViewModel.h"
#import "IXDASessionsViewModel.h"
#import "IXDASessionStore.h"
#import "UIColor+IXDA.h"
#import "UIFont+IXDA.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *IXDA_PROGRAMTABLEVIEWCELL = @"IDXA_TALKSTABLEVIEWCELL";
static NSString *IXDA_SPEAKERSTABLEVIEWCELL = @"IDXA_SPEAKERSTABLEVIEWCELL";
static NSString *IXDA_SOCIALTABLEVIEWCELL = @"IXDA_SOCIALTABLEVIEWCELL";

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
                self.talksArray = [self.viewModel keynotes];
                break;
            case TalkTypeLongTalk:
                self.talksArray = [self.viewModel longTalks];
                break;
            case TalkTypeMediumTalk:
                self.talksArray = [self.viewModel mediumTalks];
                break;
            case TalkTypeLightningTalk:
                self.talksArray = [self.viewModel lightningTalks];
                break;
            case TalkTypeSocialEvent:
                self.talksArray = [self.viewModel socialEvents];
                break;
            default:
                self.talksArray = [self.viewModel keynotes];
                break;
        }
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:IXDATalksTableViewCell.class
           forCellReuseIdentifier:IXDA_PROGRAMTABLEVIEWCELL];
    [self.tableView registerClass:IXDASpeakersTableViewCell.class
           forCellReuseIdentifier:IXDA_SPEAKERSTABLEVIEWCELL];
    [self.tableView registerClass:IXDASocialEventTableViewCell.class forCellReuseIdentifier:IXDA_SOCIALTABLEVIEWCELL];
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
    IXDASessionDetailsViewModel *detailViewModel = [self.viewModel sessionsDetailViewModelOfArray:self.talksArray forIndex:indexPath.row];
    
    if ([[detailViewModel sessionType] isEqualToString:@"Keynote"]) {
        IXDASpeakersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IXDA_SPEAKERSTABLEVIEWCELL];
        [cell setName:[detailViewModel speakerNameFromIndex:0]];
        [cell setJob:[detailViewModel companyNameFromIndex:0]];
        [cell setStarred:[detailViewModel starred]];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        NSString *avatarURL = [detailViewModel speakerIconURLFromIndex:0];
        if  (avatarURL.length > 10) {
            [cell.backgroundImageView setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:placeholderImage];
        } else {
            cell.backgroundImageView.image = placeholderImage;
        }
        
        [cell.starSignal subscribeNext:^(id selected) {
            [detailViewModel setStarred:[selected boolValue]];
        }];
        
        return cell;
    }
    else if ([[detailViewModel sessionType] isEqualToString:@"Social Event"]) {
        IXDASocialEventTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:IXDA_SOCIALTABLEVIEWCELL];
        [cell setDay:detailViewModel.date time:detailViewModel.startToEndTime];
        [cell setTitle:detailViewModel.sessionName];
        [cell setLocationName:detailViewModel.venueName];
        cell.backgroundColor = ((indexPath.row % 2 == 0)
                                ? [UIColor ixda_baseBackgroundColorA]
                                : [UIColor ixda_baseBackgroundColorB]);
        return cell;
    }
    else {
        IXDATalksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IXDA_PROGRAMTABLEVIEWCELL];
        
        [cell setTitle:detailViewModel.sessionName];
        [cell setSpeaker:[[detailViewModel speakerNames] componentsJoinedByString:@", "]];
        [cell setStarred:[detailViewModel starred]];
        cell.backgroundColor = ((indexPath.row % 2 == 0)
                                ? [UIColor ixda_baseBackgroundColorA]
                                : [UIColor ixda_baseBackgroundColorB]);
        
        [cell.starSignal subscribeNext:^(id selected) {
            [detailViewModel setStarred:[selected boolValue]];
        }];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    IXDASessionDetailsViewModel *detailViewModel = [self.viewModel sessionsDetailViewModelOfArray:self.talksArray forIndex:indexPath.row];
    IXDATalkDetailViewController *vc = [[IXDATalkDetailViewController alloc] initWithViewModel:detailViewModel];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  200;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

@end
