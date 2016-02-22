//
//  IXDASpeakerInformationDetailView.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 20/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakerInformationDetailView.h"

#import "IXDASpeakerInformationTableViewCell.h"
#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>

@interface IXDASpeakerInformationDetailView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *speakerTableView;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *companies;

@end

@implementation IXDASpeakerInformationDetailView

- (instancetype)initWithNames:(NSArray *)names companies:(NSArray *)companies description:(NSString *)description {
    self = [super init];
    if (!self) return nil;
    
    self.names = names;
    self.companies = companies;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.speakerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.speakerTableView.delegate = self;
    self.speakerTableView.dataSource = self;
    [self.speakerTableView registerClass:IXDASpeakerInformationTableViewCell.class forCellReuseIdentifier:@"Cell"];
    [self addSubview:self.speakerTableView];
    
    self.speakerTableView.scrollEnabled = NO;
    [self.speakerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(12);
        make.right.equalTo(self);
        make.left.equalTo(self).offset(12);
        make.height.mas_equalTo(self.names.count * 70);
    }];
    
    UITextView *descriptionLabel = [[UITextView alloc] init];
    descriptionLabel.editable = NO;
    descriptionLabel.font = [UIFont ixda_sessionDetailsDescription];
    descriptionLabel.textColor = [UIColor blackColor];
    descriptionLabel.text = description;
    [self addSubview:descriptionLabel];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.speakerTableView.mas_bottom).offset(15);
    }];
    
    return self;
}

#pragma mark - UITableViewDelegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.companies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IXDASpeakerInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell setName:self.names[indexPath.row]];
    [cell setCompany:self.companies[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
