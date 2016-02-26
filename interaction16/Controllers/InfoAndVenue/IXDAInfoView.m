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
    
    // In iOS 9, calculate row heights dynamically (so that everything looks good on different
    // screen sizes). There's a bug in iOS 8 causing multiline UILabels to get truncated when
    // doing this, so for iOS 8 we use -tableView:heightForRowAtIndexPath:.
    if ([[NSProcessInfo processInfo] operatingSystemVersion].majorVersion >= 9) {
        tableView.estimatedRowHeight = 200;
        tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
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
            return 980;
            break;
        case IXDAInfoCellTypeCodeOfConduct:
            return 240;
            break;
        case IXDAInfoCellTypeSponsors:
            return 760;
            break;
        default:
            return 0;
            break;
    }
}

// Make sure that -tableView:heightForRowAtIndexPath: is called only for iOS 8. In iOS 9, row
// heights are calculated dynamically (rowHeight is set to UITableViewAutomaticDimension).
- (BOOL)respondsToSelector:(SEL)selector {
    static BOOL useSelector;
    static dispatch_once_t predicate = 0;
    dispatch_once(&predicate, ^{
        useSelector = [[NSProcessInfo processInfo] operatingSystemVersion].majorVersion < 9 ? YES : NO;
    });
    
    if (selector == @selector(tableView:heightForRowAtIndexPath:)) {
        return useSelector;
    }
    
    return [super respondsToSelector:selector];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IXDAInfoCellType cellType = indexPath.row;
    return [[IXDAInfoTableViewCell alloc] initWitInfoCellType:cellType];
}

@end
