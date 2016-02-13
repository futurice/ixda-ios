//
//  IDXAProgramViewController.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAProgramViewController.h"
#import "IXDAProgramTableViewCell.h"

#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>

static NSString *IXDA_PROGRAMTABLEVIEWCELL = @"IDXA_PROGRAMTABLEVIEWCELL";

@interface IXDAProgramViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation IXDAProgramViewController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
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
    
    return self;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IXDAProgramTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IXDA_PROGRAMTABLEVIEWCELL];
    
    cell.backgroundColor = ((BOOL)indexPath.row % 2
                            ? [UIColor ixda_baseBackgroundColorA]
                            : [UIColor ixda_baseBackgroundColorB]);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  100;
}


@end
