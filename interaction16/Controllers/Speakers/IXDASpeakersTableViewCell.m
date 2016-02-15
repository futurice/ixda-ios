//
//  IXDASpeakersTableViewCell.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakersTableViewCell.h"

#import "UIColor+IXDA.h"
#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>

@interface IXDASpeakersTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobLabel;

@end

@implementation IXDASpeakersTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UIView *blurView = [[UIView alloc] init];
    blurView.alpha = 0.5;
    blurView.backgroundColor = [UIColor ixda_statusBarBackgroundColorA];
    [self.backgroundImageView addSubview:blurView];
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.jobLabel = [[UILabel alloc] init];
    self.jobLabel.numberOfLines = 0;
    self.jobLabel.textColor = [UIColor whiteColor];
    self.jobLabel.font = [UIFont ixda_speakersCellSubTitle];
    [self.contentView addSubview:self.jobLabel];
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont ixda_speakersCellTitle];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.jobLabel.mas_top);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView);
    }];

    
    return self;
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (void)setJob:(NSString *)job {
    self.jobLabel.text = job;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
