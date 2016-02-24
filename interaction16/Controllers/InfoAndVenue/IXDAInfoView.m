//
//  IXDAInfoView.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 19/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAInfoView.h"
#import "IXDAInfoTableViewCell.h"
#import <Masonry/Masonry.h>
#import "UIFont+IXDA.h"

@interface IXDAInfoView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation IXDAInfoView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return IXDAInfoCellTypesCounter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case IXDAInfoCellTypeHeader:
            return 200;
            break;
        case IXDAInfoCellTypeSocial:
            return 220;
            break;
        case IXDAInfoCellTypeVenue:
            return 440;
            break;
        case IXDAInfoCellTypeInfrastructure:
            return 920;
            break;
        case IXDAInfoCellTypeCodeOfConduct:
            return 240;
            break;
        case IXDAInfoCellTypeSponsors:
            return 580;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IXDAInfoCellType cellType = indexPath.row;
    return [[IXDAInfoTableViewCell alloc] initWitInfoCellType:cellType];
}

@end
