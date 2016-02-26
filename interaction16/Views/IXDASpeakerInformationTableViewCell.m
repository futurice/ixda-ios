//
//  IXDASpeakerInformationTableViewCell.m
//  interaction16
//
//  Created by Martin Hartl on 22/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakerInformationTableViewCell.h"

#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>

@interface IXDASpeakerInformationTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *companyLabel;

@end

@implementation IXDASpeakerInformationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont ixda_sessionDetailsTitle];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    self.companyLabel = [[UILabel alloc] init];
    self.companyLabel.textColor = [UIColor blackColor];
    self.companyLabel.font = [UIFont ixda_speakersCellSubTitle];
    [self.contentView addSubview:self.companyLabel];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    
    return self;
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (void)setCompany:(NSString *)company {
    self.companyLabel.text = company;
}

@end
