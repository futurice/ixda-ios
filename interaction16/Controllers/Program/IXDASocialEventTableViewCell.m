//
//  IXDASocialEventTableViewCell.m
//  interaction16
//
//  Created by Martin Hartl on 22/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASocialEventTableViewCell.h"

#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>

@interface IXDASocialEventTableViewCell ()

@property (nonatomic, strong) UIView *dayBackgroundView;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *locationLabel;

@end

@implementation IXDASocialEventTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.dayBackgroundView = [[UIView alloc] init];
    self.dayBackgroundView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:self.dayBackgroundView];
    
    [self.dayBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(108);
        make.top.equalTo(self.contentView).offset(32);
        make.left.equalTo(self.contentView);
    }];
    
    self.dayLabel = [[UILabel alloc] init];
    self.dayLabel.textColor = [UIColor whiteColor];
    self.dayLabel.font = [UIFont ixda_socialCellDateFont];
    [self.dayBackgroundView addSubview:self.dayLabel];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.dayBackgroundView).insets(UIEdgeInsetsMake(0, 16, 0, 0));
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont ixda_socialCellDateFont];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.top.equalTo(self.contentView).offset(32);
        make.left.equalTo(self.dayBackgroundView.mas_right).offset(10);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont ixda_programCellTitle];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(82);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.textColor = [UIColor blackColor];
    self.locationLabel.font = [UIFont ixda_sessionDetailsDescription];
    self.locationLabel.numberOfLines = 0;
    [self.contentView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-22);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(10);
    }];
    
    UIView * additionalSeparator = [[UIView alloc] init];
    additionalSeparator.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:additionalSeparator];
    [additionalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@4);
        make.left.right.equalTo(self.contentView);
    }];
    
    return self;
}

- (void)setDay:(NSString *)dayString time:(NSString *)timeString {
    self.dayLabel.text = dayString;
    self.timeLabel.text = timeString;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setLocationName:(NSString *)locationName {
    self.locationLabel.text = locationName;
}

@end
