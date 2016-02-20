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
#import "IXDATalksNavigationView.h"

#import "IXDASessionsViewModel.h"
#import "IXDASessionStore.h"
#import "Speaker.h"
#import "Session.h"
#import "UIColor+IXDA.h"
#import "UIFont+IXDA.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *IXDA_PROGRAMTABLEVIEWCELL = @"IDXA_TALKSTABLEVIEWCELL";
static NSString *IXDA_SPEAKERSTABLEVIEWCELL = @"IDXA_SPEAKERSTABLEVIEWCELL";

@interface IXDATalksViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) IXDASessionsViewModel *viewModel;
@property (nonatomic, strong) NSArray *talksArray;
@property (nonatomic, strong) NSNumber *talkType; // TalkType
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
        @strongify(self)
        self.talkType = talkType;
    }];
    
    [RACObserve(self, talkType) subscribeNext:^(NSNumber *talkType) {
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
    
    Session *session = [self talkAtIndexPath:indexPath];
    if (self.talkType.unsignedIntegerValue == TalkTypeKeyNote) {
        IXDASpeakersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IXDA_SPEAKERSTABLEVIEWCELL];
        Speaker *speaker = [self speaker:session.speakers];
        [cell setName:speaker.name];
        [cell setJob:speaker.position];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        if  (speaker.avatarURL && speaker.avatarURL.length > 10) {
            [cell.backgroundImageView setImageWithURL:[NSURL URLWithString:speaker.avatarURL] placeholderImage:placeholderImage];
        }
        return cell;
    }
    else {
        IXDATalksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IXDA_PROGRAMTABLEVIEWCELL];
        
        [cell setTitle:session.name];
        [cell setSpeaker:session.speakers];
        cell.backgroundColor = ((indexPath.row % 2 == 0)
                                ? [UIColor ixda_baseBackgroundColorA]
                                : [UIColor ixda_baseBackgroundColorB]);
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  200;
}

#pragma mark - Helpers

- (Session *)talkAtIndexPath:(NSIndexPath *)indexPath {
    return self.talksArray[indexPath.row];
}

- (Speaker *)speaker:(NSString *)name {
    return self.viewModel.speakers[name];
}

@end
